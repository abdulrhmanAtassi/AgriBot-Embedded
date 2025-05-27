/******************************************************************************
 * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
 * Compiler : mikroC PRO for PIC
 * Fosc     : 20 MHz
 ******************************************************************************/
//#define _XTAL_FREQ 20000000   // only needed if you use __delay_xx – not used here

/* === Pin assignments ===================================================== */
#define TRIG  PORTB.F0    // RB0 – trigger output
#define ECHO  PORTB.F1    // RB1 – echo  input
// Global variables
unsigned int moisture_value;
unsigned int moisture_percentage;
unsigned int blink_counter;



char command;  // Declare this globally or at the top of main

/* === CCP Compare Mode Servo Control ===================================== */

// Global variables for CCP interrupt
unsigned int pulse_width = 3000;  // Current pulse width (1.5ms default)
unsigned char servo_state = 0;    // 0 = low, 1 = high

// CCP1 Interrupt Service Routine
void interrupt() {
    if(PIR1.CCP1IF) {
        PIR1.CCP1IF = 0;  // Clear interrupt flag

        if(servo_state == 0) {
            // Start pulse - set pin HIGH
            PORTC.B4 = 1;
            servo_state = 1;

            // Set compare value for pulse width
            // 8MHz / 4 = 2MHz instruction clock
            // Timer1 1:1 prescaler = 0.5us per count
            CCPR1H = (pulse_width >> 8);
            CCPR1L = pulse_width;
        }
        else {
         unsigned int low_time = 40000 - pulse_width;
            // End pulse - set pin LOW
            PORTC.B4 = 0;
            servo_state = 0;

            // Set compare value for remainder of 20ms period
            // 20ms = 40000 counts at 0.5us per count

            CCPR1H = (low_time >> 8);
            CCPR1L = low_time;
        }
    }
}

// Initialize CCP in Compare mode
void init_ccp_servo() {
    // Configure RC4 as output
    TRISC.B4 = 0;
    PORTC.B4 = 0;

    // Configure Timer1
    T1CON = 0x01;     // Timer1 ON, 1:1 prescaler, internal clock
    TMR1H = 0;
    TMR1L = 0;

    // Configure CCP1 for Compare mode
    CCP1CON = 0x0B;   // Compare mode, trigger special event (reset Timer1)

    // Set initial compare value
    CCPR1H = (pulse_width >> 8);
    CCPR1L = pulse_width;

    // Enable interrupts
    PIR1.CCP1IF = 0;  // Clear CCP1 interrupt flag
    PIE1.CCP1IE = 1;  // Enable CCP1 interrupt
    INTCON.PEIE = 1;  // Enable peripheral interrupts
    INTCON.GIE = 1;   // Enable global interrupts
}

// Set servo angle (0-360 degrees)
void servo_set_angle(unsigned int angle) {
    unsigned long temp;

    // Limit angle
    if(angle > 360) angle = 360;

    // Calculate pulse width
    // 0° = 1000 counts (0.5ms)
    // 360° = 5000 counts (2.5ms)
    temp = 1000 + ((unsigned long)angle * 4000 / 360);

    // Update pulse width (interrupt will use new value on next cycle)
    pulse_width = (unsigned int)temp;
}

// Alternative: Direct register method without interrupts
void servo_angle_direct(unsigned int angle) {
    unsigned int i;
    unsigned long pulse;

    // Calculate pulse width in timer counts
    pulse = 1000 + ((unsigned long)angle * 4000 / 360);

    // Disable interrupts temporarily
    INTCON.GIE = 0;

    // Send 50 pulses
    for(i = 0; i < 50; i++) {
        // Reset Timer1
        TMR1H = 0;
        TMR1L = 0;

        // Set compare value for pulse width
        CCPR1H = pulse >> 8;
        CCPR1L = pulse;

        // Start pulse
        PORTC.B4 = 1;

        // Wait for compare match
        PIR1.CCP1IF = 0;
        while(!PIR1.CCP1IF);

        // End pulse
        PORTC.B4 = 0;

        // Set compare for low period
        CCPR1H = (40000 - pulse) >> 8;
        CCPR1L = (40000 - pulse);

        // Wait for compare match
        PIR1.CCP1IF = 0;
        while(!PIR1.CCP1IF);
    }

    // Re-enable interrupts
    INTCON.GIE = 1;
}

/* === Tiny helpers ======================================================== */
void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
}

/* === Ultrasonic sensor ====================================================*/

// void trigger_pulse(){
//     TRIG = 1;  // Set Trigger pin high
//     delay_us(10);  // 10us pulse
//     TRIG = 0;  // Set Trigger pin low
// }

// unsigned int measure_distance(){
//     unsigned int time = 0;
//     unsigned int timeout;

//     trigger_pulse();

//     // Wait for echo signal to go HIGH
//     timeout = 0xFFFF;
//     while (!(PORTB & 0x02)) {
//         if (--timeout == 0) {
//             return 0;  // Timeout prevention, no object detected
//         }
//     }

//     // Start Timer1
//     TMR1H = 0;
//     TMR1L = 0;
//     T1CON = 0x01;  // Enable Timer1 with no prescaler

//     // Wait for echo signal to go LOW
//     timeout = 0xFFFF;
//     while (PORTB & 0x02) {
//         if (--timeout == 0) {
//             T1CON = 0x00;  // Disable Timer1
//             return 0;  // Timeout prevention
//         }
//     }

//     // Stop Timer1 and calculate time
//     T1CON = 0x00;  // Disable Timer1
//     time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes

//     // Convert time to distance in cm
//    return time / 116u;
// }

void trigger_pulse(){
    TRIG = 1;  // Set Trigger pin high
    delay_us(10);  // 10us pulse
    TRIG = 0;  // Set Trigger pin low
}

unsigned int measure_distance(){
    unsigned int time = 0;
    unsigned int timeout;
    unsigned int timer0_overflow = 0;
    
    trigger_pulse();
    
    // Wait for echo signal to go HIGH
    timeout = 0xFFFF;
    while (!(PORTB & 0x02)) {
        if (--timeout == 0) {
            return 0;  // Timeout prevention, no object detected
        }
    }
    
    // Start Timer0
    TMR0 = 0;              // Clear Timer0 register
    timer0_overflow = 0;   // Reset overflow counter
    INTCON.T0IF = 0;       // Clear Timer0 interrupt flag
    OPTION_REG = 0x80;     // Enable Timer0, internal clock, no prescaler
    
    // Wait for echo signal to go LOW
    timeout = 0xFFFF;
    while (PORTB & 0x02) {
        // Check for Timer0 overflow
        if (INTCON.T0IF) {
            INTCON.T0IF = 0;    // Clear overflow flag
            timer0_overflow++;
            if (timer0_overflow > 200) {  // Prevent excessive overflow
                return 0;  // Timeout prevention
            }
        }
        if (--timeout == 0) {
            return 0;  // Timeout prevention
        }
    }
    
    // Calculate total time
    time = (timer0_overflow * 256) + TMR0;
    
    // Convert time to distance in cm
    // For Timer0 with no prescaler and 20MHz crystal:
    // Each count = 0.8us, sound travels at 343m/s
    // Distance = (time * 0.8us * 343m/s) / 2 / 10000 (convert to cm)
    // Simplified: distance = time / 145 (approximately)
    return time / 145u;
}
/* === Cutter setup =========================================================== */

void initCutter(void) {
     TRISB.F4 = 0;
     PORTB.F4    = 0;
}

void cutter_on(void)  { PORTB.F4 = 1; }
void cutter_off(void) { PORTB.F4 = 0; }


/* === PWM setup =========================================================== */
// void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255 // REMOVED FOR THE SERVO USING THIS
void setSpeed(unsigned char duty) { CCPR2L = duty; }

void setupPWM(void)
{
    /* RC2 = CCP1, RC1 = CCP2  → outputs */
    // TRISC.F2 = 0;   // RC2 // REMOVED FOR THE SERVO USING THIS
    TRISC.F1 = 0;   // RC1

    /* CCP modules in PWM mode */
    // CCP1CON = 0b00001100;     // CCP1 PWM // REMOVED FOR THE SERVO USING THIS
    CCP2CON = 0b00001100;     // CCP2 PWM

    /* Timer2 drives both PWMs  –  about 5 kHz  */
    PR2   = 249;              // period
    T2CON = 0b00000101;       // prescaler 4, TMR2 on

    // setSpeedLeft (128);       // 50 % // REMOVED FOR THE SERVO USING THIS
    setSpeed(128);       // 50 %
}


/* === Motor direction helpers (PORTD pattern) ============================= */
void motors_stop(void)
{
    PORTD = 0x00;
    // setSpeedLeft(0);
    setSpeed(0);
}

void motors_forward(unsigned char left_speed, unsigned char right_speed)
{
    unsigned int distance ;
    while (1) {
        if (UART1_Data_Ready()) {
            command = UART1_Read();
            break;  // break out to handle new command
        }
       distance = measure_distance();
        if (distance < 10u) {
            motors_stop();
        } else {
            PORTD = 0b01011010;  // forward
            // setSpeedLeft(left_speed); // REMOVED FOR THE SERVO USING THIS
            setSpeed(right_speed);
        }
    }
}

void motors_backward(unsigned char left_speed, unsigned char right_speed)
{
    PORTD = 0b10100101;  // Backward direction
    // setSpeedLeft(left_speed); // REMOVED FOR THE SERVO USING THIS
    setSpeed(right_speed);
}

void motors_left(void)
{
    PORTD = 0b01010101;            // turn left
    // setSpeedLeft(150); // REMOVED FOR THE SERVO USING THIS
    setSpeed(150);
}

void motors_right(void)
{
    PORTD = 0b10101010;            // turn right
    // setSpeedLeft(150); // REMOVED FOR THE SERVO USING THIS
    setSpeed(150);
}

/* === Water Bumb ================================================================ */
void init_io(void) {
    TRISB &= 0xBF;     // RB6 output (0b10111111), clears bit 6
    PORTB.F6 = 1;      // relay off (active low input)
}

void relay_control(char state) {
    if(state) {
        PORTB.F6 = 0;  // turn relay ON (active low)
    } else {
        PORTB.F6 = 1;  // turn relay OFF
    }
}

/* === Water Bumb ================================================================ */


void init_adc() {
    // Configure ADC for mikroC
    ADCON1 = 0x80;      // Right justified, all pins analog
    ADCON0 = 0x81;      // Channel 0 selected, ADC ON, Fosc/8

    delay_us(50);       // Allow ADC to stabilize
}

unsigned int read_adc(unsigned char channel) {
    // Select channel (0-7)
    ADCON0 &= 0xC7;              // Clear channel selection bits
    ADCON0 |= (channel << 3);    // Set channel selection bits

    delay_us(20);                // Acquisition time delay

    ADCON0.B2 = 1;               // Start conversion (set GO bit)
    while(ADCON0.B2);            // Wait for conversion complete

    // Return 10-bit result
    return ((unsigned int)ADRESH << 8) | ADRESL;
}

unsigned int read_soil_moisture() {
    // Read analog value from channel 0 (AN0/RA0 pin)
    return read_adc(0);
}


/* === setup ================================================================ */
void delay_ms(unsigned int ms) {
    unsigned int i, j;
    for(i = 0; i < ms; i++) {
        // Approximate 1ms delay for 4MHz clock
        for(j = 0; j < 330; j++) {
            asm nop;
        }
    }
}

void setup(){
      // Configure TRIS registers
    TRISA = 0xFF;   // Port A as input (e.g., RA0 for analog sensor)
    TRISB = 0x02;   // RB1 as input (e.g., sensor), others as output
    TRISC = 0x40;   // RC6 (TX) as input (for USART), others as output
    TRISD = 0x00;   // Port D as output
    TRISE = 0x07;   // RE0-RE2 as input

    // Clear all output ports
    PORTA = 0x00;
    PORTB = 0x00;
    PORTC = 0x00;
    PORTD = 0x00;

    // Initialize LED indicators
    // RB1 = Wet LED (input), RB2 = Dry LED, RB3 = Power LED
    TRISB.B6 = 0;
    PORTB.B6 = 0;
    // Initialize water pump or related hardware
    init_io();

    // Delay to allow system stabilization
    our_delay_ms(100);

    // Optional ADC setup (uncomment when using ADC)
    // ADCON0 = 0x00; // Will be 0x01 before using A/D
    // ADCON1 = 0x00; // Configure ADC module

    // Optional USART and interrupt setup
    // PIR1 = 0x00;   // Clear interrupt flags
    // INTCON = 0x00; // Disable interrupts for now
}

void bluetooth_init() {
    UART1_Init(9600);
     our_delay_ms(100);   // Initialize UART with 9600 baud rate
}
// REPLACE your existing read_soil_moisture function with this:
unsigned int read_soil_moisture_safe() {
    unsigned char old_gie = INTCON.GIE;  // Save interrupt state
     unsigned int result = read_adc(0);
    INTCON.GIE = 0;  // Disable interrupts during ADC
    

    
    INTCON.GIE = old_gie;  // Restore interrupts
    return result;
}

// REPLACE your existing relay_control function with this:
void relay_control_fixed(char state) {
    if(state) {
        PORTB.B6 = 1;   // Turn relay ON (try HIGH first)
    } else {
        PORTB.B6 = 0;   // Turn relay OFF (try LOW first)
    }
    
    // Add small delay for relay switching
    Delay_ms(10);
}
/* === Main ================================================================ */

void main(void)
 {
    unsigned int angle;
    unsigned char i;
    // Initialize system
    setup();
    bluetooth_init();
    initCutter();
    setupPWM();
    init_ccp_servo();

    init_adc();

    blink_counter = 0;
    
    Delay_us(100);
    
     while (1)
     {
        servo_set_angle(0);
        if (UART1_Data_Ready()) {          // Check if data is available
            command = UART1_Read();        // Read one character
            switch(command){
                case 'F':
                    motors_forward(150, 150);
                    break;

                case 'B':
                    motors_backward(100, 100);
                    break;

                case 'R':
                    motors_right();
                    break;

                case 'L':
                     motors_left();

                    break;

                case 'S':
                    motors_stop();
                    break;

                case 'G':   // Forward left
                    motors_forward(100, 150);
                    break;

                case 'H':   // Forward right
                    motors_forward(150, 100);
                    break;

                case 'I':   // Backward left
                    motors_backward(100, 150);
                    break;

                case 'J':   // Backward right
                    motors_backward(150, 100);
                    break;

                case 'X':   // Turn headlight ON
                    cutter_on();
                    break;

                case 'x':   // Turn headlight OFF
                    cutter_off();
                    break;
                case 'Y':
                    // Step 1: Visual confirmation we started
                    PORTB.B3 = 0; Delay_ms(200); PORTB.B3 = 1; Delay_ms(200);
                    
                    // Step 2: Move servo to moisture sensor scanning position
                    servo_set_angle(180);  // Move to scanning position
                    Delay_ms(2000);        // Wait for servo to reach position
                    
                    // Step 3: Read moisture sensor
                    Delay_ms(500);         
                    moisture_value = read_soil_moisture_safe();
                    moisture_percentage = (moisture_value * 100) / 1023;
                    
                    // Step 4: DISABLE SERVO INTERRUPTS before controlling relay
                    PIE1.CCP1IE = 0;       // Disable CCP1 interrupt
                    PORTC.B4 = 0;          // Stop servo signal
                    
                    // Step 5: Control relay
                    if(moisture_value > 500) {
                        // Dry soil - Turn relay ON
                        PORTB.B6 = 1;
                        
                        // KEEP PUMP RUNNING - servo stays disabled
                        Delay_ms(500);  // Run pump for 5 seconds

                        // Turn off pump
                        PORTB.B6 = 0;
                        
                    } else {
                        // Wet soil - Turn relay OFF  
                        PORTB.B6 = 0;
                        
                        // Visual feedback - 3 slow blinks = relay OFF

                    }
                    

                    
                    // Step 7: RE-ENABLE SERVO INTERRUPTS for sweep
                    PIE1.CCP1IE = 1;       // Re-enable CCP1 interrupt
                    
                    // Step 8: Perform the servo sweep 
                    for(angle = 0; angle <= 360; angle += 10) {
                        servo_angle_direct(angle);
                        Delay_ms(100);
                    }
                    
                    for(angle = 0; angle <= 180; angle += 10) {
                        servo_angle_direct(angle);
                        Delay_ms(100);
                    }
                    
                    Delay_ms(1000);
                    
                    // Step 9: Return servo to home position
                    servo_angle_direct(0);
                    Delay_ms(2000);        
                    
                    break;
            }
        }
    }
}