
_setSpeedLeft:

;AgriBot.c,13 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

;AgriBot.c,14 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setupPWM:

;AgriBot.c,17 :: 		void setupPWM(void)
;AgriBot.c,20 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,21 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,24 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,25 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,28 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,29 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,31 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,32 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,33 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_init_ultrasonic:

;AgriBot.c,36 :: 		void init_ultrasonic(void)
;AgriBot.c,38 :: 		TRISB.F0 = 0;   // TRIG as output
	BCF        TRISB+0, 0
;AgriBot.c,39 :: 		TRISB.F1 = 1;   // ECHO as input
	BSF        TRISB+0, 1
;AgriBot.c,40 :: 		}
L_end_init_ultrasonic:
	RETURN
; end of _init_ultrasonic

_trigger_ultrasonic:

;AgriBot.c,42 :: 		void trigger_ultrasonic(void)
;AgriBot.c,44 :: 		TRIG = 0;
	BCF        PORTB+0, 0
;AgriBot.c,45 :: 		Delay_us(2);
	NOP
	NOP
	NOP
	NOP
;AgriBot.c,47 :: 		TRIG = 1;
	BSF        PORTB+0, 0
;AgriBot.c,48 :: 		Delay_us(10);            // 10 µs HIGH pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_ultrasonic0:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_ultrasonic0
	NOP
;AgriBot.c,50 :: 		TRIG = 0;
	BCF        PORTB+0, 0
;AgriBot.c,51 :: 		}
L_end_trigger_ultrasonic:
	RETURN
; end of _trigger_ultrasonic

_read_distance_cm:

;AgriBot.c,53 :: 		unsigned int read_distance_cm(void)
;AgriBot.c,57 :: 		trigger_ultrasonic();
	CALL       _trigger_ultrasonic+0
;AgriBot.c,60 :: 		while (!ECHO);
L_read_distance_cm1:
	BTFSC      PORTB+0, 1
	GOTO       L_read_distance_cm2
	GOTO       L_read_distance_cm1
L_read_distance_cm2:
;AgriBot.c,62 :: 		TMR1H = 0;                 // clear 16-bit timer
	CLRF       TMR1H+0
;AgriBot.c,63 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,64 :: 		T1CON = 0x01;              // Timer-1 on, prescaler 1
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,66 :: 		while (ECHO);              // stay here while echo HIGH
L_read_distance_cm3:
	BTFSS      PORTB+0, 1
	GOTO       L_read_distance_cm4
	GOTO       L_read_distance_cm3
L_read_distance_cm4:
;AgriBot.c,68 :: 		T1CON = 0x00;              // stop timer
	CLRF       T1CON+0
;AgriBot.c,69 :: 		ticks = ((unsigned int)TMR1H << 8) | TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,73 :: 		return ticks / 290;        // ≈ distance in cm
	MOVLW      34
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,74 :: 		}
L_end_read_distance_cm:
	RETURN
; end of _read_distance_cm

_motors_stop:

;AgriBot.c,77 :: 		void motors_stop(void)
;AgriBot.c,79 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,80 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,81 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,82 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,84 :: 		void motors_forward(void)
;AgriBot.c,86 :: 		PORTD = 0b01011010;            // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,87 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,88 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,89 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,91 :: 		void motors_backward(void)
;AgriBot.c,93 :: 		PORTD = 0b10100101;            // backward
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,94 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,95 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,96 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,98 :: 		void motors_left(void)
;AgriBot.c,100 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,101 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,102 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,103 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,105 :: 		void motors_right(void)
;AgriBot.c,107 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,108 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,109 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,110 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_main:

;AgriBot.c,113 :: 		void main(void)
;AgriBot.c,115 :: 		TRISD = 0x00;    // PORTD as output for IN1-IN4
	CLRF       TRISD+0
;AgriBot.c,116 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,118 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,119 :: 		init_ultrasonic();
	CALL       _init_ultrasonic+0
;AgriBot.c,121 :: 		while (1)
L_main5:
;AgriBot.c,123 :: 		motors_forward();
	CALL       _motors_forward+0
;AgriBot.c,124 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
;AgriBot.c,125 :: 		if (read_distance_cm() < 20) motors_stop();
	CALL       _read_distance_cm+0
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVLW      20
	SUBWF      R0+0, 0
L__main21:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
	CALL       _motors_stop+0
L_main8:
;AgriBot.c,138 :: 		}
	GOTO       L_main5
;AgriBot.c,139 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
