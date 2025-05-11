void our_delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 111; j++) NOP();
    }
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