
_our_delay_ms:

;AgriBot.c,14 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,16 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms0:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms14
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms14:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms1
;AgriBot.c,17 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms3:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms15
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms15:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms4
	NOP
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_our_delay_ms3
L_our_delay_ms4:
;AgriBot.c,16 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,18 :: 		}
	GOTO       L_our_delay_ms0
L_our_delay_ms1:
;AgriBot.c,19 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

_initCutter:

;AgriBot.c,25 :: 		void initCutter(void) {
;AgriBot.c,26 :: 		TRISB.F4 = 0;
	BCF        TRISB+0, 4
;AgriBot.c,27 :: 		PORTB.F4    = 0;
	BCF        PORTB+0, 4
;AgriBot.c,28 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,30 :: 		void cutter_on(void)  { PORTB.F4 = 1; }
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,31 :: 		void cutter_off(void) { PORTB.F4 = 0; }
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeedLeft:

;AgriBot.c,34 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

;AgriBot.c,35 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setupPWM:

;AgriBot.c,38 :: 		void setupPWM(void)
;AgriBot.c,41 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,42 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,45 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,46 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,49 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,50 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,52 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,53 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,54 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

;AgriBot.c,57 :: 		void motors_stop(void)
;AgriBot.c,59 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,60 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,61 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,62 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,64 :: 		void motors_forward(void)
;AgriBot.c,66 :: 		PORTD = 0b01011010;            // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,67 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,68 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,69 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,71 :: 		void motors_backward(void)
;AgriBot.c,73 :: 		PORTD = 0b10100101;            // backward
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,74 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,75 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,76 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,78 :: 		void motors_left(void)
;AgriBot.c,80 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,81 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,82 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,83 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,85 :: 		void motors_right(void)
;AgriBot.c,87 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,88 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,89 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,90 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_trigger_pulse:

;AgriBot.c,94 :: 		void trigger_pulse(){
;AgriBot.c,95 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 0
;AgriBot.c,96 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse6:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse6
	NOP
;AgriBot.c,97 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 0
;AgriBot.c,98 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,100 :: 		unsigned int measure_distance(){
;AgriBot.c,101 :: 		unsigned int time = 0;
;AgriBot.c,104 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,107 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,108 :: 		while (!(PORTB & 0x02)) {
L_measure_distance7:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance8
;AgriBot.c,109 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance29
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance29:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance9
;AgriBot.c,110 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,111 :: 		}
L_measure_distance9:
;AgriBot.c,112 :: 		}
	GOTO       L_measure_distance7
L_measure_distance8:
;AgriBot.c,115 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,116 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,117 :: 		T1CON = 0x01;  // Enable Timer1 with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,120 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,121 :: 		while (PORTB & 0x02) {
L_measure_distance10:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance11
;AgriBot.c,122 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance30
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance30:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance12
;AgriBot.c,123 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,124 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,125 :: 		}
L_measure_distance12:
;AgriBot.c,126 :: 		}
	GOTO       L_measure_distance10
L_measure_distance11:
;AgriBot.c,129 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,130 :: 		time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,133 :: 		return time / 116u;
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,134 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_setup:

;AgriBot.c,137 :: 		void setup(){
;AgriBot.c,146 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,147 :: 		TRISC = 0x40;
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,148 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;AgriBot.c,150 :: 		PORTB = 0x00;  // Initialize PORTB
	CLRF       PORTB+0
;AgriBot.c,151 :: 		PORTC = 0x00;  // Initialize PORTC
	CLRF       PORTC+0
;AgriBot.c,152 :: 		PORTD = 0x00;  // Initialize PORTD
	CLRF       PORTD+0
;AgriBot.c,158 :: 		our_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,159 :: 		}
L_end_setup:
	RETURN
; end of _setup

_main:

;AgriBot.c,162 :: 		void main(void)
;AgriBot.c,168 :: 		setup();
	CALL       _setup+0
;AgriBot.c,169 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,170 :: 		cutter_on();
	CALL       _cutter_on+0
;AgriBot.c,196 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
