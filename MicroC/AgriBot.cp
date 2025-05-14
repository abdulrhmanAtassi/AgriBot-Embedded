#line 1 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
#line 13 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
void our_delay_ms(unsigned int ms) {
 unsigned int i, j;
 for (i = 0; i < ms; i++) {
 for (j = 0; j < 111; j++) NOP();
 }
}





void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }
void setSpeedRight(unsigned char duty) { CCPR2L = duty; }


void setupPWM(void)
{

 TRISC.F2 = 0;
 TRISC.F1 = 0;


 CCP1CON = 0b00001100;
 CCP2CON = 0b00001100;


 PR2 = 249;
 T2CON = 0b00000101;

 setSpeedLeft (128);
 setSpeedRight(128);
}


void motors_stop(void)
{
 PORTD = 0x00;
 setSpeedLeft(0);
 setSpeedRight(0);
}

void motors_forward(void)
{
 PORTD = 0b01011010;
 setSpeedLeft(150);
 setSpeedRight(150);
}

void motors_backward(void)
{
 PORTD = 0b10100101;
 setSpeedLeft(150);
 setSpeedRight(150);
}

void motors_left(void)
{
 PORTD = 0b01010101;
 setSpeedLeft(150);
 setSpeedRight(150);
}

void motors_right(void)
{
 PORTD = 0b10101010;
 setSpeedLeft(150);
 setSpeedRight(150);
}



void trigger_pulse(){
  PORTB.F2  = 1;
 delay_us(10);
  PORTB.F2  = 0;
}

unsigned int measure_distance(){
 unsigned int time = 0;
 unsigned int timeout;

 trigger_pulse();


 timeout = 0xFFFF;
 while (!(PORTB & 0x02)) {
 if (--timeout == 0) {
 return 0;
 }
 }


 TMR1H = 0;
 TMR1L = 0;
 T1CON = 0x01;


 timeout = 0xFFFF;
 while (PORTB & 0x02) {
 if (--timeout == 0) {
 T1CON = 0x00;
 return 0;
 }
 }


 T1CON = 0x00;
 time = (TMR1H << 8) | TMR1L;


 return time / 116u;
}


void setup(){








 TRISB = 0x02;
 TRISC = 0x40;
 TRISD = 0x00;

 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;





 our_delay_ms(100);
}


void main(void)
 {



unsigned int distance;
setup();


 setupPWM();



 while (1)
 {
 while (1) {
 distance = measure_distance();
 if (distance < 20u) {
 motors_stop();
 continue;
 }
 motors_forward();
 Delay_ms(100);
 }
#line 187 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
 }
}
