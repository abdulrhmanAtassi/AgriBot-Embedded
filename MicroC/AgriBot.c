/******************************************************************************
 * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
 * Compiler : mikroC PRO for PIC
 * Fosc     : 20 MHz
 * Libraries: Only UART1 functions for Bluetooth are allowed
 ******************************************************************************/

/* === Pin assignments ===================================================== */
#define TRIG_PIN  0x01    // RB0 – bit 0
#define ECHO_PIN  0x02    // RB1 – bit 1

// Global variables
unsigned int moisture_value;
unsigned int moisture_percentage;
unsigned int blink_counter;
char command;

/* === Custom Delay Functions ============================================== */
void custom_delay_us(unsigned int us) {
    unsigned int i;
    // For 8MHz: 1 instruction cycle = 0.5us
    // Approximate delay loop - 2 NOPs per microsecond
    for(i = 0; i < us; i++) {
        asm nop;
        asm nop;
    }
}

void custom_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for(i = 0; i < ms; i++) {
        for(j = 0; j < 400; j++) {
            asm nop;
            asm nop;
            asm nop;
            asm nop;
            asm nop;
        }
    }
}

/* === CCP Compare Mode Servo Control ===================================== */
unsigned int pulse_width = 3000;  // Current pulse width (1.5ms default)
unsigned char servo_state = 0;    // 0 = low, 1 = high

// CCP1 Interrupt Service Routine
void interrupt() {
    if(PIR1 & 0x04) {  // Check CCP1IF bit (bit 2)
        PIR1 &= ~0x04;  // Clear CCP1IF flag

        if(servo_state == 0) {
            // Start pulse - set RC4 HIGH
            PORTC |= 0x10;  // Set bit 4
            servo_state = 1;

            // Set compare value for pulse width
            CCPR1H = (pulse_width >> 8);
            CCPR1L = pulse_width;
        }
        else {
            unsigned int low_time = 40000 - pulse_width;
            // End pulse - set RC4 LOW
            PORTC &= ~0x10;  // Clear bit 4
            servo_state = 0;

            // Set compare value for remainder of 20ms period
            CCPR1H = (low_time >> 8);
            CCPR1L = low_time;
        }
    }
}

// Initialize CCP in Compare mode
void init_ccp_servo() {
    // Configure RC4 as output
    TRISC &= ~0x10;  // Clear bit 4 (output)
    PORTC &= ~0x10;  // Clear bit 4 (low)

    // Configure Timer1
    T1CON = 0x01;     // Timer1 ON, 1:1 prescaler, internal clock
    TMR1H = 0;
    TMR1L = 0;

    // Configure CCP1 for Compare mode
    CCP1CON = 0x0B;   // Compare mode, trigger special event

    // Set initial compare value
    CCPR1H = (pulse_width >> 8);
    CCPR1L = pulse_width;

    // Enable interrupts
    PIR1 &= ~0x04;   // Clear CCP1IF flag
    PIE1 |= 0x04;    // Enable CCP1IE interrupt
    INTCON |= 0x40;  // Enable PEIE
    INTCON |= 0x80;  // Enable GIE
}

// Set servo angle (0-360 degrees)
void servo_set_angle(unsigned int angle) {
    unsigned long temp;

    // Limit angle
    if(angle > 360) angle = 360;

    // Calculate pulse width
    temp = 1000 + ((unsigned long)angle * 4000 / 360);

    // Update pulse width
    pulse_width = (unsigned int)temp;
}

// Direct servo control without interrupts
void servo_angle_direct(unsigned int angle) {
    unsigned int i;
    unsigned long pulse;

    // Calculate pulse width in timer counts
    pulse = 1000 + ((unsigned long)angle * 4000 / 360);

    // Disable interrupts temporarily
    INTCON &= ~0x80;  // Clear GIE

    // Send 50 pulses
    for(i = 0; i < 50; i++) {
        // Reset Timer1
        TMR1H = 0;
        TMR1L = 0;

        // Set compare value for pulse width
        CCPR1H = pulse >> 8;
        CCPR1L = pulse;

        // Start pulse
        PORTC |= 0x10;  // Set RC4 high

        // Wait for compare match
        PIR1 &= ~0x04;  // Clear CCP1IF
        while(!(PIR1 & 0x04));

        // End pulse
        PORTC &= ~0x10;  // Set RC4 low

        // Set compare for low period
        CCPR1H = (40000 - pulse) >> 8;
        CCPR1L = (40000 - pulse);

        // Wait for compare match
        PIR1 &= ~0x04;  // Clear CCP1IF
        while(!(PIR1 & 0x04));
    }

    // Re-enable interrupts
    INTCON |= 0x80;  // Set GIE
}

/* === Ultrasonic sensor ==================================================== */
void trigger_pulse(){
    PORTB |= TRIG_PIN;   // Set TRIG high
    custom_delay_us(10); // 10us pulse
    PORTB &= ~TRIG_PIN;  // Set TRIG low
}

unsigned int measure_distance(){
    unsigned int time = 0;
    unsigned int timeout;
    unsigned int timer0_overflow = 0;

    trigger_pulse();

    // Wait for echo signal to go HIGH
    timeout = 0xFFFF;
    while (!(PORTB & ECHO_PIN)) {
        if (--timeout == 0) {
            return 0;  // Timeout prevention
        }
    }

    // Start Timer0
    TMR0 = 0;
    timer0_overflow = 0;
    INTCON &= ~0x04;     // Clear T0IF
    OPTION_REG = 0x80;   // Enable Timer0, internal clock, no prescaler

    // Wait for echo signal to go LOW
    timeout = 0xFFFF;
    while (PORTB & ECHO_PIN) {
        // Check for Timer0 overflow
        if (INTCON & 0x04) {  // Check T0IF
            INTCON &= ~0x04;  // Clear T0IF
            timer0_overflow++;
            if (timer0_overflow > 200) {
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
    return time / 145u;
}

/* === Cutter setup =========================================================== */
void initCutter(void) {
    TRISB &= ~0x10;  // RB4 as output (clear bit 4)
    PORTB &= ~0x10;  // RB4 low
}

void cutter_on(void)  { PORTB |= 0x10; }   // Set RB4 high
void cutter_off(void) { PORTB &= ~0x10; }  // Set RB4 low

/* === PWM setup =========================================================== */
void setSpeed(unsigned char duty) { CCPR2L = duty; }

void setupPWM(void) {
    // RC1 = CCP2 ? output
    TRISC &= ~0x02;  // Clear bit 1 (RC1 output)

    // CCP2 in PWM mode
    CCP2CON = 0x0C;  // CCP2 PWM mode

    // Timer2 drives PWM – about 5 kHz
    PR2 = 249;              // period
    T2CON = 0x05;           // prescaler 4, TMR2 on

    setSpeed(128);          // 50% duty cycle
}

/* === Motor direction helpers ============================================= */
void motors_stop(void) {
    PORTD = 0x00;
    setSpeed(0);
}

void motors_forward(unsigned char left_speed, unsigned char right_speed) {
    unsigned int distance;
    while (1) {
        if (UART1_Data_Ready()) {
            command = UART1_Read();
            break;  // break out to handle new command
        }
        distance = measure_distance();
        if (distance < 10u) {
            motors_stop();
        } else {
            PORTD = 0x5A;  // 0b01011010 forward
            setSpeed(right_speed);
        }
    }
}

void motors_backward(unsigned char left_speed, unsigned char right_speed) {
    PORTD = 0xA5;  // 0b10100101 Backward direction
    setSpeed(right_speed);
}

void motors_left(void) {
    PORTD = 0x55;  // 0b01010101 turn left
    setSpeed(150);
}

void motors_right(void) {
    PORTD = 0xAA;  // 0b10101010 turn right
    setSpeed(150);
}

/* === Water Pump ========================================================== */
void init_io(void) {
    TRISB &= ~0x40;  // RB6 output (clear bit 6)
    PORTB |= 0x40;   // relay off (active low input)
}

void relay_control(char state) {
    if(state) {
        PORTB &= ~0x40;  // turn relay ON (active low)
    } else {
        PORTB |= 0x40;   // turn relay OFF
    }
}

/* === ADC Functions ======================================================= */
void init_adc() {
    ADCON1 = 0x80;      // Right justified, all pins analog
    ADCON0 = 0x81;      // Channel 0 selected, ADC ON, Fosc/8
    custom_delay_us(50); // Allow ADC to stabilize
}

unsigned int read_adc(unsigned char channel) {
    // Select channel (0-7)
    ADCON0 &= 0xC7;              // Clear channel selection bits
    ADCON0 |= (channel << 3);    // Set channel selection bits

    custom_delay_us(20);         // Acquisition time delay

    ADCON0 |= 0x04;              // Start conversion (set GO bit)
    while(ADCON0 & 0x04);        // Wait for conversion complete

    // Return 10-bit result
    return ((unsigned int)ADRESH << 8) | ADRESL;
}

unsigned int read_soil_moisture() {
    return read_adc(0);
}

unsigned int read_soil_moisture_safe() {
    unsigned char old_gie = INTCON & 0x80;  // Save interrupt state
    unsigned int result = read_adc(0);
    INTCON &= ~0x80;  // Disable interrupts during ADC

    if(old_gie) INTCON |= 0x80;  // Restore interrupts if they were enabled
    return result;
}

void relay_control_fixed(char state) {
    if(state) {
        PORTB |= 0x40;   // Turn relay ON
    } else {
        PORTB &= ~0x40;  // Turn relay OFF
    }
    custom_delay_ms(10);  // Add delay for relay switching
}

/* === Setup =============================================================== */
void setup() {
    // Configure TRIS registers
    TRISA = 0xFF;   // Port A as input
    TRISB = 0x02;   // RB1 as input (echo), others as output
    TRISC = 0x40;   // RC6 (TX) as input for USART, others as output
    TRISD = 0x00;   // Port D as output
    TRISE = 0x07;   // RE0-RE2 as input

    // Clear all output ports
    PORTA = 0x00;
    PORTB = 0x00;
    PORTC = 0x00;
    PORTD = 0x00;

    // Initialize RB6 for water pump
    TRISB &= ~0x40;  // RB6 as output
    PORTB &= ~0x40;  // RB6 low

    // Initialize water pump
    init_io();

    // System stabilization delay
    custom_delay_ms(100);
}

void bluetooth_init() {
    UART1_Init(9600);
    custom_delay_ms(100);
}

/* === Main ================================================================ */
void main(void) {
    unsigned int angle;

    // Initialize system
    setup();
    bluetooth_init();
    initCutter();
    setupPWM();
    init_ccp_servo();
    init_adc();

    blink_counter = 0;
    custom_delay_us(100);

    while (1) {
        servo_set_angle(0);
        if (UART1_Data_Ready()) {
            command = UART1_Read();
            switch(command) {
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

                case 'X':   // Turn cutter ON
                    cutter_on();
                    break;

                case 'x':   // Turn cutter OFF
                    cutter_off();
                    break;

                case 'Y':
                    // Step 1: Visual confirmation
                    PORTB &= ~0x08; custom_delay_ms(200); // RB3 low
                    PORTB |= 0x08; custom_delay_ms(200);  // RB3 high

                    // Step 2: Move servo to scanning position
                    servo_set_angle(180);
                    custom_delay_ms(2000);

                    // Step 3: Read moisture sensor
                    custom_delay_ms(500);
                    moisture_value = read_soil_moisture_safe();
                    moisture_percentage = (moisture_value * 100) / 1023;

                    // Step 4: Disable servo interrupts
                    PIE1 &= ~0x04;  // Disable CCP1IE
                    PORTC &= ~0x10; // Stop servo signal (RC4 low)

                    // Step 5: Control relay
                    if(moisture_value > 500) {
                        // Dry soil - Turn relay ON
                        PORTB |= 0x40;  // RB6 high
                        custom_delay_ms(500);  // Run pump
                        PORTB &= ~0x40; // Turn off pump
                    } else {
                        // Wet soil - Turn relay OFF
                        PORTB &= ~0x40; // RB6 low
                    }

                    // Step 6: Re-enable servo interrupts
                    PIE1 |= 0x04;  // Re-enable CCP1IE

                    // Step 7: Perform servo sweep
                    for(angle = 0; angle <= 360; angle += 10) {
                        servo_angle_direct(angle);
                        custom_delay_ms(100);
                    }

                    for(angle = 0; angle <= 180; angle += 10) {
                        servo_angle_direct(angle);
                        custom_delay_ms(100);
                    }

                    custom_delay_ms(1000);

                    // Step 8: Return servo to home
                    servo_angle_direct(0);
                    custom_delay_ms(2000);

                    break;
            }
        }
    }
}