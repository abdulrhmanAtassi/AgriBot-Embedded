
_custom_delay_us:

;AgriBot.c,19 :: 		void custom_delay_us(unsigned int us) {
;AgriBot.c,23 :: 		for(i = 0; i < us; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_custom_delay_us0:
	MOVF       FARG_custom_delay_us_us+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__custom_delay_us66
	MOVF       FARG_custom_delay_us_us+0, 0
	SUBWF      R1+0, 0
L__custom_delay_us66:
	BTFSC      STATUS+0, 0
	GOTO       L_custom_delay_us1
;AgriBot.c,24 :: 		asm nop;
	NOP
;AgriBot.c,25 :: 		asm nop;
	NOP
;AgriBot.c,23 :: 		for(i = 0; i < us; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,26 :: 		}
	GOTO       L_custom_delay_us0
L_custom_delay_us1:
;AgriBot.c,27 :: 		}
L_end_custom_delay_us:
	RETURN
; end of _custom_delay_us

_custom_delay_ms:

;AgriBot.c,29 :: 		void custom_delay_ms(unsigned int ms) {
;AgriBot.c,31 :: 		for(i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_custom_delay_ms3:
	MOVF       FARG_custom_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__custom_delay_ms68
	MOVF       FARG_custom_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__custom_delay_ms68:
	BTFSC      STATUS+0, 0
	GOTO       L_custom_delay_ms4
;AgriBot.c,32 :: 		for(j = 0; j < 400; j++) {
	CLRF       R3+0
	CLRF       R3+1
L_custom_delay_ms6:
	MOVLW      1
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__custom_delay_ms69
	MOVLW      144
	SUBWF      R3+0, 0
L__custom_delay_ms69:
	BTFSC      STATUS+0, 0
	GOTO       L_custom_delay_ms7
;AgriBot.c,33 :: 		asm nop;
	NOP
;AgriBot.c,34 :: 		asm nop;
	NOP
;AgriBot.c,35 :: 		asm nop;
	NOP
;AgriBot.c,36 :: 		asm nop;
	NOP
;AgriBot.c,37 :: 		asm nop;
	NOP
;AgriBot.c,32 :: 		for(j = 0; j < 400; j++) {
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
;AgriBot.c,38 :: 		}
	GOTO       L_custom_delay_ms6
L_custom_delay_ms7:
;AgriBot.c,31 :: 		for(i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,39 :: 		}
	GOTO       L_custom_delay_ms3
L_custom_delay_ms4:
;AgriBot.c,40 :: 		}
L_end_custom_delay_ms:
	RETURN
; end of _custom_delay_ms

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;AgriBot.c,47 :: 		void interrupt() {
;AgriBot.c,48 :: 		if(PIR1 & 0x04) {  // Check CCP1IF bit (bit 2)
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt9
;AgriBot.c,49 :: 		PIR1 &= ~0x04;  // Clear CCP1IF flag
	BCF        PIR1+0, 2
;AgriBot.c,51 :: 		if(servo_state == 0) {
	MOVF       _servo_state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt10
;AgriBot.c,53 :: 		PORTC |= 0x10;  // Set bit 4
	BSF        PORTC+0, 4
;AgriBot.c,54 :: 		servo_state = 1;
	MOVLW      1
	MOVWF      _servo_state+0
;AgriBot.c,57 :: 		CCPR1H = (pulse_width >> 8);
	MOVF       _pulse_width+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,58 :: 		CCPR1L = pulse_width;
	MOVF       _pulse_width+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,59 :: 		}
	GOTO       L_interrupt11
L_interrupt10:
;AgriBot.c,61 :: 		unsigned int low_time = 40000 - pulse_width;
	MOVF       _pulse_width+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _pulse_width+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
;AgriBot.c,63 :: 		PORTC &= ~0x10;  // Clear bit 4
	BCF        PORTC+0, 4
;AgriBot.c,64 :: 		servo_state = 0;
	CLRF       _servo_state+0
;AgriBot.c,67 :: 		CCPR1H = (low_time >> 8);
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,68 :: 		CCPR1L = low_time;
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,69 :: 		}
L_interrupt11:
;AgriBot.c,70 :: 		}
L_interrupt9:
;AgriBot.c,71 :: 		}
L_end_interrupt:
L__interrupt71:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_init_ccp_servo:

;AgriBot.c,74 :: 		void init_ccp_servo() {
;AgriBot.c,76 :: 		TRISC &= ~0x10;  // Clear bit 4 (output)
	BCF        TRISC+0, 4
;AgriBot.c,77 :: 		PORTC &= ~0x10;  // Clear bit 4 (low)
	BCF        PORTC+0, 4
;AgriBot.c,80 :: 		T1CON = 0x01;     // Timer1 ON, 1:1 prescaler, internal clock
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,81 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,82 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,85 :: 		CCP1CON = 0x0B;   // Compare mode, trigger special event
	MOVLW      11
	MOVWF      CCP1CON+0
;AgriBot.c,88 :: 		CCPR1H = (pulse_width >> 8);
	MOVF       _pulse_width+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,89 :: 		CCPR1L = pulse_width;
	MOVF       _pulse_width+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,92 :: 		PIR1 &= ~0x04;   // Clear CCP1IF flag
	BCF        PIR1+0, 2
;AgriBot.c,93 :: 		PIE1 |= 0x04;    // Enable CCP1IE interrupt
	BSF        PIE1+0, 2
;AgriBot.c,94 :: 		INTCON |= 0x40;  // Enable PEIE
	BSF        INTCON+0, 6
;AgriBot.c,95 :: 		INTCON |= 0x80;  // Enable GIE
	BSF        INTCON+0, 7
;AgriBot.c,96 :: 		}
L_end_init_ccp_servo:
	RETURN
; end of _init_ccp_servo

_servo_set_angle:

;AgriBot.c,99 :: 		void servo_set_angle(unsigned int angle) {
;AgriBot.c,103 :: 		if(angle > 360) angle = 360;
	MOVF       FARG_servo_set_angle_angle+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__servo_set_angle74
	MOVF       FARG_servo_set_angle_angle+0, 0
	SUBLW      104
L__servo_set_angle74:
	BTFSC      STATUS+0, 0
	GOTO       L_servo_set_angle12
	MOVLW      104
	MOVWF      FARG_servo_set_angle_angle+0
	MOVLW      1
	MOVWF      FARG_servo_set_angle_angle+1
L_servo_set_angle12:
;AgriBot.c,106 :: 		temp = 1000 + ((unsigned long)angle * 4000 / 360);
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
;AgriBot.c,109 :: 		pulse_width = (unsigned int)temp;
	MOVF       R4+0, 0
	MOVWF      _pulse_width+0
	MOVF       R4+1, 0
	MOVWF      _pulse_width+1
;AgriBot.c,110 :: 		}
L_end_servo_set_angle:
	RETURN
; end of _servo_set_angle

_servo_angle_direct:

;AgriBot.c,113 :: 		void servo_angle_direct(unsigned int angle) {
;AgriBot.c,118 :: 		pulse = 1000 + ((unsigned long)angle * 4000 / 360);
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
;AgriBot.c,121 :: 		INTCON &= ~0x80;  // Clear GIE
	MOVLW      127
	ANDWF      INTCON+0, 1
;AgriBot.c,124 :: 		for(i = 0; i < 50; i++) {
	CLRF       servo_angle_direct_i_L0+0
	CLRF       servo_angle_direct_i_L0+1
L_servo_angle_direct13:
	MOVLW      0
	SUBWF      servo_angle_direct_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__servo_angle_direct76
	MOVLW      50
	SUBWF      servo_angle_direct_i_L0+0, 0
L__servo_angle_direct76:
	BTFSC      STATUS+0, 0
	GOTO       L_servo_angle_direct14
;AgriBot.c,126 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,127 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,130 :: 		CCPR1H = pulse >> 8;
	MOVF       servo_angle_direct_pulse_L0+1, 0
	MOVWF      R0+0
	MOVF       servo_angle_direct_pulse_L0+2, 0
	MOVWF      R0+1
	MOVF       servo_angle_direct_pulse_L0+3, 0
	MOVWF      R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AgriBot.c,131 :: 		CCPR1L = pulse;
	MOVF       servo_angle_direct_pulse_L0+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,134 :: 		PORTC |= 0x10;  // Set RC4 high
	BSF        PORTC+0, 4
;AgriBot.c,137 :: 		PIR1 &= ~0x04;  // Clear CCP1IF
	BCF        PIR1+0, 2
;AgriBot.c,138 :: 		while(!(PIR1 & 0x04));
L_servo_angle_direct16:
	BTFSC      PIR1+0, 2
	GOTO       L_servo_angle_direct17
	GOTO       L_servo_angle_direct16
L_servo_angle_direct17:
;AgriBot.c,141 :: 		PORTC &= ~0x10;  // Set RC4 low
	BCF        PORTC+0, 4
;AgriBot.c,144 :: 		CCPR1H = (40000 - pulse) >> 8;
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
;AgriBot.c,145 :: 		CCPR1L = (40000 - pulse);
	MOVF       R5+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,148 :: 		PIR1 &= ~0x04;  // Clear CCP1IF
	BCF        PIR1+0, 2
;AgriBot.c,149 :: 		while(!(PIR1 & 0x04));
L_servo_angle_direct18:
	BTFSC      PIR1+0, 2
	GOTO       L_servo_angle_direct19
	GOTO       L_servo_angle_direct18
L_servo_angle_direct19:
;AgriBot.c,124 :: 		for(i = 0; i < 50; i++) {
	INCF       servo_angle_direct_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       servo_angle_direct_i_L0+1, 1
;AgriBot.c,150 :: 		}
	GOTO       L_servo_angle_direct13
L_servo_angle_direct14:
;AgriBot.c,153 :: 		INTCON |= 0x80;  // Set GIE
	BSF        INTCON+0, 7
;AgriBot.c,154 :: 		}
L_end_servo_angle_direct:
	RETURN
; end of _servo_angle_direct

_trigger_pulse:

;AgriBot.c,157 :: 		void trigger_pulse(){
;AgriBot.c,158 :: 		PORTB |= TRIG_PIN;   // Set TRIG high
	BSF        PORTB+0, 0
;AgriBot.c,159 :: 		custom_delay_us(10); // 10us pulse
	MOVLW      10
	MOVWF      FARG_custom_delay_us_us+0
	MOVLW      0
	MOVWF      FARG_custom_delay_us_us+1
	CALL       _custom_delay_us+0
;AgriBot.c,160 :: 		PORTB &= ~TRIG_PIN;  // Set TRIG low
	BCF        PORTB+0, 0
;AgriBot.c,161 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,163 :: 		unsigned int measure_distance(){
;AgriBot.c,164 :: 		unsigned int time = 0;
;AgriBot.c,166 :: 		unsigned int timer0_overflow = 0;
	CLRF       measure_distance_timer0_overflow_L0+0
	CLRF       measure_distance_timer0_overflow_L0+1
;AgriBot.c,168 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,171 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,172 :: 		while (!(PORTB & ECHO_PIN)) {
L_measure_distance20:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance21
;AgriBot.c,173 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance79
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance79:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance22
;AgriBot.c,174 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,175 :: 		}
L_measure_distance22:
;AgriBot.c,176 :: 		}
	GOTO       L_measure_distance20
L_measure_distance21:
;AgriBot.c,179 :: 		TMR0 = 0;
	CLRF       TMR0+0
;AgriBot.c,180 :: 		timer0_overflow = 0;
	CLRF       measure_distance_timer0_overflow_L0+0
	CLRF       measure_distance_timer0_overflow_L0+1
;AgriBot.c,181 :: 		INTCON &= ~0x04;     // Clear T0IF
	BCF        INTCON+0, 2
;AgriBot.c,182 :: 		OPTION_REG = 0x80;   // Enable Timer0, internal clock, no prescaler
	MOVLW      128
	MOVWF      OPTION_REG+0
;AgriBot.c,185 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,186 :: 		while (PORTB & ECHO_PIN) {
L_measure_distance23:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance24
;AgriBot.c,188 :: 		if (INTCON & 0x04) {  // Check T0IF
	BTFSS      INTCON+0, 2
	GOTO       L_measure_distance25
;AgriBot.c,189 :: 		INTCON &= ~0x04;  // Clear T0IF
	BCF        INTCON+0, 2
;AgriBot.c,190 :: 		timer0_overflow++;
	INCF       measure_distance_timer0_overflow_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       measure_distance_timer0_overflow_L0+1, 1
;AgriBot.c,191 :: 		if (timer0_overflow > 200) {
	MOVF       measure_distance_timer0_overflow_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance80
	MOVF       measure_distance_timer0_overflow_L0+0, 0
	SUBLW      200
L__measure_distance80:
	BTFSC      STATUS+0, 0
	GOTO       L_measure_distance26
;AgriBot.c,192 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,193 :: 		}
L_measure_distance26:
;AgriBot.c,194 :: 		}
L_measure_distance25:
;AgriBot.c,195 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance81
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance81:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance27
;AgriBot.c,196 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,197 :: 		}
L_measure_distance27:
;AgriBot.c,198 :: 		}
	GOTO       L_measure_distance23
L_measure_distance24:
;AgriBot.c,201 :: 		time = (timer0_overflow * 256) + TMR0;
	MOVF       measure_distance_timer0_overflow_L0+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR0+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;AgriBot.c,204 :: 		return time / 145u;
	MOVLW      145
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,205 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_initCutter:

;AgriBot.c,208 :: 		void initCutter(void) {
;AgriBot.c,209 :: 		TRISB &= ~0x10;  // RB4 as output (clear bit 4)
	BCF        TRISB+0, 4
;AgriBot.c,210 :: 		PORTB &= ~0x10;  // RB4 low
	BCF        PORTB+0, 4
;AgriBot.c,211 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,213 :: 		void cutter_on(void)  { PORTB |= 0x10; }   // Set RB4 high
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,214 :: 		void cutter_off(void) { PORTB &= ~0x10; }  // Set RB4 low
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeed:

;AgriBot.c,217 :: 		void setSpeed(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeed_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeed:
	RETURN
; end of _setSpeed

_setupPWM:

;AgriBot.c,219 :: 		void setupPWM(void) {
;AgriBot.c,221 :: 		TRISC &= ~0x02;  // Clear bit 1 (RC1 output)
	BCF        TRISC+0, 1
;AgriBot.c,224 :: 		CCP2CON = 0x0C;  // CCP2 PWM mode
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,227 :: 		PR2 = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,228 :: 		T2CON = 0x05;           // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,230 :: 		setSpeed(128);          // 50% duty cycle
	MOVLW      128
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,231 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

;AgriBot.c,234 :: 		void motors_stop(void) {
;AgriBot.c,235 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,236 :: 		setSpeed(0);
	CLRF       FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,237 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,239 :: 		void motors_forward(unsigned char left_speed, unsigned char right_speed) {
;AgriBot.c,241 :: 		while (1) {
L_motors_forward28:
;AgriBot.c,242 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_motors_forward30
;AgriBot.c,243 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,244 :: 		break;  // break out to handle new command
	GOTO       L_motors_forward29
;AgriBot.c,245 :: 		}
L_motors_forward30:
;AgriBot.c,246 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,247 :: 		if (distance < 10u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motors_forward89
	MOVLW      10
	SUBWF      R0+0, 0
L__motors_forward89:
	BTFSC      STATUS+0, 0
	GOTO       L_motors_forward31
;AgriBot.c,248 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,249 :: 		} else {
	GOTO       L_motors_forward32
L_motors_forward31:
;AgriBot.c,250 :: 		PORTD = 0x5A;  // 0b01011010 forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,251 :: 		setSpeed(right_speed);
	MOVF       FARG_motors_forward_right_speed+0, 0
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,252 :: 		}
L_motors_forward32:
;AgriBot.c,253 :: 		}
	GOTO       L_motors_forward28
L_motors_forward29:
;AgriBot.c,254 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,256 :: 		void motors_backward(unsigned char left_speed, unsigned char right_speed) {
;AgriBot.c,257 :: 		PORTD = 0xA5;  // 0b10100101 Backward direction
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,258 :: 		setSpeed(right_speed);
	MOVF       FARG_motors_backward_right_speed+0, 0
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,259 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,261 :: 		void motors_left(void) {
;AgriBot.c,262 :: 		PORTD = 0x55;  // 0b01010101 turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,263 :: 		setSpeed(150);
	MOVLW      150
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,264 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,266 :: 		void motors_right(void) {
;AgriBot.c,267 :: 		PORTD = 0xAA;  // 0b10101010 turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,268 :: 		setSpeed(150);
	MOVLW      150
	MOVWF      FARG_setSpeed_duty+0
	CALL       _setSpeed+0
;AgriBot.c,269 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_init_io:

;AgriBot.c,272 :: 		void init_io(void) {
;AgriBot.c,273 :: 		TRISB &= ~0x40;  // RB6 output (clear bit 6)
	BCF        TRISB+0, 6
;AgriBot.c,274 :: 		PORTB |= 0x40;   // relay off (active low input)
	BSF        PORTB+0, 6
;AgriBot.c,275 :: 		}
L_end_init_io:
	RETURN
; end of _init_io

_relay_control:

;AgriBot.c,277 :: 		void relay_control(char state) {
;AgriBot.c,278 :: 		if(state) {
	MOVF       FARG_relay_control_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_relay_control33
;AgriBot.c,279 :: 		PORTB &= ~0x40;  // turn relay ON (active low)
	BCF        PORTB+0, 6
;AgriBot.c,280 :: 		} else {
	GOTO       L_relay_control34
L_relay_control33:
;AgriBot.c,281 :: 		PORTB |= 0x40;   // turn relay OFF
	BSF        PORTB+0, 6
;AgriBot.c,282 :: 		}
L_relay_control34:
;AgriBot.c,283 :: 		}
L_end_relay_control:
	RETURN
; end of _relay_control

_init_adc:

;AgriBot.c,286 :: 		void init_adc() {
;AgriBot.c,287 :: 		ADCON1 = 0x80;      // Right justified, all pins analog
	MOVLW      128
	MOVWF      ADCON1+0
;AgriBot.c,288 :: 		ADCON0 = 0x81;      // Channel 0 selected, ADC ON, Fosc/8
	MOVLW      129
	MOVWF      ADCON0+0
;AgriBot.c,289 :: 		custom_delay_us(50); // Allow ADC to stabilize
	MOVLW      50
	MOVWF      FARG_custom_delay_us_us+0
	MOVLW      0
	MOVWF      FARG_custom_delay_us_us+1
	CALL       _custom_delay_us+0
;AgriBot.c,290 :: 		}
L_end_init_adc:
	RETURN
; end of _init_adc

_read_adc:

;AgriBot.c,292 :: 		unsigned int read_adc(unsigned char channel) {
;AgriBot.c,294 :: 		ADCON0 &= 0xC7;              // Clear channel selection bits
	MOVLW      199
	ANDWF      ADCON0+0, 1
;AgriBot.c,295 :: 		ADCON0 |= (channel << 3);    // Set channel selection bits
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
;AgriBot.c,297 :: 		custom_delay_us(20);         // Acquisition time delay
	MOVLW      20
	MOVWF      FARG_custom_delay_us_us+0
	MOVLW      0
	MOVWF      FARG_custom_delay_us_us+1
	CALL       _custom_delay_us+0
;AgriBot.c,299 :: 		ADCON0 |= 0x04;              // Start conversion (set GO bit)
	BSF        ADCON0+0, 2
;AgriBot.c,300 :: 		while(ADCON0 & 0x04);        // Wait for conversion complete
L_read_adc35:
	BTFSS      ADCON0+0, 2
	GOTO       L_read_adc36
	GOTO       L_read_adc35
L_read_adc36:
;AgriBot.c,303 :: 		return ((unsigned int)ADRESH << 8) | ADRESL;
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
;AgriBot.c,304 :: 		}
L_end_read_adc:
	RETURN
; end of _read_adc

_read_soil_moisture:

;AgriBot.c,306 :: 		unsigned int read_soil_moisture() {
;AgriBot.c,307 :: 		return read_adc(0);
	CLRF       FARG_read_adc_channel+0
	CALL       _read_adc+0
;AgriBot.c,308 :: 		}
L_end_read_soil_moisture:
	RETURN
; end of _read_soil_moisture

_read_soil_moisture_safe:

;AgriBot.c,310 :: 		unsigned int read_soil_moisture_safe() {
;AgriBot.c,311 :: 		unsigned char old_gie = INTCON & 0x80;  // Save interrupt state
	MOVLW      128
	ANDWF      INTCON+0, 0
	MOVWF      read_soil_moisture_safe_old_gie_L0+0
;AgriBot.c,312 :: 		unsigned int result = read_adc(0);
	CLRF       FARG_read_adc_channel+0
	CALL       _read_adc+0
	MOVF       R0+0, 0
	MOVWF      read_soil_moisture_safe_result_L0+0
	MOVF       R0+1, 0
	MOVWF      read_soil_moisture_safe_result_L0+1
;AgriBot.c,313 :: 		INTCON &= ~0x80;  // Disable interrupts during ADC
	MOVLW      127
	ANDWF      INTCON+0, 1
;AgriBot.c,315 :: 		if(old_gie) INTCON |= 0x80;  // Restore interrupts if they were enabled
	MOVF       read_soil_moisture_safe_old_gie_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_soil_moisture_safe37
	BSF        INTCON+0, 7
L_read_soil_moisture_safe37:
;AgriBot.c,316 :: 		return result;
	MOVF       read_soil_moisture_safe_result_L0+0, 0
	MOVWF      R0+0
	MOVF       read_soil_moisture_safe_result_L0+1, 0
	MOVWF      R0+1
;AgriBot.c,317 :: 		}
L_end_read_soil_moisture_safe:
	RETURN
; end of _read_soil_moisture_safe

_relay_control_fixed:

;AgriBot.c,319 :: 		void relay_control_fixed(char state) {
;AgriBot.c,320 :: 		if(state) {
	MOVF       FARG_relay_control_fixed_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_relay_control_fixed38
;AgriBot.c,321 :: 		PORTB |= 0x40;   // Turn relay ON
	BSF        PORTB+0, 6
;AgriBot.c,322 :: 		} else {
	GOTO       L_relay_control_fixed39
L_relay_control_fixed38:
;AgriBot.c,323 :: 		PORTB &= ~0x40;  // Turn relay OFF
	BCF        PORTB+0, 6
;AgriBot.c,324 :: 		}
L_relay_control_fixed39:
;AgriBot.c,325 :: 		custom_delay_ms(10);  // Add delay for relay switching
	MOVLW      10
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,326 :: 		}
L_end_relay_control_fixed:
	RETURN
; end of _relay_control_fixed

_setup:

;AgriBot.c,329 :: 		void setup() {
;AgriBot.c,331 :: 		TRISA = 0xFF;   // Port A as input
	MOVLW      255
	MOVWF      TRISA+0
;AgriBot.c,332 :: 		TRISB = 0x02;   // RB1 as input (echo), others as output
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,333 :: 		TRISC = 0x40;   // RC6 (TX) as input for USART, others as output
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,334 :: 		TRISD = 0x00;   // Port D as output
	CLRF       TRISD+0
;AgriBot.c,335 :: 		TRISE = 0x07;   // RE0-RE2 as input
	MOVLW      7
	MOVWF      TRISE+0
;AgriBot.c,338 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;AgriBot.c,339 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;AgriBot.c,340 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;AgriBot.c,341 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,344 :: 		TRISB &= ~0x40;  // RB6 as output
	BCF        TRISB+0, 6
;AgriBot.c,345 :: 		PORTB &= ~0x40;  // RB6 low
	BCF        PORTB+0, 6
;AgriBot.c,348 :: 		init_io();
	CALL       _init_io+0
;AgriBot.c,351 :: 		custom_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,352 :: 		}
L_end_setup:
	RETURN
; end of _setup

_bluetooth_init:

;AgriBot.c,354 :: 		void bluetooth_init() {
;AgriBot.c,355 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;AgriBot.c,356 :: 		custom_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,357 :: 		}
L_end_bluetooth_init:
	RETURN
; end of _bluetooth_init

_main:

;AgriBot.c,360 :: 		void main(void) {
;AgriBot.c,364 :: 		setup();
	CALL       _setup+0
;AgriBot.c,365 :: 		bluetooth_init();
	CALL       _bluetooth_init+0
;AgriBot.c,366 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,367 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,368 :: 		init_ccp_servo();
	CALL       _init_ccp_servo+0
;AgriBot.c,369 :: 		init_adc();
	CALL       _init_adc+0
;AgriBot.c,371 :: 		blink_counter = 0;
	CLRF       _blink_counter+0
	CLRF       _blink_counter+1
;AgriBot.c,372 :: 		custom_delay_us(100);
	MOVLW      100
	MOVWF      FARG_custom_delay_us_us+0
	MOVLW      0
	MOVWF      FARG_custom_delay_us_us+1
	CALL       _custom_delay_us+0
;AgriBot.c,374 :: 		while (1) {
L_main40:
;AgriBot.c,375 :: 		servo_set_angle(0);
	CLRF       FARG_servo_set_angle_angle+0
	CLRF       FARG_servo_set_angle_angle+1
	CALL       _servo_set_angle+0
;AgriBot.c,376 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main42
;AgriBot.c,377 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,378 :: 		switch(command) {
	GOTO       L_main43
;AgriBot.c,379 :: 		case 'F':
L_main45:
;AgriBot.c,380 :: 		motors_forward(150, 150);
	MOVLW      150
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,381 :: 		break;
	GOTO       L_main44
;AgriBot.c,383 :: 		case 'B':
L_main46:
;AgriBot.c,384 :: 		motors_backward(100, 100);
	MOVLW      100
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,385 :: 		break;
	GOTO       L_main44
;AgriBot.c,387 :: 		case 'R':
L_main47:
;AgriBot.c,388 :: 		motors_right();
	CALL       _motors_right+0
;AgriBot.c,389 :: 		break;
	GOTO       L_main44
;AgriBot.c,391 :: 		case 'L':
L_main48:
;AgriBot.c,392 :: 		motors_left();
	CALL       _motors_left+0
;AgriBot.c,393 :: 		break;
	GOTO       L_main44
;AgriBot.c,395 :: 		case 'S':
L_main49:
;AgriBot.c,396 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,397 :: 		break;
	GOTO       L_main44
;AgriBot.c,399 :: 		case 'G':   // Forward left
L_main50:
;AgriBot.c,400 :: 		motors_forward(100, 150);
	MOVLW      100
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,401 :: 		break;
	GOTO       L_main44
;AgriBot.c,403 :: 		case 'H':   // Forward right
L_main51:
;AgriBot.c,404 :: 		motors_forward(150, 100);
	MOVLW      150
	MOVWF      FARG_motors_forward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_forward_right_speed+0
	CALL       _motors_forward+0
;AgriBot.c,405 :: 		break;
	GOTO       L_main44
;AgriBot.c,407 :: 		case 'I':   // Backward left
L_main52:
;AgriBot.c,408 :: 		motors_backward(100, 150);
	MOVLW      100
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      150
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,409 :: 		break;
	GOTO       L_main44
;AgriBot.c,411 :: 		case 'J':   // Backward right
L_main53:
;AgriBot.c,412 :: 		motors_backward(150, 100);
	MOVLW      150
	MOVWF      FARG_motors_backward_left_speed+0
	MOVLW      100
	MOVWF      FARG_motors_backward_right_speed+0
	CALL       _motors_backward+0
;AgriBot.c,413 :: 		break;
	GOTO       L_main44
;AgriBot.c,415 :: 		case 'X':   // Turn cutter ON
L_main54:
;AgriBot.c,416 :: 		cutter_on();
	CALL       _cutter_on+0
;AgriBot.c,417 :: 		break;
	GOTO       L_main44
;AgriBot.c,419 :: 		case 'x':   // Turn cutter OFF
L_main55:
;AgriBot.c,420 :: 		cutter_off();
	CALL       _cutter_off+0
;AgriBot.c,421 :: 		break;
	GOTO       L_main44
;AgriBot.c,423 :: 		case 'Y':
L_main56:
;AgriBot.c,425 :: 		PORTB &= ~0x08; custom_delay_ms(200); // RB3 low
	BCF        PORTB+0, 3
	MOVLW      200
	MOVWF      FARG_custom_delay_ms_ms+0
	CLRF       FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,426 :: 		PORTB |= 0x08; custom_delay_ms(200);  // RB3 high
	BSF        PORTB+0, 3
	MOVLW      200
	MOVWF      FARG_custom_delay_ms_ms+0
	CLRF       FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,429 :: 		servo_set_angle(180);
	MOVLW      180
	MOVWF      FARG_servo_set_angle_angle+0
	CLRF       FARG_servo_set_angle_angle+1
	CALL       _servo_set_angle+0
;AgriBot.c,430 :: 		custom_delay_ms(2000);
	MOVLW      208
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      7
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,433 :: 		custom_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,434 :: 		moisture_value = read_soil_moisture_safe();
	CALL       _read_soil_moisture_safe+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _moisture_value+0
	MOVF       FLOC__main+1, 0
	MOVWF      _moisture_value+1
;AgriBot.c,435 :: 		moisture_percentage = (moisture_value * 100) / 1023;
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
;AgriBot.c,438 :: 		PIE1 &= ~0x04;  // Disable CCP1IE
	BCF        PIE1+0, 2
;AgriBot.c,439 :: 		PORTC &= ~0x10; // Stop servo signal (RC4 low)
	BCF        PORTC+0, 4
;AgriBot.c,442 :: 		if(moisture_value > 500) {
	MOVF       FLOC__main+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVF       FLOC__main+0, 0
	SUBLW      244
L__main103:
	BTFSC      STATUS+0, 0
	GOTO       L_main57
;AgriBot.c,444 :: 		PORTB |= 0x40;  // RB6 high
	BSF        PORTB+0, 6
;AgriBot.c,445 :: 		custom_delay_ms(500);  // Run pump
	MOVLW      244
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,446 :: 		PORTB &= ~0x40; // Turn off pump
	BCF        PORTB+0, 6
;AgriBot.c,447 :: 		} else {
	GOTO       L_main58
L_main57:
;AgriBot.c,449 :: 		PORTB &= ~0x40; // RB6 low
	BCF        PORTB+0, 6
;AgriBot.c,450 :: 		}
L_main58:
;AgriBot.c,453 :: 		PIE1 |= 0x04;  // Re-enable CCP1IE
	BSF        PIE1+0, 2
;AgriBot.c,456 :: 		for(angle = 0; angle <= 360; angle += 10) {
	CLRF       main_angle_L0+0
	CLRF       main_angle_L0+1
L_main59:
	MOVF       main_angle_L0+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main104
	MOVF       main_angle_L0+0, 0
	SUBLW      104
L__main104:
	BTFSS      STATUS+0, 0
	GOTO       L_main60
;AgriBot.c,457 :: 		servo_angle_direct(angle);
	MOVF       main_angle_L0+0, 0
	MOVWF      FARG_servo_angle_direct_angle+0
	MOVF       main_angle_L0+1, 0
	MOVWF      FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,458 :: 		custom_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,456 :: 		for(angle = 0; angle <= 360; angle += 10) {
	MOVLW      10
	ADDWF      main_angle_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       main_angle_L0+1, 1
;AgriBot.c,459 :: 		}
	GOTO       L_main59
L_main60:
;AgriBot.c,461 :: 		for(angle = 0; angle <= 180; angle += 10) {
	CLRF       main_angle_L0+0
	CLRF       main_angle_L0+1
L_main62:
	MOVF       main_angle_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main105
	MOVF       main_angle_L0+0, 0
	SUBLW      180
L__main105:
	BTFSS      STATUS+0, 0
	GOTO       L_main63
;AgriBot.c,462 :: 		servo_angle_direct(angle);
	MOVF       main_angle_L0+0, 0
	MOVWF      FARG_servo_angle_direct_angle+0
	MOVF       main_angle_L0+1, 0
	MOVWF      FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,463 :: 		custom_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,461 :: 		for(angle = 0; angle <= 180; angle += 10) {
	MOVLW      10
	ADDWF      main_angle_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       main_angle_L0+1, 1
;AgriBot.c,464 :: 		}
	GOTO       L_main62
L_main63:
;AgriBot.c,466 :: 		custom_delay_ms(1000);
	MOVLW      232
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      3
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,469 :: 		servo_angle_direct(0);
	CLRF       FARG_servo_angle_direct_angle+0
	CLRF       FARG_servo_angle_direct_angle+1
	CALL       _servo_angle_direct+0
;AgriBot.c,470 :: 		custom_delay_ms(2000);
	MOVLW      208
	MOVWF      FARG_custom_delay_ms_ms+0
	MOVLW      7
	MOVWF      FARG_custom_delay_ms_ms+1
	CALL       _custom_delay_ms+0
;AgriBot.c,472 :: 		break;
	GOTO       L_main44
;AgriBot.c,473 :: 		}
L_main43:
	MOVF       _command+0, 0
	XORLW      70
	BTFSC      STATUS+0, 2
	GOTO       L_main45
	MOVF       _command+0, 0
	XORLW      66
	BTFSC      STATUS+0, 2
	GOTO       L_main46
	MOVF       _command+0, 0
	XORLW      82
	BTFSC      STATUS+0, 2
	GOTO       L_main47
	MOVF       _command+0, 0
	XORLW      76
	BTFSC      STATUS+0, 2
	GOTO       L_main48
	MOVF       _command+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_main49
	MOVF       _command+0, 0
	XORLW      71
	BTFSC      STATUS+0, 2
	GOTO       L_main50
	MOVF       _command+0, 0
	XORLW      72
	BTFSC      STATUS+0, 2
	GOTO       L_main51
	MOVF       _command+0, 0
	XORLW      73
	BTFSC      STATUS+0, 2
	GOTO       L_main52
	MOVF       _command+0, 0
	XORLW      74
	BTFSC      STATUS+0, 2
	GOTO       L_main53
	MOVF       _command+0, 0
	XORLW      88
	BTFSC      STATUS+0, 2
	GOTO       L_main54
	MOVF       _command+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_main55
	MOVF       _command+0, 0
	XORLW      89
	BTFSC      STATUS+0, 2
	GOTO       L_main56
L_main44:
;AgriBot.c,474 :: 		}
L_main42:
;AgriBot.c,475 :: 		}
	GOTO       L_main40
;AgriBot.c,476 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
