
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;AgriBot.c,27 :: 		void interrupt() {
;AgriBot.c,28 :: 		if(PIR1.CCP1IF) {
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt0
;AgriBot.c,29 :: 		PIR1.CCP1IF = 0;  // Clear interrupt flag
	BCF        PIR1+0, 2
;AgriBot.c,31 :: 		if(servo_state == 0) {
	MOVF       _servo_state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;AgriBot.c,33 :: 		PORTC.B4 = 1;
	BSF        PORTC+0, 4
;AgriBot.c,34 :: 		servo_state = 1;
	MOVLW      1
	MOVWF      _servo_state+0
;AgriBot.c,39 :: 		CCPR1H = (pulse_width >> 8);
	MOVF       _pulse_width+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,40 :: 		CCPR1L = pulse_width;
	MOVF       _pulse_width+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,41 :: 		}
	GOTO       L_interrupt2
L_interrupt1:
;AgriBot.c,43 :: 		unsigned int low_time = 40000 - pulse_width;
	MOVF       _pulse_width+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _pulse_width+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
;AgriBot.c,45 :: 		PORTC.B4 = 0;
	BCF        PORTC+0, 4
;AgriBot.c,46 :: 		servo_state = 0;
	CLRF       _servo_state+0
;AgriBot.c,51 :: 		CCPR1H = (low_time >> 8);
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,52 :: 		CCPR1L = low_time;
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,53 :: 		}
L_interrupt2:
;AgriBot.c,54 :: 		}
L_interrupt0:
;AgriBot.c,55 :: 		}
L_end_interrupt:
L__interrupt82:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_init_ccp_servo:

;AgriBot.c,58 :: 		void init_ccp_servo() {
;AgriBot.c,60 :: 		TRISC.B4 = 0;
	BCF        TRISC+0, 4
;AgriBot.c,61 :: 		PORTC.B4 = 0;
	BCF        PORTC+0, 4
;AgriBot.c,64 :: 		T1CON = 0x01;     // Timer1 ON, 1:1 prescaler, internal clock
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,65 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,66 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,69 :: 		CCP1CON = 0x0B;   // Compare mode, trigger special event (reset Timer1)
	MOVLW      11
	MOVWF      CCP1CON+0
;AgriBot.c,72 :: 		CCPR1H = (pulse_width >> 8);
	MOVF       _pulse_width+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,73 :: 		CCPR1L = pulse_width;
	MOVF       _pulse_width+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,76 :: 		PIR1.CCP1IF = 0;  // Clear CCP1 interrupt flag
	BCF        PIR1+0, 2
;AgriBot.c,77 :: 		PIE1.CCP1IE = 1;  // Enable CCP1 interrupt
	BSF        PIE1+0, 2
;AgriBot.c,78 :: 		INTCON.PEIE = 1;  // Enable peripheral interrupts
	BSF        INTCON+0, 6
;AgriBot.c,79 :: 		INTCON.GIE = 1;   // Enable global interrupts
	BSF        INTCON+0, 7
;AgriBot.c,80 :: 		}
L_end_init_ccp_servo:
	RETURN
; end of _init_ccp_servo

_servo_set_angle:

;AgriBot.c,83 :: 		void servo_set_angle(unsigned int angle) {
;AgriBot.c,87 :: 		if(angle > 360) angle = 360;
	MOVF       FARG_servo_set_angle_angle+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__servo_set_angle85
	MOVF       FARG_servo_set_angle_angle+0, 0
	SUBLW      104
L__servo_set_angle85:
	BTFSC      STATUS+0, 0
	GOTO       L_servo_set_angle3
	MOVLW      104
	MOVWF      FARG_servo_set_angle_angle+0
	MOVLW      1
	MOVWF      FARG_servo_set_angle_angle+1
L_servo_set_angle3:
;AgriBot.c,92 :: 		temp = 1000 + ((unsigned long)angle * 4000 / 360);
	MOVF       FARG_servo_set_angle_angle+0, 0
	MOVWF      R0+0
	MOVF       FARG_servo_set_angle_angle+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      160
	MOVWF      R4+0
	MOVLW      15
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      104
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       R0+0, 0
	ADDWF      R4+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      R4+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      R4+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      R4+3, 1
;AgriBot.c,95 :: 		pulse_width = (unsigned int)temp;
	MOVF       R4+0, 0
	MOVWF      _pulse_width+0
	MOVF       R4+1, 0
	MOVWF      _pulse_width+1
;AgriBot.c,96 :: 		}
L_end_servo_set_angle:
	RETURN
; end of _servo_set_angle

_servo_angle_direct:

;AgriBot.c,99 :: 		void servo_angle_direct(unsigned int angle) {
;AgriBot.c,104 :: 		pulse = 1000 + ((unsigned long)angle * 4000 / 360);
	MOVF       FARG_servo_angle_direct_angle+0, 0
	MOVWF      R0+0
	MOVF       FARG_servo_angle_direct_angle+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      160
	MOVWF      R4+0
	MOVLW      15
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      104
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVLW      232
	MOVWF      servo_angle_direct_pulse_L0+0
	MOVLW      3
	MOVWF      servo_angle_direct_pulse_L0+1
	CLRF       servo_angle_direct_pulse_L0+2
	CLRF       servo_angle_direct_pulse_L0+3
	MOVF       R0+0, 0
	ADDWF      servo_angle_direct_pulse_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      servo_angle_direct_pulse_L0+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      servo_angle_direct_pulse_L0+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      servo_angle_direct_pulse_L0+3, 1
;AgriBot.c,107 :: 		INTCON.GIE = 0;
	BCF        INTCON+0, 7
;AgriBot.c,110 :: 		for(i = 0; i < 50; i++) {
	CLRF       servo_angle_direct_i_L0+0
	CLRF       servo_angle_direct_i_L0+1
L_servo_angle_direct4:
	MOVLW      0
	SUBWF      servo_angle_direct_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__servo_angle_direct87
	MOVLW      50
	SUBWF      servo_angle_direct_i_L0+0, 0
L__servo_angle_direct87:
	BTFSC      STATUS+0, 0
	GOTO       L_servo_angle_direct5
;AgriBot.c,112 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,113 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,116 :: 		CCPR1H = pulse >> 8;
	MOVF       servo_angle_direct_pulse_L0+1, 0
	MOVWF      R0+0
	MOVF       servo_angle_direct_pulse_L0+2, 0
	MOVWF      R0+1
	MOVF       servo_angle_direct_pulse_L0+3, 0
	MOVWF      R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,117 :: 		CCPR1L = pulse;
	MOVF       servo_angle_direct_pulse_L0+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,120 :: 		PORTC.B4 = 1;
	BSF        PORTC+0, 4
;AgriBot.c,123 :: 		PIR1.CCP1IF = 0;
	BCF        PIR1+0, 2
;AgriBot.c,124 :: 		while(!PIR1.CCP1IF);
L_servo_angle_direct7:
	BTFSC      PIR1+0, 2
	GOTO       L_servo_angle_direct8
	GOTO       L_servo_angle_direct7
L_servo_angle_direct8:
;AgriBot.c,127 :: 		PORTC.B4 = 0;
	BCF        PORTC+0, 4
;AgriBot.c,130 :: 		CCPR1H = (40000 - pulse) >> 8;
	MOVLW      64
	MOVWF      R0+0
	MOVLW      156
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	MOVF       R0+2, 0
	MOVWF      R5+2
	MOVF       R0+3, 0
	MOVWF      R5+3
	MOVF       servo_angle_direct_pulse_L0+0, 0
	SUBWF      R5+0, 1
	MOVF       servo_angle_direct_pulse_L0+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     servo_angle_direct_pulse_L0+1, 0
	SUBWF      R5+1, 1
	MOVF       servo_angle_direct_pulse_L0+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     servo_angle_direct_pulse_L0+2, 0
	SUBWF      R5+2, 1
	MOVF       servo_angle_direct_pulse_L0+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     servo_angle_direct_pulse_L0+3, 0
	SUBWF      R5+3, 1
	MOVF       R5+1, 0
	MOVWF      R0+0
	MOVF       R5+2, 0
	MOVWF      R0+1
	MOVF       R5+3, 0
	MOVWF      R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,131 :: 		CCPR1L = (40000 - pulse);
	MOVF       R5+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,134 :: 		PIR1.CCP1IF = 0;
	BCF        PIR1+0, 2
;AgriBot.c,135 :: 		while(!PIR1.CCP1IF);
L_servo_angle_direct9:
	BTFSC      PIR1+0, 2
	GOTO       L_servo_angle_direct10
	GOTO       L_servo_angle_direct9
L_servo_angle_direct10:
;AgriBot.c,110 :: 		for(i = 0; i < 50; i++) {
	INCF       servo_angle_direct_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       servo_angle_direct_i_L0+1, 1
;AgriBot.c,136 :: 		}
	GOTO       L_servo_angle_direct4
L_servo_angle_direct5:
;AgriBot.c,139 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;AgriBot.c,140 :: 		}
L_end_servo_angle_direct:
	RETURN
; end of _servo_angle_direct

_our_delay_ms:

;AgriBot.c,143 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,145 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms11:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms89
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms89:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms12
;AgriBot.c,146 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms14:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms90
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms90:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms15
	NOP
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_our_delay_ms14
L_our_delay_ms15:
;AgriBot.c,145 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,147 :: 		}
	GOTO       L_our_delay_ms11
L_our_delay_ms12:
;AgriBot.c,148 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

_trigger_pulse:

;AgriBot.c,194 :: 		void trigger_pulse(){
;AgriBot.c,195 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 0
;AgriBot.c,196 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse17:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse17
	NOP
;AgriBot.c,197 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 0
;AgriBot.c,198 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,200 :: 		unsigned int measure_distance(){
;AgriBot.c,201 :: 		unsigned int time = 0;
;AgriBot.c,203 :: 		unsigned int timer0_overflow = 0;
	CLRF       measure_distance_timer0_overflow_L0+0
	CLRF       measure_distance_timer0_overflow_L0+1
;AgriBot.c,205 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,208 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,209 :: 		while (!(PORTB & 0x02)) {
L_measure_distance18:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance19
;AgriBot.c,210 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance93
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance93:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance20
;AgriBot.c,211 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,212 :: 		}
L_measure_distance20:
;AgriBot.c,213 :: 		}
	GOTO       L_measure_distance18
L_measure_distance19:
;AgriBot.c,216 :: 		TMR0 = 0;              // Clear Timer0 register
	CLRF       TMR0+0
;AgriBot.c,217 :: 		timer0_overflow = 0;   // Reset overflow counter
	CLRF       measure_distance_timer0_overflow_L0+0
	CLRF       measure_distance_timer0_overflow_L0+1
;AgriBot.c,218 :: 		INTCON.T0IF = 0;       // Clear Timer0 interrupt flag
	BCF        INTCON+0, 2
;AgriBot.c,219 :: 		OPTION_REG = 0x80;     // Enable Timer0, internal clock, no prescaler
	MOVLW      128
	MOVWF      OPTION_REG+0
;AgriBot.c,222 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,223 :: 		while (PORTB & 0x02) {
L_measure_distance21:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance22
;AgriBot.c,225 :: 		if (INTCON.T0IF) {
	BTFSS      INTCON+0, 2
	GOTO       L_measure_distance23
;AgriBot.c,226 :: 		INTCON.T0IF = 0;    // Clear overflow flag
	BCF        INTCON+0, 2
;AgriBot.c,227 :: 		timer0_overflow++;
	INCF       measure_distance_timer0_overflow_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       measure_distance_timer0_overflow_L0+1, 1
;AgriBot.c,228 :: 		if (timer0_overflow > 200) {  // Prevent excessive overflow
	MOVF       measure_distance_timer0_overflow_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance94
	MOVF       measure_distance_timer0_overflow_L0+0, 0
	SUBLW      200
L__measure_distance94:
	BTFSC      STATUS+0, 0
	GOTO       L_measure_distance24
;AgriBot.c,229 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,230 :: 		}
L_measure_distance24:
;AgriBot.c,231 :: 		}
L_measure_distance23:
;AgriBot.c,232 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance95
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance95:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance25
;AgriBot.c,233 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,234 :: 		}
L_measure_distance25:
;AgriBot.c,235 :: 		}
	GOTO       L_measure_distance21
L_measure_distance22:
;AgriBot.c,238 :: 		time = (timer0_overflow * 256) + TMR0;
	MOVF       measure_distance_timer0_overflow_L0+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR0+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;AgriBot.c,245 :: 		return time / 145u;
	MOVLW      145
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,246 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_initCutter:

;AgriBot.c,249 :: 		void initCutter(void) {
;AgriBot.c,250 :: 		TRISB.F4 = 0;
	BCF        TRISB+0, 4
;AgriBot.c,251 :: 		PORTB.F4    = 0;
	BCF        PORTB+0, 4
;AgriBot.c,252 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,254 :: 		void cutter_on(void)  { PORTB.F4 = 1; }
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,255 :: 		void cutter_off(void) { PORTB.F4 = 0; }
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeed:

;AgriBot.c,260 :: 		void setSpeed(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeed_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeed:
	RETURN
; end of _setSpeed

_setupPWM:

;AgriBot.c,262 :: 		void setupPWM(void)
;AgriBot.c,266 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,270 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,273 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,274 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,277 :: 		setSpeed(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,278 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

;AgriBot.c,282 :: 		void motors_stop(void)
;AgriBot.c,284 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,286 :: 		setSpeed(0);
	CLRF       FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,287 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,289 :: 		void motors_forward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,292 :: 		while (1) {
L_motors_forward26:
;AgriBot.c,293 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_motors_forward28
;AgriBot.c,294 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,295 :: 		break;  // break out to handle new command
	GOTO       L_motors_forward27
;AgriBot.c,296 :: 		}
L_motors_forward28:
;AgriBot.c,297 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,298 :: 		if (distance < 10u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motors_forward103
	MOVLW      10
	SUBWF      R0+0, 0
L__motors_forward103:
	BTFSC      STATUS+0, 0
	GOTO       L_motors_forward29
;AgriBot.c,299 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,300 :: 		} else {
	GOTO       L_motors_forward30
L_motors_forward29:
;AgriBot.c,301 :: 		PORTD = 0b01011010;  // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,303 :: 		setSpeed(right_speed);
	MOVF       FARG_motors_forward_right_speed+0, 0
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,304 :: 		}
L_motors_forward30:
;AgriBot.c,305 :: 		}
	GOTO       L_motors_forward26
L_motors_forward27:
;AgriBot.c,306 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,308 :: 		void motors_backward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,310 :: 		PORTD = 0b10100101;  // Backward direction
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,312 :: 		setSpeed(right_speed);
	MOVF       FARG_motors_backward_right_speed+0, 0
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,313 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,315 :: 		void motors_left(void)
;AgriBot.c,317 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,319 :: 		setSpeed(150);
	MOVLW      150
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,320 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,322 :: 		void motors_right(void)
;AgriBot.c,324 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,326 :: 		setSpeed(150);
	MOVLW      150
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,327 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_init_io:

;AgriBot.c,330 :: 		void init_io(void) {
;AgriBot.c,331 :: 		TRISB &= 0xBF;     // RB6 output (0b10111111), clears bit 6
	MOVLW      191
	ANDWF      TRISB+0, 1
;AgriBot.c,332 :: 		PORTB.F6 = 1;      // relay off (active low input)
	BSF        PORTB+0, 6
;AgriBot.c,333 :: 		}
L_end_init_io:
	RETURN
; end of _init_io

_relay_control:

;AgriBot.c,335 :: 		void relay_control(char state) {
;AgriBot.c,336 :: 		if(state) {
	MOVF       FARG_relay_control_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_relay_control31
;AgriBot.c,337 :: 		PORTB.F6 = 0;  // turn relay ON (active low)
	BCF        PORTB+0, 6
;AgriBot.c,338 :: 		} else {
	GOTO       L_relay_control32
L_relay_control31:
;AgriBot.c,339 :: 		PORTB.F6 = 1;  // turn relay OFF
	BSF        PORTB+0, 6
;AgriBot.c,340 :: 		}
L_relay_control32:
;AgriBot.c,341 :: 		}
L_end_relay_control:
	RETURN
; end of _relay_control

_init_adc:

;AgriBot.c,346 :: 		void init_adc() {
;AgriBot.c,348 :: 		ADCON1 = 0x80;      // Right justified, all pins analog
	MOVLW      128
	MOVWF      ADCON1+0
;AgriBot.c,349 :: 		ADCON0 = 0x81;      // Channel 0 selected, ADC ON, Fosc/8
	MOVLW      129
	MOVWF      ADCON0+0
;AgriBot.c,351 :: 		delay_us(50);       // Allow ADC to stabilize
	MOVLW      33
	MOVWF      R13+0
L_init_adc33:
	DECFSZ     R13+0, 1
	GOTO       L_init_adc33
;AgriBot.c,352 :: 		}
L_end_init_adc:
	RETURN
; end of _init_adc

_read_adc:

;AgriBot.c,354 :: 		unsigned int read_adc(unsigned char channel) {
;AgriBot.c,356 :: 		ADCON0 &= 0xC7;              // Clear channel selection bits
	MOVLW      199
	ANDWF      ADCON0+0, 1
;AgriBot.c,357 :: 		ADCON0 |= (channel << 3);    // Set channel selection bits
	MOVF       FARG_read_adc_channel+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      ADCON0+0, 1
;AgriBot.c,359 :: 		delay_us(20);                // Acquisition time delay
	MOVLW      13
	MOVWF      R13+0
L_read_adc34:
	DECFSZ     R13+0, 1
	GOTO       L_read_adc34
;AgriBot.c,361 :: 		ADCON0.B2 = 1;               // Start conversion (set GO bit)
	BSF        ADCON0+0, 2
;AgriBot.c,362 :: 		while(ADCON0.B2);            // Wait for conversion complete
L_read_adc35:
	BTFSS      ADCON0+0, 2
	GOTO       L_read_adc36
	GOTO       L_read_adc35
L_read_adc36:
;AgriBot.c,365 :: 		return ((unsigned int)ADRESH << 8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,366 :: 		}
L_end_read_adc:
	RETURN
; end of _read_adc

_read_soil_moisture:

;AgriBot.c,368 :: 		unsigned int read_soil_moisture() {
;AgriBot.c,370 :: 		return read_adc(0);
	CLRF       FARG_read_adc_channel+0
	CALL       _read_adc+0
;AgriBot.c,371 :: 		}
L_end_read_soil_moisture:
	RETURN
; end of _read_soil_moisture

_delay_ms:

;AgriBot.c,375 :: 		void delay_ms(unsigned int ms) {
;AgriBot.c,377 :: 		for(i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_delay_ms37:
	MOVF       FARG_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_ms113
	MOVF       FARG_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__delay_ms113:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_ms38
;AgriBot.c,379 :: 		for(j = 0; j < 330; j++) {
	CLRF       R3+0
	CLRF       R3+1
L_delay_ms40:
	MOVLW      1
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_ms114
	MOVLW      74
	SUBWF      R3+0, 0
L__delay_ms114:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_ms41
;AgriBot.c,380 :: 		asm nop;
	NOP
;AgriBot.c,379 :: 		for(j = 0; j < 330; j++) {
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
;AgriBot.c,381 :: 		}
	GOTO       L_delay_ms40
L_delay_ms41:
;AgriBot.c,377 :: 		for(i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,382 :: 		}
	GOTO       L_delay_ms37
L_delay_ms38:
;AgriBot.c,383 :: 		}
L_end_delay_ms:
	RETURN
; end of _delay_ms

_setup:

;AgriBot.c,385 :: 		void setup(){
;AgriBot.c,387 :: 		TRISA = 0xFF;   // Port A as input (e.g., RA0 for analog sensor)
	MOVLW      255
	MOVWF      TRISA+0
;AgriBot.c,388 :: 		TRISB = 0x02;   // RB1 as input (e.g., sensor), others as output
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,389 :: 		TRISC = 0x40;   // RC6 (TX) as input (for USART), others as output
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,390 :: 		TRISD = 0x00;   // Port D as output
	CLRF       TRISD+0
;AgriBot.c,391 :: 		TRISE = 0x07;   // RE0-RE2 as input
	MOVLW      7
	MOVWF      TRISE+0
;AgriBot.c,394 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;AgriBot.c,395 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;AgriBot.c,396 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;AgriBot.c,397 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,401 :: 		TRISB.B6 = 0;
	BCF        TRISB+0, 6
;AgriBot.c,402 :: 		PORTB.B6 = 0;
	BCF        PORTB+0, 6
;AgriBot.c,404 :: 		init_io();
	CALL       _init_io+0
;AgriBot.c,407 :: 		our_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,416 :: 		}
L_end_setup:
	RETURN
; end of _setup

_bluetooth_init:

;AgriBot.c,418 :: 		void bluetooth_init() {
;AgriBot.c,419 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;AgriBot.c,420 :: 		our_delay_ms(100);   // Initialize UART with 9600 baud rate
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,421 :: 		}
L_end_bluetooth_init:
	RETURN
; end of _bluetooth_init

_read_soil_moisture_safe:

;AgriBot.c,423 :: 		unsigned int read_soil_moisture_safe() {
;AgriBot.c,424 :: 		unsigned char old_gie = INTCON.GIE;  // Save interrupt state
	MOVLW      0
	BTFSC      INTCON+0, 7
	MOVLW      1
	MOVWF      read_soil_moisture_safe_old_gie_L0+0
;AgriBot.c,425 :: 		unsigned int result = read_adc(0);
	CLRF       FARG_read_adc_channel+0
	CALL       _read_adc+0
;AgriBot.c,426 :: 		INTCON.GIE = 0;  // Disable interrupts during ADC
	BCF        INTCON+0, 7
;AgriBot.c,430 :: 		INTCON.GIE = old_gie;  // Restore interrupts
	BTFSC      read_soil_moisture_safe_old_gie_L0+0, 0
	GOTO       L__read_soil_moisture_safe118
	BCF        INTCON+0, 7
	GOTO       L__read_soil_moisture_safe119
L__read_soil_moisture_safe118:
	BSF        INTCON+0, 7
L__read_soil_moisture_safe119:
;AgriBot.c,431 :: 		return result;
;AgriBot.c,432 :: 		}
L_end_read_soil_moisture_safe:
	RETURN
; end of _read_soil_moisture_safe

_relay_control_fixed:

;AgriBot.c,435 :: 		void relay_control_fixed(char state) {
;AgriBot.c,436 :: 		if(state) {
	MOVF       FARG_relay_control_fixed_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_relay_control_fixed43
;AgriBot.c,437 :: 		PORTB.B6 = 1;   // Turn relay ON (try HIGH first)
	BSF        PORTB+0, 6
;AgriBot.c,438 :: 		} else {
	GOTO       L_relay_control_fixed44
L_relay_control_fixed43:
;AgriBot.c,439 :: 		PORTB.B6 = 0;   // Turn relay OFF (try LOW first)
	BCF        PORTB+0, 6
;AgriBot.c,440 :: 		}
L_relay_control_fixed44:
;AgriBot.c,443 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_relay_control_fixed45:
	DECFSZ     R13+0, 1
	GOTO       L_relay_control_fixed45
	DECFSZ     R12+0, 1
	GOTO       L_relay_control_fixed45
	NOP
;AgriBot.c,444 :: 		}
L_end_relay_control_fixed:
	RETURN
; end of _relay_control_fixed

_main:

;AgriBot.c,447 :: 		void main(void)
;AgriBot.c,452 :: 		setup();
	CALL       _setup+0
;AgriBot.c,453 :: 		bluetooth_init();
	CALL       _bluetooth_init+0
;AgriBot.c,454 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,455 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,456 :: 		init_ccp_servo();
	CALL       _init_ccp_servo+0
;AgriBot.c,458 :: 		init_adc();
	CALL       _init_adc+0
;AgriBot.c,460 :: 		blink_counter = 0;
	CLRF       _blink_counter+0
	CLRF       _blink_counter+1
;AgriBot.c,462 :: 		Delay_us(100);
	MOVLW      66
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	NOP
;AgriBot.c,464 :: 		while (1)
L_main47:
;AgriBot.c,466 :: 		servo_set_angle(0);
	CLRF       FARG_servo_set_angle_angle+0
	CLRF       FARG_servo_set_angle_angle+1
	CALL       _servo_set_angle+0
;AgriBot.c,467 :: 		if (UART1_Data_Ready()) {          // Check if data is available
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main49
;AgriBot.c,468 :: 		command = UART1_Read();        // Read one character
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,469 :: 		switch(command){
	GOTO       L_main50
;AgriBot.c,470 :: 		case 'F':
L_main52:
;AgriBot.c,471 :: 		motors_forward(150, 150);
	MOVLW      150
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,472 :: 		break;
	GOTO       L_main51
;AgriBot.c,474 :: 		case 'B':
L_main53:
;AgriBot.c,475 :: 		motors_backward(100, 100);
	MOVLW      100
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,476 :: 		break;
	GOTO       L_main51
;AgriBot.c,478 :: 		case 'R':
L_main54:
;AgriBot.c,479 :: 		motors_right();
	CALL       _motors_right+0
;AgriBot.c,480 :: 		break;
	GOTO       L_main51
;AgriBot.c,482 :: 		case 'L':
L_main55:
;AgriBot.c,483 :: 		motors_left();
	CALL       _motors_left+0
;AgriBot.c,485 :: 		break;
	GOTO       L_main51
;AgriBot.c,487 :: 		case 'S':
L_main56:
;AgriBot.c,488 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,489 :: 		break;
	GOTO       L_main51
;AgriBot.c,491 :: 		case 'G':   // Forward left
L_main57:
;AgriBot.c,492 :: 		motors_forward(100, 150);
	MOVLW      100
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,493 :: 		break;
	GOTO       L_main51
;AgriBot.c,495 :: 		case 'H':   // Forward right
L_main58:
;AgriBot.c,496 :: 		motors_forward(150, 100);
	MOVLW      150
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,497 :: 		break;
	GOTO       L_main51
;AgriBot.c,499 :: 		case 'I':   // Backward left
L_main59:
;AgriBot.c,500 :: 		motors_backward(100, 150);
	MOVLW      100
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,501 :: 		break;
	GOTO       L_main51
;AgriBot.c,503 :: 		case 'J':   // Backward right
L_main60:
;AgriBot.c,504 :: 		motors_backward(150, 100);
	MOVLW      150
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,505 :: 		break;
	GOTO       L_main51
;AgriBot.c,507 :: 		case 'X':   // Turn headlight ON
L_main61:
;AgriBot.c,508 :: 		cutter_on();
	CALL       _cutter_on+0
;AgriBot.c,509 :: 		break;
	GOTO       L_main51
;AgriBot.c,511 :: 		case 'x':   // Turn headlight OFF
L_main62:
;AgriBot.c,512 :: 		cutter_off();
	CALL       _cutter_off+0
;AgriBot.c,513 :: 		break;
	GOTO       L_main51
;AgriBot.c,514 :: 		case 'Y':
L_main63:
;AgriBot.c,516 :: 		PORTB.B3 = 0; Delay_ms(200); PORTB.B3 = 1; Delay_ms(200);
	BCF        PORTB+0, 3
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main64:
	DECFSZ     R13+0, 1
	GOTO       L_main64
	DECFSZ     R12+0, 1
	GOTO       L_main64
	DECFSZ     R11+0, 1
	GOTO       L_main64
	BSF        PORTB+0, 3
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main65:
	DECFSZ     R13+0, 1
	GOTO       L_main65
	DECFSZ     R12+0, 1
	GOTO       L_main65
	DECFSZ     R11+0, 1
	GOTO       L_main65
;AgriBot.c,519 :: 		servo_set_angle(180);  // Move to scanning position
	MOVLW      180
	MOVWF      FARG_servo_set_angle_angle+0
	CLRF       FARG_servo_set_angle_angle+1
	CALL       _servo_set_angle+0
;AgriBot.c,520 :: 		Delay_ms(2000);        // Wait for servo to reach position
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main66:
	DECFSZ     R13+0, 1
	GOTO       L_main66
	DECFSZ     R12+0, 1
	GOTO       L_main66
	DECFSZ     R11+0, 1
	GOTO       L_main66
	NOP
;AgriBot.c,523 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main67:
	DECFSZ     R13+0, 1
	GOTO       L_main67
	DECFSZ     R12+0, 1
	GOTO       L_main67
	DECFSZ     R11+0, 1
	GOTO       L_main67
	NOP
	NOP
;AgriBot.c,524 :: 		moisture_value = read_soil_moisture_safe();
	CALL       _read_soil_moisture_safe+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _moisture_value+0
	MOVF       FLOC__main+1, 0
	MOVWF      _moisture_value+1
;AgriBot.c,525 :: 		moisture_percentage = (moisture_value * 100) / 1023;
	MOVF       FLOC__main+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _moisture_percentage+0
	MOVF       R0+1, 0
	MOVWF      _moisture_percentage+1
;AgriBot.c,528 :: 		PIE1.CCP1IE = 0;       // Disable CCP1 interrupt
	BCF        PIE1+0, 2
;AgriBot.c,529 :: 		PORTC.B4 = 0;          // Stop servo signal
	BCF        PORTC+0, 4
;AgriBot.c,532 :: 		if(moisture_value > 500) {
	MOVF       FLOC__main+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main122
	MOVF       FLOC__main+0, 0
	SUBLW      244
L__main122:
	BTFSC      STATUS+0, 0
	GOTO       L_main68
;AgriBot.c,534 :: 		PORTB.B6 = 1;
	BSF        PORTB+0, 6
;AgriBot.c,537 :: 		Delay_ms(500);  // Run pump for 5 seconds
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main69:
	DECFSZ     R13+0, 1
	GOTO       L_main69
	DECFSZ     R12+0, 1
	GOTO       L_main69
	DECFSZ     R11+0, 1
	GOTO       L_main69
	NOP
	NOP
;AgriBot.c,540 :: 		PORTB.B6 = 0;
	BCF        PORTB+0, 6
;AgriBot.c,542 :: 		} else {
	GOTO       L_main70
L_main68:
;AgriBot.c,544 :: 		PORTB.B6 = 0;
	BCF        PORTB+0, 6
;AgriBot.c,548 :: 		}
L_main70:
;AgriBot.c,553 :: 		PIE1.CCP1IE = 1;       // Re-enable CCP1 interrupt
	BSF        PIE1+0, 2
;AgriBot.c,556 :: 		for(angle = 0; angle <= 360; angle += 10) {
	CLRF       main_angle_L0+0
	CLRF       main_angle_L0+1
L_main71:
	MOVF       main_angle_L0+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main123
	MOVF       main_angle_L0+0, 0
	SUBLW      104
L__main123:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
;AgriBot.c,557 :: 		servo_angle_direct(angle);
	MOVF       main_angle_L0+0, 0
	MOVWF      FARG_servo_angle_direct_angle+0
	MOVF       main_angle_L0+1, 0
	MOVWF      FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,558 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main74:
	DECFSZ     R13+0, 1
	GOTO       L_main74
	DECFSZ     R12+0, 1
	GOTO       L_main74
	DECFSZ     R11+0, 1
	GOTO       L_main74
	NOP
;AgriBot.c,556 :: 		for(angle = 0; angle <= 360; angle += 10) {
	MOVLW      10
	ADDWF      main_angle_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       main_angle_L0+1, 1
;AgriBot.c,559 :: 		}
	GOTO       L_main71
L_main72:
;AgriBot.c,561 :: 		for(angle = 0; angle <= 180; angle += 10) {
	CLRF       main_angle_L0+0
	CLRF       main_angle_L0+1
L_main75:
	MOVF       main_angle_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVF       main_angle_L0+0, 0
	SUBLW      180
L__main124:
	BTFSS      STATUS+0, 0
	GOTO       L_main76
;AgriBot.c,562 :: 		servo_angle_direct(angle);
	MOVF       main_angle_L0+0, 0
	MOVWF      FARG_servo_angle_direct_angle+0
	MOVF       main_angle_L0+1, 0
	MOVWF      FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,563 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main78:
	DECFSZ     R13+0, 1
	GOTO       L_main78
	DECFSZ     R12+0, 1
	GOTO       L_main78
	DECFSZ     R11+0, 1
	GOTO       L_main78
	NOP
;AgriBot.c,561 :: 		for(angle = 0; angle <= 180; angle += 10) {
	MOVLW      10
	ADDWF      main_angle_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       main_angle_L0+1, 1
;AgriBot.c,564 :: 		}
	GOTO       L_main75
L_main76:
;AgriBot.c,566 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main79:
	DECFSZ     R13+0, 1
	GOTO       L_main79
	DECFSZ     R12+0, 1
	GOTO       L_main79
	DECFSZ     R11+0, 1
	GOTO       L_main79
	NOP
	NOP
;AgriBot.c,569 :: 		servo_angle_direct(0);
	CLRF       FARG_servo_angle_direct_angle+0
	CLRF       FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,570 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main80:
	DECFSZ     R13+0, 1
	GOTO       L_main80
	DECFSZ     R12+0, 1
	GOTO       L_main80
	DECFSZ     R11+0, 1
	GOTO       L_main80
	NOP
;AgriBot.c,572 :: 		break;
	GOTO       L_main51
;AgriBot.c,573 :: 		}
L_main50:
	MOVF       _command+0, 0
	XORLW      70
	BTFSC      STATUS+0, 2
	GOTO       L_main52
	MOVF       _command+0, 0
	XORLW      66
	BTFSC      STATUS+0, 2
	GOTO       L_main53
	MOVF       _command+0, 0
	XORLW      82
	BTFSC      STATUS+0, 2
	GOTO       L_main54
	MOVF       _command+0, 0
	XORLW      76
	BTFSC      STATUS+0, 2
	GOTO       L_main55
	MOVF       _command+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_main56
	MOVF       _command+0, 0
	XORLW      71
	BTFSC      STATUS+0, 2
	GOTO       L_main57
	MOVF       _command+0, 0
	XORLW      72
	BTFSC      STATUS+0, 2
	GOTO       L_main58
	MOVF       _command+0, 0
	XORLW      73
	BTFSC      STATUS+0, 2
	GOTO       L_main59
	MOVF       _command+0, 0
	XORLW      74
	BTFSC      STATUS+0, 2
	GOTO       L_main60
	MOVF       _command+0, 0
	XORLW      88
	BTFSC      STATUS+0, 2
	GOTO       L_main61
	MOVF       _command+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_main62
	MOVF       _command+0, 0
	XORLW      89
	BTFSC      STATUS+0, 2
	GOTO       L_main63
L_main51:
;AgriBot.c,574 :: 		}
L_main49:
;AgriBot.c,575 :: 		}
	GOTO       L_main47
;AgriBot.c,576 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
