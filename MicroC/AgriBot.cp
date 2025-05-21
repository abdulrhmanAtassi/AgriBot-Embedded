#line 1 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
#line 413 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
void setup (void);
void Timer1_Init (void);
void Timer2_Init (void);
void Set_Servo_Angle(unsigned char angle);


volatile unsigned int servo_pulse_us = 1500;
volatile unsigned char pulse_started = 0;


<<<<<<< Updated upstream


unsigned int servo_pulse_us = 1500;
char pulse_started = 0;



void Timer1_Init()

{
 T1CON = 0b00000001;
 TMR1H = 0x0B;
 TMR1L = 0xDC;
 TMR1IF_bit = 0;
 TMR1IE_bit = 1;
 PEIE_bit = 1;
 GIE_bit = 1;
}


void Timer2_Init()
{
 T2CON = 0b00000111;
 PR2 = 249;
 TMR2IF_bit = 0;
 TMR2IE_bit = 1;
}


void Set_Servo_Angle(unsigned char angle)
{

 servo_pulse_us = ((angle * 10) / 9) + 1000;
}


void interrupt()
{
 unsigned int ticks;


 if (TMR1IF_bit)
 {
 TMR1IF_bit = 0;
 TMR1H = 0x0B;
 TMR1L = 0xDC;

 pulse_started = 1;
 PORTB.F3 = 1;


 ticks = servo_pulse_us / 4;
 PR2 = ticks;
 TMR2 = 0;
 TMR2ON_bit = 1;
 }


 if (TMR2IF_bit && pulse_started)
 {
 TMR2IF_bit = 0;
 PORTB.F3 = 0;
 pulse_started = 0;
 TMR2ON_bit = 0;
 }
}






void trigger_pulse(){
  PORTB.F0  = 1;
 delay_us(10);
  PORTB.F0  = 0;
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



void initCutter(void) {
 TRISB.F4 = 0;
 PORTB.F4 = 0;
}

void cutter_on(void) { PORTB.F4 = 1; }
void cutter_off(void) { PORTB.F4 = 0; }


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
#line 201 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
void motors_forward(unsigned char left_speed, unsigned char right_speed)
{
 unsigned int distance ;
 while (1) {
 if (UART1_Data_Ready()) {
 command = UART1_Read();
 break;
 }
 distance = measure_distance();
 if (distance < 20u) {
 motors_stop();
 } else {
 PORTD = 0b01011010;
 setSpeedLeft(left_speed);
 setSpeedRight(right_speed);
 }
 }
}

void motors_backward(unsigned char left_speed, unsigned char right_speed)
{
 PORTD = 0b10100101;
 setSpeedLeft(left_speed);
 setSpeedRight(right_speed);
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



void setup(){










 TRISB = 0x02;
 TRISC = 0x40;
 TRISD = 0x00;

 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;





 our_delay_ms(100);
}

void bluetooth_init() {
 UART1_Init(9600);
 our_delay_ms(100);
}



void main(void)
 {

 setup();
 bluetooth_init();
 initCutter();
 setupPWM();

 Timer1_Init();
 Timer2_Init();
 Set_Servo_Angle(90);
=======
void setup(void)
{

 TRISB = 0x00;
 PORTB = 0x00;


>>>>>>> Stashed changes
 TRISB.F3 = 0;
 PORTB.F3 = 0;
}


void Timer1_Init(void)
{
#line 440 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
 T1CON = 0b00000001;
 TMR1H = 0x63;
 TMR1L = 0xC0;
 TMR1IF_bit = 0;
 TMR1IE_bit = 1;
}


void Timer2_Init(void)
{

 T2CON = 0b00000100;
 PR2 = 250;
 TMR2IF_bit = 0;
 TMR2IE_bit = 1;
}


void Set_Servo_Angle(unsigned char angle)
{

 servo_pulse_us = ((unsigned int)angle * 1000u) / 180u + 1000u;
}


void interrupt(void)
{

 if (TMR1IF_bit)
 {
 unsigned int ticks;

 TMR1IF_bit = 0;
 TMR1H = 0x63;
 TMR1L = 0xC0;

 pulse_started = 1;
 PORTB.F3 = 1;


 ticks = servo_pulse_us / 8u;
 PR2 = (unsigned char)ticks;
 TMR2 = 0;
 TMR2ON_bit = 1;
 }


 if (TMR2IF_bit && pulse_started)
 {
 TMR2IF_bit = 0;
 TMR2ON_bit = 0;
 PORTB.F3 = 0;
 pulse_started = 0;
 }
}


void main(void)
{
 setup();

 Timer1_Init();
 Timer2_Init();

 PEIE_bit = 1;
 GIE_bit = 1;


 while (1)
 {
<<<<<<< Updated upstream
#line 345 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
 PORTB.F3 = 1;
 Delay_us(15000);
 PORTB.F3 = 0;
 Delay_ms(20);

=======
 Set_Servo_Angle(0); Delay_ms(1000);
 Set_Servo_Angle(90); Delay_ms(1000);
 Set_Servo_Angle(180); Delay_ms(1000);
>>>>>>> Stashed changes
 }
}
