/******************************************************************************
 * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
 * Compiler : mikroC PRO for PIC
 * Fosc     : 20 MHz
 ******************************************************************************/
//#define _XTAL_FREQ 20000000   // only needed if you use __delay_xx – not used here

/* === Pin assignments ===================================================== */
#define TRIG  PORTB.F0    // RB0 – trigger output
#define ECHO  PORTB.F1    // RB1 – echo  input



char command;  // Declare this globally or at the top of main


/* === Tiny helpers ======================================================== */
void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
}

/* ===Set Servo Functions ====================================================*/

// === Global Variables ===
unsigned int servo_pulse_us = 1500; // 1500us = 90 degrees
char pulse_started = 0;


// === Timer1 Setup for 20ms ===
void Timer1_Init()

{
    T1CON = 0b00000001;   // Timer1 ON, Prescaler 1:1
    TMR1H = 0x0B;         // Preload for 20ms overflow at 20MHz
    TMR1L = 0xDC;
    TMR1IF_bit = 0;
    TMR1IE_bit = 1;       // Enable Timer1 interrupt
    PEIE_bit = 1;         // Enable peripheral interrupts
    GIE_bit = 1;          // Enable global interrupts
}

// === Timer2 Setup for pulse width ===
void Timer2_Init()
{
    T2CON = 0b00000111;   // Prescaler 1:16, Timer2 ON when needed
    PR2 = 249;            // Will be set dynamically
    TMR2IF_bit = 0;
    TMR2IE_bit = 1;       // Enable Timer2 interrupt
}

// === Set Servo Angle Function ===
void Set_Servo_Angle(unsigned char angle)
{
    // 1000us (0°) to 2000us (180°)
    servo_pulse_us = ((angle * 10) / 9) + 1000;
}

// === Interrupt Service Routine ===
void interrupt()
{
    unsigned int ticks;

    // Timer1: Start of 20ms frame
    if (TMR1IF_bit)
    {
        TMR1IF_bit = 0;
        TMR1H = 0x0B;
        TMR1L = 0xDC;

        pulse_started = 1;
        PORTB.F3 = 1;  // ✅ Servo pulse HIGH on RB3

        // Configure Timer2 for pulse duration (1-2 ms)
        ticks = servo_pulse_us / 4; // 1 tick = 4us (20MHz, prescaler 16)
        PR2 = ticks;
        TMR2 = 0;
        TMR2ON_bit = 1;
    }

    // Timer2: End of pulse
    if (TMR2IF_bit && pulse_started)
    {
        TMR2IF_bit = 0;
        PORTB.F3 = 0;  // ✅ Servo pulse LOW
        pulse_started = 0;
        TMR2ON_bit = 0;
    }
}




/* === Ultrasonic sensor ====================================================*/

void trigger_pulse(){
    TRIG = 1;  // Set Trigger pin high
    delay_us(10);  // 10us pulse
    TRIG = 0;  // Set Trigger pin low
}

unsigned int measure_distance(){
    unsigned int time = 0;
    unsigned int timeout;

    trigger_pulse();

    // Wait for echo signal to go HIGH
    timeout = 0xFFFF;
    while (!(PORTB & 0x02)) {
        if (--timeout == 0) {
            return 0;  // Timeout prevention, no object detected
        }
    }

    // Start Timer1
    TMR1H = 0;
    TMR1L = 0;
    T1CON = 0x01;  // Enable Timer1 with no prescaler

    // Wait for echo signal to go LOW
    timeout = 0xFFFF;
    while (PORTB & 0x02) {
        if (--timeout == 0) {
            T1CON = 0x00;  // Disable Timer1
            return 0;  // Timeout prevention
        }
    }

    // Stop Timer1 and calculate time
    T1CON = 0x00;  // Disable Timer1
    time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes

    // Convert time to distance in cm
   return time / 116u;
}

/* === Cutter setup =========================================================== */

void initCutter(void) {
     TRISB.F4 = 0;
     PORTB.F4    = 0;
}

void cutter_on(void)  { PORTB.F4 = 1; }
void cutter_off(void) { PORTB.F4 = 0; }


void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
void setSpeedRight(unsigned char duty) { CCPR2L = duty; }

/* === PWM setup =========================================================== */
void setupPWM(void)
{
    /* RC2 = CCP1, RC1 = CCP2  → outputs */
    TRISC.F2 = 0;   // RC2
    TRISC.F1 = 0;   // RC1
    
    /* CCP modules in PWM mode */
    CCP1CON = 0b00001100;     // CCP1 PWM
    CCP2CON = 0b00001100;     // CCP2 PWM
    
    /* Timer2 drives both PWMs  –  about 5 kHz  */
    PR2   = 249;              // period
    T2CON = 0b00000101;       // prescaler 4, TMR2 on
    
    setSpeedLeft (128);       // 50 %
    setSpeedRight(128);       // 50 %
}

/* === Motor direction helpers (PORTD pattern) ============================= */
void motors_stop(void)
{
    PORTD = 0x00;
    setSpeedLeft(0);
    setSpeedRight(0);
}

// void motors_forward_continuous(void)
// {
//     unsigned int distance ;
//     while (1) {
//         if (UART1_Data_Ready()) {
//             command = UART1_Read();
//             break;  // break out to handle new command
//         }
//         distance = measure_distance();
//         if (distance < 20u) {
//             motors_stop();
//         } else {
//             PORTD = 0b01011010;  // forward
//             setSpeedLeft(150);
//             setSpeedRight(150);
//         }
//     }
// }


void motors_forward(unsigned char left_speed, unsigned char right_speed)
{
    unsigned int distance ;
    while (1) {
        if (UART1_Data_Ready()) {
            command = UART1_Read();
            break;  // break out to handle new command
        }
        distance = measure_distance();
        if (distance < 20u) {
            motors_stop();
        } else {
            PORTD = 0b01011010;  // forward
            setSpeedLeft(left_speed);
            setSpeedRight(right_speed);
        }
    }
}

void motors_backward(unsigned char left_speed, unsigned char right_speed)
{
    PORTD = 0b10100101;  // Backward direction
    setSpeedLeft(left_speed);
    setSpeedRight(right_speed);
}

void motors_left(void)
{
    PORTD = 0b01010101;            // turn left
    setSpeedLeft(150);
    setSpeedRight(150);
}

void motors_right(void)
{
    PORTD = 0b10101010;            // turn right
    setSpeedLeft(150);
    setSpeedRight(150);
}


/* === setup ================================================================ */
void setup(){


    /// MY CODE
    //  TRISC = 0xFF;
    //  TRISB = 0x02;
    //  PORTC = 0x00;
    //  PORTB = 0x00;
    //  our_delay_ms(100);

    // TRISA = 0xFF;
    TRISB = 0x02;
    TRISC = 0x40;
    TRISD = 0x00;
    // PORTA = 0x00;  // Initialize PORTB
    PORTB = 0x00;  // Initialize PORTB
    PORTC = 0x00;  // Initialize PORTC
    PORTD = 0x00;  // Initialize PORTD
    // ADCON0 = 0x00; // MAKE IT 0x01 before using A/D
    // ADCON1 = 0x00; // Configure ADC module
    // Configure USART
    // PIR1 = 0x00;   // Set all interrupt flags to zero
    // INTCON = 0x00;
    our_delay_ms(100);
}

void bluetooth_init() {
    UART1_Init(9600);
     our_delay_ms(100);   // Initialize UART with 9600 baud rate
}

/* === Main ================================================================ */

void main(void)
 {

    setup();    
    bluetooth_init();
    initCutter();
    setupPWM();
    
    Timer1_Init();         // Start 20ms frame timer
    Timer2_Init();         // Prepare Timer2 for pulse width
    Set_Servo_Angle(90);   // Initial angle (e.g., 90°)
    TRISB.F3 = 0;
    PORTB.F3 = 0;

     while (1)
     {
        // if (UART1_Data_Ready()) {          // Check if data is available
        //     command = UART1_Read();        // Read one character
        //     switch(command){
        //         case 'F':
        //             motors_forward(150, 150);
        //             break;

        //         case 'B': 
        //             motors_backward(100, 100);
        //             break;

        //         case 'R': 
        //             motors_left();
        //             break;

        //         case 'L': 
        //             motors_right();
        //             break;

        //         case 'S': 
        //             motors_stop();
        //             break;

        //         case 'G':   // Forward left
        //             motors_forward(100, 150);   
        //             break;

        //         case 'H':   // Forward right
        //             motors_forward(150, 100);
        //             break;

        //         case 'I':   // Backward left
        //             motors_backward(100, 150);
        //             break;

        //         case 'J':   // Backward right
        //             motors_backward(150, 100);
        //             break;

        //         case 'X':   // Turn headlight ON
        //             cutter_on();
        //             break;

        //         case 'x':   // Turn headlight OFF
        //             cutter_off();
        //             break;
        //         case 'Y':
        //             Set_Servo_Angle(180);
        //             break;
                    
        //     }
        // }

        PORTB.F3 = 1;
        Delay_us(15000);    // 90° position
        PORTB.F3 = 0;
        Delay_ms(20);      // Total frame = 20ms

    }

}