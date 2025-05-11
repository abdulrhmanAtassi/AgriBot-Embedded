
_our_delay_ms:

;AgriBot.c,2 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,4 :: 		for (i = 0; i < ms; i++) {
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
;AgriBot.c,5 :: 		for (j = 0; j < 111; j++) NOP();
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
;AgriBot.c,4 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,6 :: 		}
	GOTO       L_our_delay_ms0
L_our_delay_ms1:
;AgriBot.c,7 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

_setup:

;AgriBot.c,9 :: 		void setup(){
;AgriBot.c,10 :: 		TRISD = 0x00; // Set PORTD as output
	CLRF       TRISD+0
;AgriBot.c,11 :: 		PORTD = 0x00; // All moters off initally
	CLRF       PORTD+0
;AgriBot.c,12 :: 		}
L_end_setup:
	RETURN
; end of _setup

_stop:

;AgriBot.c,14 :: 		void stop() {
;AgriBot.c,15 :: 		PORTD = 0b00000000;
	CLRF       PORTD+0
;AgriBot.c,16 :: 		}
L_end_stop:
	RETURN
; end of _stop

_left:

;AgriBot.c,17 :: 		void left(){
;AgriBot.c,18 :: 		PORTD = 0b01010101;
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,19 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,20 :: 		}
L_end_left:
	RETURN
; end of _left

_right:

;AgriBot.c,22 :: 		void right(){
;AgriBot.c,23 :: 		PORTD = 0b10101010;
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,24 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,25 :: 		}
L_end_right:
	RETURN
; end of _right

_forward:

;AgriBot.c,27 :: 		void forward(){
;AgriBot.c,28 :: 		PORTD = 0b01011010;
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,29 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,30 :: 		}
L_end_forward:
	RETURN
; end of _forward

_backward:

;AgriBot.c,32 :: 		void backward(){
;AgriBot.c,33 :: 		PORTD = 0b10100101;
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,34 :: 		our_delay_ms(500);
	MOVLW      244
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      1
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,35 :: 		}
L_end_backward:
	RETURN
; end of _backward

_main:

;AgriBot.c,36 :: 		void main() {
;AgriBot.c,37 :: 		setup();
	CALL       _setup+0
;AgriBot.c,39 :: 		forward();
	CALL       _forward+0
;AgriBot.c,41 :: 		backward();
	CALL       _backward+0
;AgriBot.c,42 :: 		stop();
	CALL       _stop+0
;AgriBot.c,43 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
