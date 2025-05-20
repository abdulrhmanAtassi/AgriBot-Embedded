
_our_delay_ms:

;AgriBot.c,18 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,20 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms0:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms23
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms23:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms1
;AgriBot.c,21 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms3:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms24
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms24:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms4
	NOP
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_our_delay_ms3
L_our_delay_ms4:
;AgriBot.c,20 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,22 :: 		}
	GOTO       L_our_delay_ms0
L_our_delay_ms1:
;AgriBot.c,23 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

_trigger_pulse:

;AgriBot.c,27 :: 		void trigger_pulse(){
;AgriBot.c,28 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 0
;AgriBot.c,29 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse6:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse6
	NOP
;AgriBot.c,30 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 0
;AgriBot.c,31 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,33 :: 		unsigned int measure_distance(){
;AgriBot.c,34 :: 		unsigned int time = 0;
;AgriBot.c,37 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,40 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,41 :: 		while (!(PORTB & 0x02)) {
L_measure_distance7:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance8
;AgriBot.c,42 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance27
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance27:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance9
;AgriBot.c,43 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,44 :: 		}
L_measure_distance9:
;AgriBot.c,45 :: 		}
	GOTO       L_measure_distance7
L_measure_distance8:
;AgriBot.c,48 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,49 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,50 :: 		T1CON = 0x01;  // Enable Timer1 with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,53 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,54 :: 		while (PORTB & 0x02) {
L_measure_distance10:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance11
;AgriBot.c,55 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance28
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance28:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance12
;AgriBot.c,56 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,57 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,58 :: 		}
L_measure_distance12:
;AgriBot.c,59 :: 		}
	GOTO       L_measure_distance10
L_measure_distance11:
;AgriBot.c,62 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,63 :: 		time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,66 :: 		return time / 116u;
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,67 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_initCutter:

;AgriBot.c,71 :: 		void initCutter(void) {
;AgriBot.c,72 :: 		TRISB.F4 = 0;
	BCF        TRISB+0, 4
;AgriBot.c,73 :: 		PORTB.F4    = 0;
	BCF        PORTB+0, 4
;AgriBot.c,74 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,76 :: 		void cutter_on(void)  { PORTB.F4 = 1; }
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,77 :: 		void cutter_off(void) { PORTB.F4 = 0; }
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeedLeft:

;AgriBot.c,81 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

;AgriBot.c,82 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setupPWM:

;AgriBot.c,84 :: 		void setupPWM(void)
;AgriBot.c,87 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,88 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,91 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,92 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,95 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,96 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,98 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,99 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,100 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

;AgriBot.c,104 :: 		void motors_stop(void)
;AgriBot.c,106 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,107 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,108 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,109 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,111 :: 		void motors_forward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,114 :: 		while (1) {
L_motors_forward13:
;AgriBot.c,115 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_motors_forward15
;AgriBot.c,116 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,117 :: 		break;  // break out to handle new command
	GOTO       L_motors_forward14
;AgriBot.c,118 :: 		}
L_motors_forward15:
;AgriBot.c,119 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,120 :: 		if (distance < 20u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motors_forward37
	MOVLW      20
	SUBWF      R0+0, 0
L__motors_forward37:
	BTFSC      STATUS+0, 0
	GOTO       L_motors_forward16
;AgriBot.c,121 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,122 :: 		} else {
	GOTO       L_motors_forward17
L_motors_forward16:
;AgriBot.c,123 :: 		PORTD = 0b01011010;  // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,124 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_forward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,125 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_forward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,126 :: 		}
L_motors_forward17:
;AgriBot.c,127 :: 		}
	GOTO       L_motors_forward13
L_motors_forward14:
;AgriBot.c,128 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,130 :: 		void motors_backward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,132 :: 		PORTD = 0b10100101;  // Backward direction
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,133 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_backward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,134 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_backward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,135 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,137 :: 		void motors_left(void)
;AgriBot.c,139 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,140 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,141 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,142 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,144 :: 		void motors_right(void)
;AgriBot.c,146 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,147 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,148 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,149 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_setup:

;AgriBot.c,153 :: 		void setup(){
;AgriBot.c,154 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,155 :: 		TRISC = 0x40;
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,156 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;AgriBot.c,157 :: 		PORTB = 0x00;  // Initialize PORTB
	CLRF       PORTB+0
;AgriBot.c,158 :: 		PORTC = 0x00;  // Initialize PORTC
	CLRF       PORTC+0
;AgriBot.c,159 :: 		PORTD = 0x00;  // Initialize PORTD
	CLRF       PORTD+0
;AgriBot.c,160 :: 		our_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,170 :: 		}
L_end_setup:
	RETURN
; end of _setup

_bluetooth_init:

;AgriBot.c,172 :: 		void bluetooth_init() {
;AgriBot.c,173 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;AgriBot.c,174 :: 		our_delay_ms(100);   // Initialize UART with 9600 baud rate
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,175 :: 		}
L_end_bluetooth_init:
	RETURN
; end of _bluetooth_init

_main:

;AgriBot.c,179 :: 		void main(void)
;AgriBot.c,182 :: 		setup();
	CALL       _setup+0
;AgriBot.c,183 :: 		bluetooth_init();
	CALL       _bluetooth_init+0
;AgriBot.c,184 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,185 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,190 :: 		TRISB.F3 = 0;
	BCF        TRISB+0, 3
;AgriBot.c,191 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,193 :: 		while (1)
L_main18:
;AgriBot.c,248 :: 		PORTB.F3 = 1;
	BSF        PORTB+0, 3
;AgriBot.c,249 :: 		Delay_us(15000);    // 90° position
	MOVLW      39
	MOVWF      R12+0
	MOVLW      245
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
;AgriBot.c,250 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,251 :: 		Delay_ms(20);      // Total frame = 20ms
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	NOP
	NOP
;AgriBot.c,253 :: 		}
	GOTO       L_main18
;AgriBot.c,255 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
