// /******************************************************************************
//  * AgriBot – PIC16F877A + 2×L298N + HC-SR04 demo
//  * Compiler : mikroC PRO for PIC
//  * Fosc     : 20 MHz
//  ******************************************************************************/
// //#define _XTAL_FREQ 20000000   // only needed if you use __delay_xx – not used here

// /* === Pin assignments ===================================================== */
// #define TRIG  PORTB.F0    // RB0 – trigger output
// #define ECHO  PORTB.F1    // RB1 – echo  input



// char command;  // Declare this globally or at the top of main


// /* ===Set Servo Functions ====================================================*/

// // === Global Variables ===
// unsigned int servo_pulse_us = 1500; // 1500us = 90 degrees
// char pulse_started = 0;


<<<<<<< Updated upstream
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

void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
void setSpeedRight(unsigned char duty) { CCPR2L = duty; }

/* === Motor direction helpers (PORTD pattern) ============================= */
void motors_stop(void)
{
    PORTD = 0x00;
    setSpeedLeft(0);
    setSpeedRight(0);
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
    TRISB = 0x02;
    TRISC = 0x40;
    TRISD = 0x00;
    PORTB = 0x00;  // Initialize PORTB
    PORTC = 0x00;  // Initialize PORTC
    PORTD = 0x00;  // Initialize PORTD
    our_delay_ms(100);


    // TRISA = 0xFF;
    // PORTA = 0x00;  // Initialize PORTB
    // ADCON0 = 0x00; // MAKE IT 0x01 before using A/D
    // ADCON1 = 0x00; // Configure ADC module
    // Configure USART
    // PIR1 = 0x00;   // Set all interrupt flags to zero
    // INTCON = 0x00;
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


// void motors_forward_continuous(void)
=======
// // === Timer1 Setup for 20ms ===
// void Timer1_Init()

>>>>>>> Stashed changes
// {
//     T1CON = 0b00000001;   // Timer1 ON, Prescaler 1:1
//     TMR1H = 0x63;  // High byte of 25536
//     TMR1L = 0xC0;  // Low byte
//     TMR1IF_bit = 0;
//     TMR1IE_bit = 1;       // Enable Timer1 interrupt
//     PEIE_bit = 1;         // Enable peripheral interrupts
//     GIE_bit = 1;          // Enable global interrupts
// }

// // === Timer2 Setup for pulse width ===
// void Timer2_Init()
// {
//     T2CON = 0b00000111;   // Prescaler 1:16, Timer2 ON when needed
//     PR2 = 249;            // Will be set dynamically
//     TMR2IF_bit = 0;
//     TMR2IE_bit = 1;       // Enable Timer2 interrupt
// }

// // === Set Servo Angle Function ===
// void Set_Servo_Angle(unsigned char angle)
// {
//     // 1000us (0°) to 2000us (180°)
//      servo_pulse_us = ((angle * 10) / 9) + 1000;
// //    servo_pulse_us = ((angle * 1000) / 180) + 1000;
// }

// // === Interrupt Service Routine ===
// void interrupt()
// {
//     unsigned int ticks;

//     // Timer1: Start of 20ms frame
//     if (TMR1IF_bit)
//     {
//         TMR1IF_bit = 0;
//         TMR1H = 0x0B;
//         TMR1L = 0xDC;

//         pulse_started = 1;
//         PORTB.F3 = 1;  // ✅ Servo pulse HIGH on RB3

//         // Configure Timer2 for pulse duration (1-2 ms)
//         ticks = servo_pulse_us / 8; 
//         PR2 = ticks;
//         TMR2 = 0;
//         TMR2ON_bit = 1;
//     }

//     // Timer2: End of pulse
//     if (TMR2IF_bit && pulse_started)
//     {
//         TMR2IF_bit = 0;
//         PORTB.F3 = 0;  // ✅ Servo pulse LOW
//         pulse_started = 0;
//         TMR2ON_bit = 0;
//     }
// }

// /* === Tiny helpers ======================================================== */
// void our_delay_ms(unsigned int ms) {
//     unsigned int i, j;
//     for (i = 0; i < ms; i++) {
//         for (j = 0; j < 111; j++) NOP();
//     }
// }

// /* === Ultrasonic sensor ====================================================*/

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

// /* === Cutter setup =========================================================== */

// void initCutter(void) {
//      TRISB.F4 = 0;
//      PORTB.F4    = 0;
// }

// void cutter_on(void)  { PORTB.F4 = 1; }
// void cutter_off(void) { PORTB.F4 = 0; }


// /* === PWM setup =========================================================== */
// void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
// void setSpeedRight(unsigned char duty) { CCPR2L = duty; }

// void setupPWM(void)
// {
//     /* RC2 = CCP1, RC1 = CCP2  → outputs */
//     TRISC.F2 = 0;   // RC2
//     TRISC.F1 = 0;   // RC1
    
//     /* CCP modules in PWM mode */
//     CCP1CON = 0b00001100;     // CCP1 PWM
//     CCP2CON = 0b00001100;     // CCP2 PWM
    
//     /* Timer2 drives both PWMs  –  about 5 kHz  */
//     PR2   = 249;              // period
//     T2CON = 0b00000101;       // prescaler 4, TMR2 on
    
//     setSpeedLeft (128);       // 50 %
//     setSpeedRight(128);       // 50 %
// }


// /* === Motor direction helpers (PORTD pattern) ============================= */
// void motors_stop(void)
// {
//     PORTD = 0x00;
//     setSpeedLeft(0);
//     setSpeedRight(0);
// }

// void motors_forward(unsigned char left_speed, unsigned char right_speed)
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
//             setSpeedLeft(left_speed);
//             setSpeedRight(right_speed);
//         }
//     }
// }

// void motors_backward(unsigned char left_speed, unsigned char right_speed)
// {
//     PORTD = 0b10100101;  // Backward direction
//     setSpeedLeft(left_speed);
//     setSpeedRight(right_speed);
// }

// void motors_left(void)
// {
//     PORTD = 0b01010101;            // turn left
//     setSpeedLeft(150);
//     setSpeedRight(150);
// }

// void motors_right(void)
// {
//     PORTD = 0b10101010;            // turn right
//     setSpeedLeft(150);
//     setSpeedRight(150);
// }


// /* === setup ================================================================ */
// void setup(){
//     TRISB = 0x02;
//     TRISC = 0x40; // RC6 = TX = output (0), RC7 = RX = input (1)
//     TRISD = 0x00;
//     PORTB = 0x00;  // Initialize PORTB
//     PORTC = 0x00;  // Initialize PORTC
//     PORTD = 0x00;  // Initialize PORTD
//     our_delay_ms(100);


//     // TRISA = 0xFF;
//     // PORTA = 0x00;  // Initialize PORTB
//     ADCON0 = 0x00; // MAKE IT 0x01 before using A/D
//     ADCON1 = 0x00; // Configure ADC module
//     // Configure USART
//     // PIR1 = 0x00;   // Set all interrupt flags to zero
//     // INTCON = 0x00;
// }

// void bluetooth_init() {
//     UART1_Init(9600);
//      our_delay_ms(100);   // Initialize UART with 9600 baud rate
// }

// //servo
// // void pwm_init() {
// //     TRISC = TRISC & 0xF9; // Set RC2 pin as output

// //     // Configure CCP1 module for PWM (for servo on RC2)
// //     CCP1CON = 0x0C; // Set CCP1M3 and CCP1M2 to 1, rest bits remain as they are

// //     // Configure CCP2 module for PWM (for servo on RC1)
// //     CCP2CON = 0x0C;

// //     T2CON = T2CON | 0x07;// Set T2CKPS1, T2CKPS0, and TMR2ON to 1

// //     PR2 = 249; // Set period register for 50Hz frequency
// // }

// void set_servo_position2(unsigned char angle)
// {
//     // 1000us to 2000us = min to max position
//     unsigned int pulse_width_us = (angle * 1000 / 180) + 1000;

//     // Convert to 10-bit PWM value (duty = (pulse_width / total_period) * 1023)
//     // Total PWM period = 20ms = 20000us
//     unsigned int duty = (pulse_width_us * 1023) / 20000;

//     // Load to CCP2
//     CCPR2L = duty >> 2;
//     CCP2CON = (CCP2CON & 0xCF) | ((duty & 0x03) << 4);
// }

// void pwm_init()
// {
//     TRISC.F1 = 0;       // RC1 output for CCP2
//     PR2 = 249;          // 20ms period for 50Hz
//     CCP2CON = 0x0C;     // PWM mode
//     T2CON = 0x07;       // Timer2 ON, prescaler 1:16
//     TMR2 = 0;
//     TMR2ON_bit = 1;
// }
// /* === Main ================================================================ */

// void main(void)
//  {

//     setup();    
//     // bluetooth_init();
//     // initCutter();
// //     setupPWM();
  
    
//     pwm_init();
//     while (1)
//     {
//         set_servo_position2(0);    Delay_ms(1000);
//         set_servo_position2(90);   Delay_ms(1000);
//         set_servo_position2(180);  Delay_ms(1000);
//     }
// //    set_servo_position2(0);
//     //  while (1)
//     //  {
        
//     //     if (UART1_Data_Ready()) {          // Check if data is available
//     //         command = UART1_Read();        // Read one character
//     //         switch(command){
//     //             case 'F':
//     //                 motors_forward(150, 150);
//     //                 break;

//     //             case 'B': 
//     //                 motors_backward(100, 100);
//     //                 break;

//     //             case 'R': 
//     //                 motors_right();
//     //                 break;
                
//     //             case 'L': 
//     //                 motors_left();
//     //                 break;

//     //             case 'S': 
//     //                 motors_stop();
//     //                 break;

//     //             case 'G':   // Forward left
//     //                 motors_forward(50, 150);
//     //                 break;

//     //             case 'H':   // Forward right
//     //                 motors_forward(150, 500);
//     //                 break;

//     //             case 'I':   // Backward left
//     //                 motors_backward(50, 150);
//     //                 break;

//     //             case 'J':   // Backward right
//     //                 motors_backward(150, 50);
//     //                 break;

//     //             case 'X':   // Turn headlight ON
//     //                 cutter_on();
//     //                 break;

//     //             case 'x':   // Turn headlight OFF
//     //                 cutter_off();
//     //                 break;
//     //             case 'Y':
//     //                 Set_Servo_Angle(180);
//     //                 break;
                    
//     //         }
//     //     }

    
//     // }

// }


// //====================================Servo Testing Main =======================================
// // void main()
// // {
// //     TRISB.F3 = 0;      // Set servo pin as output
// //     PORTB.F3 = 0;

// //        while (1)
// //     {
// //         PORTB.F3 = 1;
// //         Delay_ms(1000);   // 1 full second ON
// //         PORTB.F3 = 0;
// //         Delay_ms(1000);   // 1 second OFF
// //     }
// // }


// // void motors_forward_continuous(void)
// // {
// //     unsigned int distance ;
// //     while (1) {
// //         if (UART1_Data_Ready()) {
// //             command = UART1_Read();
// //             break;  // break out to handle new command
// //         }
// //         distance = measure_distance();
// //         if (distance < 20u) {
// //             motors_stop();
// //         } else {
// //             PORTD = 0b01011010;  // forward
// //             setSpeedLeft(150);
// //             setSpeedRight(150);
// //         }
// //     }
// // }

// ==============================================================================================================
// ==============================================================================================================
// ==============================================================================================================
// ==============================================================================================================
/*  AgriBot.c  –  8 MHz PIC16F877A
 *  Non-blocking servo control on RB3
 *  Uses Timer-1 (20 ms frame) + Timer-2 (1-2 ms pulse)
 *  -------------------------------------------------- */

#define _XTAL_FREQ 8000000UL          // lets Delay_ms/us() work

/* ---------- Prototypes -------------------------------------------------- */
void  setup          (void);
void  Timer1_Init    (void);
void  Timer2_Init    (void);
void  Set_Servo_Angle(unsigned char angle);

/* ---------- Globals ----------------------------------------------------- */
volatile unsigned int  servo_pulse_us = 1500;   // start at 90 °
volatile unsigned char pulse_started  = 0;

/* ---------- I/O & user peripherals ------------------------------------- */
void setup(void)
{
    /*  Configure pins you need – adjust to your board  */
    TRISB  = 0x00;      // all PORTB as output for demo
    PORTB  = 0x00;

    /*  Servo signal on RB3  */
    TRISB.F3 = 0;       // output
    PORTB.F3 = 0;       // low
}

/* ---------- Timer-1 : 20 ms period (50 Hz) ------------------------------ */
void Timer1_Init(void)
{
    /*  8 MHz → Fosc/4 = 2 MHz → 0.5 µs per tick
        20 ms / 0.5 µs = 40 000 counts
        preload = 65 536 − 40 000 = 25 536 = 0x63C0  */
    T1CON      = 0b00000001;   // prescaler 1:1, Timer-1 ON
    TMR1H      = 0x63;
    TMR1L      = 0xC0;
    TMR1IF_bit = 0;
    TMR1IE_bit = 1;            // enable Timer-1 interrupt
}

/* ---------- Timer-2 : variable pulse width ----------------------------- */
void Timer2_Init(void)
{
    /* 8 µs per tick  (8 MHz, prescaler 1:16) */
    T2CON      = 0b00000100;   // prescaler 1:16, Timer-2 OFF
    PR2        = 250;          // dummy, overwritten each frame
    TMR2IF_bit = 0;
    TMR2IE_bit = 1;            // enable Timer-2 interrupt
}

/* ---------- Angle helper (0–180°) -------------------------------------- */
void Set_Servo_Angle(unsigned char angle)
{
    /*  map 0-180  →  1000-2000 µs  */
    servo_pulse_us = ((unsigned int)angle * 1000u) / 180u + 1000u;
}

/* ---------- Interrupt Service Routine ---------------------------------- */
void interrupt(void)
{
    /* ---- 20 ms frame start (Timer-1) ---- */
    if (TMR1IF_bit)
    {
        unsigned int ticks;

        TMR1IF_bit = 0;
        TMR1H = 0x63;          // reload 20 ms
        TMR1L = 0xC0;

        pulse_started = 1;
        PORTB.F3 = 1;          // raise servo pulse

        /* µs → Timer-2 ticks (1 tick = 8 µs) */
        ticks = servo_pulse_us / 8u;   // 125-250 (=1-2 ms)
        PR2   = (unsigned char)ticks;
        TMR2  = 0;
        TMR2ON_bit = 1;        // start Timer-2
    }

    /* ---- pulse end (Timer-2) ---- */
    if (TMR2IF_bit && pulse_started)
    {
        TMR2IF_bit = 0;
        TMR2ON_bit = 0;
        PORTB.F3   = 0;        // lower servo pulse
        pulse_started = 0;
    }
}

/* ---------- Main ------------------------------------------------------- */
void main(void)
{
    setup();

    Timer1_Init();
    Timer2_Init();

    PEIE_bit = 1;              // enable peripheral interrupts
    GIE_bit  = 1;              // global interrupts

    /*  demo sweep � replace with your real logic  */
    while (1)
    {
        Set_Servo_Angle(0);    Delay_ms(1000);
        Set_Servo_Angle(90);   Delay_ms(1000);
        Set_Servo_Angle(180);  Delay_ms(1000);
    }
}