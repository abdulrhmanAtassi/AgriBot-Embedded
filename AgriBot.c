void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
}

void setupPWM() {
    // Set RC2 (CCP1) and RC1 (CCP2) as output
    TRISC2 = 0;
    TRISC1 = 0;

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

void setup(){
     TRISD = 0x00; // Set PORTD as output
     PORTD = 0x00; // All moters off initally
}

void stop() {
     PORTD = 0b00000000;
}
void left(){
     PORTD = 0b01010101;
     our_delay_ms(500);
}

void right(){
     PORTD = 0b10101010;
     our_delay_ms(500);
}

void forward(){
     PORTD = 0b01011010;
     our_delay_ms(500);
}

void backward(){
     PORTD = 0b10100101;
     our_delay_ms(500);
}
void main() {
     setup();
     left();
     forward();
     right();
     backward();
     stop();
}
