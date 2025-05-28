#line 1 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
#line 13 "C:/Users/20210651/Documents/GitHub/AgriBot-Embedded/MicroC/AgriBot.c"
unsigned int moisture_value;
unsigned int moisture_percentage;
unsigned int blink_counter;
char command;


void custom_delay_us(unsigned int us) {
 unsigned int i;


 for(i = 0; i < us; i++) {
 asm nop;
 asm nop;
 }
}

void custom_delay_ms(unsigned int ms) {
 unsigned int i, j;
 for(i = 0; i < ms; i++) {
 for(j = 0; j < 400; j++) {
 asm nop;
 asm nop;
 asm nop;
 asm nop;
 asm nop;
 }
 }
}


unsigned int pulse_width = 3000;
unsigned char servo_state = 0;


void interrupt() {
 if(PIR1 & 0x04) {
 PIR1 &= ~0x04;

 if(servo_state == 0) {

 PORTC |= 0x10;
 servo_state = 1;


 CCPR1H = (pulse_width >> 8);
 CCPR1L = pulse_width;
 }
 else {
 unsigned int low_time = 40000 - pulse_width;

 PORTC &= ~0x10;
 servo_state = 0;


 CCPR1H = (low_time >> 8);
 CCPR1L = low_time;
 }
 }
}


void init_ccp_servo() {

 TRISC &= ~0x10;
 PORTC &= ~0x10;


 T1CON = 0x01;
 TMR1H = 0;
 TMR1L = 0;


 CCP1CON = 0x0B;


 CCPR1H = (pulse_width >> 8);
 CCPR1L = pulse_width;


 PIR1 &= ~0x04;
 PIE1 |= 0x04;
 INTCON |= 0x40;
 INTCON |= 0x80;
}


void servo_set_angle(unsigned int angle) {
 unsigned long temp;


 if(angle > 360) angle = 360;


 temp = 1000 + ((unsigned long)angle * 4000 / 360);


 pulse_width = (unsigned int)temp;
}


void servo_angle_direct(unsigned int angle) {
 unsigned int i;
 unsigned long pulse;


 pulse = 1000 + ((unsigned long)angle * 4000 / 360);


 INTCON &= ~0x80;


 for(i = 0; i < 50; i++) {

 TMR1H = 0;
 TMR1L = 0;


 CCPR1H = pulse >> 8;
 CCPR1L = pulse;


 PORTC |= 0x10;


 PIR1 &= ~0x04;
 while(!(PIR1 & 0x04));


 PORTC &= ~0x10;


 CCPR1H = (40000 - pulse) >> 8;
 CCPR1L = (40000 - pulse);


 PIR1 &= ~0x04;
 while(!(PIR1 & 0x04));
 }


 INTCON |= 0x80;
}


void trigger_pulse(){
 PORTB |=  0x01 ;
 custom_delay_us(10);
 PORTB &= ~ 0x01 ;
}

unsigned int measure_distance(){
 unsigned int time = 0;
 unsigned int timeout;
 unsigned int timer0_overflow = 0;

 trigger_pulse();


 timeout = 0xFFFF;
 while (!(PORTB &  0x02 )) {
 if (--timeout == 0) {
 return 0;
 }
 }


 TMR0 = 0;
 timer0_overflow = 0;
 INTCON &= ~0x04;
 OPTION_REG = 0x80;


 timeout = 0xFFFF;
 while (PORTB &  0x02 ) {

 if (INTCON & 0x04) {
 INTCON &= ~0x04;
 timer0_overflow++;
 if (timer0_overflow > 200) {
 return 0;
 }
 }
 if (--timeout == 0) {
 return 0;
 }
 }


 time = (timer0_overflow * 256) + TMR0;


 return time / 145u;
}


void initCutter(void) {
 TRISB &= ~0x10;
 PORTB &= ~0x10;
}

void cutter_on(void) { PORTB |= 0x10; }
void cutter_off(void) { PORTB &= ~0x10; }


void setSpeed(unsigned char duty) { CCPR2L = duty; }

void setupPWM(void) {

 TRISC &= ~0x02;


 CCP2CON = 0x0C;


 PR2 = 249;
 T2CON = 0x05;

 setSpeed(128);
}


void motors_stop(void) {
 PORTD = 0x00;
 setSpeed(0);
}

void motors_forward(unsigned char left_speed, unsigned char right_speed) {
 unsigned int distance;
 while (1) {
 if (UART1_Data_Ready()) {
 command = UART1_Read();
 break;
 }
 distance = measure_distance();
 if (distance < 10u) {
 motors_stop();
 } else {
 PORTD = 0x5A;
 setSpeed(right_speed);
 }
 }
}

void motors_backward(unsigned char left_speed, unsigned char right_speed) {
 PORTD = 0xA5;
 setSpeed(right_speed);
}

void motors_left(void) {
 PORTD = 0x55;
 setSpeed(150);
}

void motors_right(void) {
 PORTD = 0xAA;
 setSpeed(150);
}


void init_io(void) {
 TRISB &= ~0x40;
 PORTB |= 0x40;
}

void relay_control(char state) {
 if(state) {
 PORTB &= ~0x40;
 } else {
 PORTB |= 0x40;
 }
}


void init_adc() {
 ADCON1 = 0x80;
 ADCON0 = 0x81;
 custom_delay_us(50);
}

unsigned int read_adc(unsigned char channel) {

 ADCON0 &= 0xC7;
 ADCON0 |= (channel << 3);

 custom_delay_us(20);

 ADCON0 |= 0x04;
 while(ADCON0 & 0x04);


 return ((unsigned int)ADRESH << 8) | ADRESL;
}

unsigned int read_soil_moisture() {
 return read_adc(0);
}

unsigned int read_soil_moisture_safe() {
 unsigned char old_gie = INTCON & 0x80;
 unsigned int result = read_adc(0);
 INTCON &= ~0x80;

 if(old_gie) INTCON |= 0x80;
 return result;
}

void relay_control_fixed(char state) {
 if(state) {
 PORTB |= 0x40;
 } else {
 PORTB &= ~0x40;
 }
 custom_delay_ms(10);
}


void setup() {

 TRISA = 0xFF;
 TRISB = 0x02;
 TRISC = 0x40;
 TRISD = 0x00;
 TRISE = 0x07;


 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;


 TRISB &= ~0x40;
 PORTB &= ~0x40;


 init_io();


 custom_delay_ms(100);
}

void bluetooth_init() {
 UART1_Init(9600);
 custom_delay_ms(100);
}


void main(void) {
 unsigned int angle;


 setup();
 bluetooth_init();
 initCutter();
 setupPWM();
 init_ccp_servo();
 init_adc();

 blink_counter = 0;
 custom_delay_us(100);

 while (1) {
 servo_set_angle(0);
 if (UART1_Data_Ready()) {
 command = UART1_Read();
 switch(command) {
 case 'F':
 motors_forward(150, 150);
 break;

 case 'B':
 motors_backward(100, 100);
 break;

 case 'R':
 motors_right();
 break;

 case 'L':
 motors_left();
 break;

 case 'S':
 motors_stop();
 break;

 case 'G':
 motors_forward(100, 150);
 break;

 case 'H':
 motors_forward(150, 100);
 break;

 case 'I':
 motors_backward(100, 150);
 break;

 case 'J':
 motors_backward(150, 100);
 break;

 case 'X':
 cutter_on();
 break;

 case 'x':
 cutter_off();
 break;

 case 'Y':

 PORTB &= ~0x08; custom_delay_ms(200);
 PORTB |= 0x08; custom_delay_ms(200);


 servo_set_angle(180);
 custom_delay_ms(2000);


 custom_delay_ms(500);
 moisture_value = read_soil_moisture_safe();
 moisture_percentage = (moisture_value * 100) / 1023;


 PIE1 &= ~0x04;
 PORTC &= ~0x10;


 if(moisture_value > 500) {

 PORTB |= 0x40;
 custom_delay_ms(500);
 PORTB &= ~0x40;
 } else {

 PORTB &= ~0x40;
 }


 PIE1 |= 0x04;


 for(angle = 0; angle <= 360; angle += 10) {
 servo_angle_direct(angle);
 custom_delay_ms(100);
 }

 for(angle = 0; angle <= 180; angle += 10) {
 servo_angle_direct(angle);
 custom_delay_ms(100);
 }

 custom_delay_ms(1000);


 servo_angle_direct(0);
 custom_delay_ms(2000);

 break;
 }
 }
 }
}
