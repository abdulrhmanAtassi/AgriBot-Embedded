#line 1 "C:/Users/20210651/Documents/AgriBot-Embedded/AgriBot.c"

void our_delay_ms(unsigned int ms) {
 unsigned int i, j;
 for (i = 0; i < ms; i++) {
 for (j = 0; j < 111; j++) NOP();
 }
}

void setup(){
 TRISD = 0x00;
 PORTD = 0x00;
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

 forward();

 backward();
 stop();
}
