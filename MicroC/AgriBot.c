/******************************************************************************
 * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
 * Compiler : mikroC PRO for PIC
 * Fosc     : 20 MHz
 ******************************************************************************/
//#define _XTAL_FREQ 20000000   // only needed if you use __delay_xx – not used here

/* === Pin assignments ===================================================== */
#define TRIG  PORTB.F0    // RB0 – trigger output
#define ECHO  PORTB.F1    // RB1 – echo  input
//#define Cutter     PORTB.F4;
//#define CutterDir  TRISB.F4;
/* === Tiny helpers ======================================================== */
void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
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

void motors_forward(void)
{
    PORTD = 0b01011010;            // forward
    setSpeedLeft(150);
    setSpeedRight(150);
}

void motors_backward(void)
{
    PORTD = 0b10100101;            // backward
    setSpeedLeft(150);
    setSpeedRight(150);
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

/* === Main ================================================================ */
void main(void)
 {
//     TRISD = 0x00;    // PORTD as output for IN1-IN4
//     PORTD = 0x00;

unsigned int distance;  
    setup();    
    initCutter();
    cutter_on();
    // setupPWM();

    //  while (1)
    //  {
    //     while (1) {
    //         distance = measure_distance();
    //         if (distance < 20u) {
    //             motors_stop();
    //             continue;        // skip to next reading
    //         }
    //     // motors_forward();
    //     Delay_ms(100);
    // }
    //  //    motors_left();
    //  //    Delay_ms(400);
    //  //    if (read_distance_cm() < 20) motors_stop();

    //  //    motors_right();
    //  //    Delay_ms(400);
    //  //    if (read_distance_cm() < 20) motors_stop();

    //  //    motors_backward();
    //  //    Delay_ms(400);
    //  //    if (read_distance_cm() < 20) motors_stop();
    //  }
}