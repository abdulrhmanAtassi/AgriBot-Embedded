#line 1 "C:/Users/20210651/Documents/AgriBot-Embedded/AgriBot.c"


void our_delay_ms(unsigned int ms) {
 unsigned int i, j;
 for (i = 0; i < ms; i++) {
 for (j = 0; j < 111; j++) NOP();
 }
}

void setupPWM() {

 TRISC &= 0b11110001;


 CCP1CON = 0b00001100;
 CCP2CON = 0b00001100;


 PR2 = 249;
 T2CON = 0b00000101;


 CCPR1L = 128;
 CCPR2L = 128;
}



void init_ultrasonic() {
 TRISB &= 0b00000010;

}

void trigger_ultrasonic() {
  LATBbits.LATB0  = 0;
 our_delay_ms(2);
  LATBbits.LATB0  = 1;
 our_delay_ms(10);
  LATBbits.LATB0  = 0;
}

unsigned int read_distance_cm() {
 unsigned int time = 0;

 trigger_ultrasonic();


 while (! PORTBbits.RB1 );


 while ( PORTBbits.RB1 ) {
 our_delay_ms(1);
 time++;
 }



 return time / 58;
}

void setSpeedLeft(unsigned int duty){
 CCPR1L = duty;
}

void setSpeedRight(unsigned int duty){
 CCPR2L = duty;
}

void setup(){
 TRISD = 0x00;
 PORTD = 0x00;
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
 unsigned int dist = read_distance_cm();
 if(dist < 20){
 stop();
 }
}

void right(){
 PORTD = 0b10101010;
 setSpeedLeft(150);
 setSpeedRight(150);
 our_delay_ms(500);
 unsigned int dist = read_distance_cm();
 if(dist < 20){
 stop();
 }
}

void forward(){
 PORTD = 0b01011010;
 setSpeedLeft(150);
 setSpeedRight(150);
 our_delay_ms(500);
 unsigned int dist = read_distance_cm();
 if(dist < 20){
 stop();
 }
}

void backward(){
 PORTD = 0b10100101;
 setSpeedLeft(150);
 setSpeedRight(150);
 our_delay_ms(500);
 unsigned int dist = read_distance_cm();
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
