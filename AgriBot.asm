
_our_delay_ms:

;AgriBot.c,1 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,3 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms0:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms7
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms7:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms1
;AgriBot.c,4 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms3:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms8
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms8:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms4
	NOP
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_our_delay_ms3
L_our_delay_ms4:
;AgriBot.c,3 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,5 :: 		}
	GOTO       L_our_delay_ms0
L_our_delay_ms1:
;AgriBot.c,6 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

_setupPWM:

;AgriBot.c,8 :: 		void setupPWM() {
;AgriBot.c,10 :: 		TRISC &= 0b11110001;
	MOVLW      241
	ANDWF      TRISC+0, 1
;AgriBot.c,14 :: 		CCP1CON = 0b00001100;  // PWM mode
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,15 :: 		CCP2CON = 0b00001100;  // PWM mode
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,18 :: 		PR2 = 249;
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,19 :: 		T2CON = 0b00000101; // Prescaler = 4, Timer2 ON
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,22 :: 		CCPR1L = 128; // Left motors
	MOVLW      128
	MOVWF      CCPR1L+0
;AgriBot.c,23 :: 		CCPR2L = 128; // Right motors
	MOVLW      128
	MOVWF      CCPR2L+0
;AgriBot.c,24 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_setSpeedLeft:

;AgriBot.c,26 :: 		void setSpeedLeft(unsigned int duty){
;AgriBot.c,27 :: 		CCPR1L = duty;
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
;AgriBot.c,28 :: 		}
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

;AgriBot.c,30 :: 		void setSpeedRight(unsigned int duty){
;AgriBot.c,31 :: 		CCPR2L = duty;
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
;AgriBot.c,32 :: 		}
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setup:

;AgriBot.c,34 :: 		void setup(){
;AgriBot.c,35 :: 		TRISD = 0x00; // Set PORTD as output
	CLRF       TRISD+0
;AgriBot.c,36 :: 		PORTD = 0x00; // All moters off initally
	CLRF       PORTD+0
;AgriBot.c,37 :: 		}
L_end_setup:
	RETURN
; end of _setup

_stop:

;AgriBot.c,39 :: 		void stop() {
;AgriBot.c,40 :: 		PORTD = 0b00000000;
	CLRF       PORTD+0
;AgriBot.c,41 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CLRF       FARG_setSpeedLeft_duty+1
	CALL       _setSpeedLeft+0
;AgriBot.c,42 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CLRF       FARG_setSpeedRight_duty+1
	CALL       _setSpeedRight+0
;AgriBot.c,43 :: 		}
L_end_stop:
	RETURN
; end of _stop

_left:

;AgriBot.c,44 :: 		void left(){
;AgriBot.c,45 :: 		PORTD = 0b01010101;
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,46 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CLRF       FARG_setSpeedLeft_duty+1
	CALL       _setSpeedLeft+0
;AgriBot.c,47 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CLRF       FARG_setSpeedRight_duty+1
	CALL       _setSpeedRight+0
;AgriBot.c,48 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,49 :: 		}
L_end_left:
	RETURN
; end of _left

_right:

;AgriBot.c,51 :: 		void right(){
;AgriBot.c,52 :: 		PORTD = 0b10101010;
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,53 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CLRF       FARG_setSpeedLeft_duty+1
	CALL       _setSpeedLeft+0
;AgriBot.c,54 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CLRF       FARG_setSpeedRight_duty+1
	CALL       _setSpeedRight+0
;AgriBot.c,55 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,56 :: 		}
L_end_right:
	RETURN
; end of _right

_forward:

;AgriBot.c,58 :: 		void forward(){
;AgriBot.c,59 :: 		PORTD = 0b01011010;
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,60 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CLRF       FARG_setSpeedLeft_duty+1
	CALL       _setSpeedLeft+0
;AgriBot.c,61 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CLRF       FARG_setSpeedRight_duty+1
	CALL       _setSpeedRight+0
;AgriBot.c,62 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,63 :: 		}
L_end_forward:
	RETURN
; end of _forward

_backward:

;AgriBot.c,65 :: 		void backward(){
;AgriBot.c,66 :: 		PORTD = 0b10100101;
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,67 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CLRF       FARG_setSpeedLeft_duty+1
	CALL       _setSpeedLeft+0
;AgriBot.c,68 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CLRF       FARG_setSpeedRight_duty+1
	CALL       _setSpeedRight+0
;AgriBot.c,69 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,70 :: 		}
L_end_backward:
	RETURN
; end of _backward

_main:

;AgriBot.c,71 :: 		void main() {
;AgriBot.c,72 :: 		setup();
	CALL       _setup+0
;AgriBot.c,73 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,74 :: 		left();
	CALL       _left+0
;AgriBot.c,75 :: 		forward();
	CALL       _forward+0
;AgriBot.c,76 :: 		right();
	CALL       _right+0
;AgriBot.c,77 :: 		backward();
	CALL       _backward+0
;AgriBot.c,78 :: 		stop();
	CALL       _stop+0
;AgriBot.c,79 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
