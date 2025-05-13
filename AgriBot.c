/******************************************************************************
 * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
 * Compiler : mikroC PRO for PIC
 * Fosc     : 20 MHz
 ******************************************************************************/
#define _XTAL_FREQ 20000000   // only needed if you use __delay_xx – not used here

/* === Pin assignments ===================================================== */
#define TRIG  PORTB.F0    // RB0 – trigger output
#define ECHO  PORTB.F1    // RB1 – echo  input

/* === Tiny helpers ======================================================== */
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

/* === Ultrasonic sensor ====================================================*/
void init_ultrasonic(void)
{
    TRISB.F0 = 0;   // TRIG as output
    TRISB.F1 = 1;   // ECHO as input
}

void trigger_ultrasonic(void)
{
    TRIG = 0;
    Delay_us(2);

    TRIG = 1;
    Delay_us(10);            // 10 µs HIGH pulse

    TRIG = 0;
}

unsigned int read_distance_cm(void)
{
     unsigned int ticks;

     trigger_ultrasonic();

     /* wait echo HIGH, timeout omitted for brevity */
     while (!ECHO);

     TMR1H = 0;                 // clear 16-bit timer
     TMR1L = 0;
     T1CON = 0x01;              // Timer-1 on, prescaler 1

     while (ECHO);              // stay here while echo HIGH

     T1CON = 0x00;              // stop timer
     ticks = ((unsigned int)TMR1H << 8) | TMR1L;

     /*  ticks * 0.2 µs  → distance(cm) = t/58
         so  distance = ticks * 0.2 / 58  = ticks / 290                */
     return ticks / 290;        // ≈ distance in cm
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

/* === Main ================================================================ */
void main(void)
{
    TRISD = 0x00;    // PORTD as output for IN1-IN4
    PORTD = 0x00;

    setupPWM();
    init_ultrasonic();

     while (1)
     {
        motors_forward();
        Delay_ms(400);
        if (read_distance_cm() < 20) motors_stop();

     //    motors_left();
     //    Delay_ms(400);
     //    if (read_distance_cm() < 20) motors_stop();

     //    motors_right();
     //    Delay_ms(400);
     //    if (read_distance_cm() < 20) motors_stop();

     //    motors_backward();
     //    Delay_ms(400);
     //    if (read_distance_cm() < 20) motors_stop();
     }
}