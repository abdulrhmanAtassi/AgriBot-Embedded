#line 1 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
#line 13 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
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


void init_ultrasonic(void)
{
 TRISB.F0 = 0;
 TRISB.F1 = 1;
}

void trigger_ultrasonic(void)
{
  PORTB.F0  = 0;
 Delay_us(2);

  PORTB.F0  = 1;
 Delay_us(10);

  PORTB.F0  = 0;
}

unsigned int read_distance_cm(void)
{
 unsigned int ticks;

 trigger_ultrasonic();


 while (! PORTB.F1 );

 TMR1H = 0;
 TMR1L = 0;
 T1CON = 0x01;

 while ( PORTB.F1 );

 T1CON = 0x00;
 ticks = ((unsigned int)TMR1H << 8) | TMR1L;
#line 73 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
 return ticks / 290;
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


void main(void)
{
 TRISD = 0x00;
 PORTD = 0x00;

 setupPWM();
 init_ultrasonic();

 while (1)
 {
 motors_forward();
 Delay_ms(400);
 if (read_distance_cm() < 20) motors_stop();
#line 138 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/AgriBot.c"
 }
}
