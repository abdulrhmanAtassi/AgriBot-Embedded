#define TRIG LATBbits.LATB0
#define ECHO PORTBbits.RB1
void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
}

void setupPWM() {
    // Set RC2 (CCP1) and RC1 (CCP2) as output
    TRISC &= 0b11110001;

    // Set PWM mode for CCP1 and CCP2
    CCP1CON = 0b00001100;  // PWM mode
    CCP2CON = 0b00001100;  // PWM mode

    // Set PWM frequency (~5kHz for Fosc = 20MHz)
    PR2 = 249;
    T2CON = 0b00000101; // Prescaler = 4, Timer2 ON

    // Set initial duty cycles (e.g., 50%)
    CCPR1L = 128; // Left motors
    CCPR2L = 128; // Right motors
}



void init_ultrasonic() {
    TRISB &= 0b00000010; // TRIG = output
//    TRISB1 = 1; // ECHO = input
}

void trigger_ultrasonic() {
    TRIG = 0;
    our_delay_ms(2);
    TRIG = 1;
    our_delay_ms(10);  // 10 microsecond pulse
    TRIG = 0;
}

unsigned int read_distance_cm() {
    unsigned int time = 0;

    trigger_ultrasonic();

    // Wait for echo to go HIGH
    while (!ECHO);

    // Measure how long ECHO stays HIGH
    while (ECHO) {
        our_delay_ms(1);
        time++;
    }

    // Convert time to cm (Speed of sound = 343 m/s)
    // time * 0.034 / 2 ? simplified to:
    return time / 58;
}

void setSpeedLeft(unsigned int duty){
     CCPR1L = duty;
}

void setSpeedRight(unsigned int duty){
     CCPR2L = duty;
}

void setup(){
     TRISD = 0x00; // Set PORTD as output
     PORTD = 0x00; // All moters off initally
}

void stop() {
     PORTD = 0b00000000;
     setSpeedLeft(0);
     setSpeedRight(0);
}
void left(){
     PORTD = 0b01010101;
     setSpeedLeft(150);
     setSpeedRight(150);
     our_delay_ms(500);
     unsigned int dist =  read_distance_cm();
     if(dist < 20){
          stop();
     }
}

void right(){
     PORTD = 0b10101010;
     setSpeedLeft(150);
     setSpeedRight(150);
     our_delay_ms(500);
     unsigned int dist =  read_distance_cm();
     if(dist < 20){
          stop();
     }
}

void forward(){
     PORTD = 0b01011010;
     setSpeedLeft(150);
     setSpeedRight(150);
     our_delay_ms(500);
     unsigned int dist =  read_distance_cm();
     if(dist < 20){
          stop();
     }
}

void backward(){
     PORTD = 0b10100101;
     setSpeedLeft(150);
     setSpeedRight(150);
     our_delay_ms(500);
     unsigned int dist =  read_distance_cm();
     if(dist < 20){
          stop();
     }
}

void main() {
     setup();
     setupPWM();
     init_ultrasonic();
     left();
     forward();
     right();
     backward();
     stop();
}