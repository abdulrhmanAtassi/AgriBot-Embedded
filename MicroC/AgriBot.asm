
_our_delay_ms:

;AgriBot.c,13 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,15 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms0:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
<<<<<<< Updated upstream
	GOTO       L__our_delay_ms20
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms20:
=======
	GOTO       L__our_delay_ms28
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms28:
>>>>>>> Stashed changes
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms1
;AgriBot.c,16 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms3:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
<<<<<<< Updated upstream
	GOTO       L__our_delay_ms21
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms21:
=======
	GOTO       L__our_delay_ms29
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms29:
>>>>>>> Stashed changes
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms4
	NOP
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_our_delay_ms3
L_our_delay_ms4:
;AgriBot.c,15 :: 		for (i = 0; i < ms; i++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;AgriBot.c,17 :: 		}
	GOTO       L_our_delay_ms0
L_our_delay_ms1:
;AgriBot.c,18 :: 		}
L_end_our_delay_ms:
	RETURN
; end of _our_delay_ms

<<<<<<< Updated upstream
_setSpeedLeft:

;AgriBot.c,24 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
=======
_Timer1_Init:

;AgriBot.c,28 :: 		void Timer1_Init()
;AgriBot.c,30 :: 		T1CON = 0b00000001;   // Timer1 ON, Prescaler 1:1
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,31 :: 		TMR1H = 0x0B;         // Preload for 20ms overflow at 20MHz
	MOVLW      11
	MOVWF      TMR1H+0
;AgriBot.c,32 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;AgriBot.c,33 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,34 :: 		TMR1IE_bit = 1;       // Enable Timer1 interrupt
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;AgriBot.c,35 :: 		PEIE_bit = 1;         // Enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;AgriBot.c,36 :: 		GIE_bit = 1;          // Enable global interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;AgriBot.c,37 :: 		}
L_end_Timer1_Init:
	RETURN
; end of _Timer1_Init

_Timer2_Init:

;AgriBot.c,40 :: 		void Timer2_Init()
;AgriBot.c,42 :: 		T2CON = 0b00000111;   // Prescaler 1:16, Timer2 ON when needed
	MOVLW      7
	MOVWF      T2CON+0
;AgriBot.c,43 :: 		PR2 = 249;            // Will be set dynamically
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,44 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,45 :: 		TMR2IE_bit = 1;       // Enable Timer2 interrupt
	BSF        TMR2IE_bit+0, BitPos(TMR2IE_bit+0)
;AgriBot.c,46 :: 		}
L_end_Timer2_Init:
	RETURN
; end of _Timer2_Init

_Set_Servo_Angle:

;AgriBot.c,49 :: 		void Set_Servo_Angle(unsigned char angle)
;AgriBot.c,52 :: 		servo_pulse_us = ((angle * 10) / 9) + 1000;
	MOVF       FARG_Set_Servo_Angle_angle+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVLW      232
	ADDWF      R0+0, 0
	MOVWF      _servo_pulse_us+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      3
	MOVWF      _servo_pulse_us+1
;AgriBot.c,53 :: 		}
L_end_Set_Servo_Angle:
	RETURN
; end of _Set_Servo_Angle

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;AgriBot.c,56 :: 		void interrupt()
;AgriBot.c,61 :: 		if (TMR1IF_bit)
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt6
;AgriBot.c,63 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,64 :: 		TMR1H = 0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;AgriBot.c,65 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;AgriBot.c,67 :: 		pulse_started = 1;
	MOVLW      1
	MOVWF      _pulse_started+0
;AgriBot.c,68 :: 		PORTB.F3 = 1;  // ✅ Servo pulse HIGH on RB3
	BSF        PORTB+0, 3
;AgriBot.c,71 :: 		ticks = servo_pulse_us / 4; // 1 tick = 4us (20MHz, prescaler 16)
	MOVF       _servo_pulse_us+0, 0
	MOVWF      R0+0
	MOVF       _servo_pulse_us+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
;AgriBot.c,72 :: 		PR2 = ticks;
	MOVF       R0+0, 0
	MOVWF      PR2+0
;AgriBot.c,73 :: 		TMR2 = 0;
	CLRF       TMR2+0
;AgriBot.c,74 :: 		TMR2ON_bit = 1;
	BSF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,75 :: 		}
L_interrupt6:
;AgriBot.c,78 :: 		if (TMR2IF_bit && pulse_started)
	BTFSS      TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
	GOTO       L_interrupt9
	MOVF       _pulse_started+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt9
L__interrupt26:
;AgriBot.c,80 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,81 :: 		PORTB.F3 = 0;  // ✅ Servo pulse LOW
	BCF        PORTB+0, 3
;AgriBot.c,82 :: 		pulse_started = 0;
	CLRF       _pulse_started+0
;AgriBot.c,83 :: 		TMR2ON_bit = 0;
	BCF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,84 :: 		}
L_interrupt9:
;AgriBot.c,85 :: 		}
L_end_interrupt:
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_trigger_pulse:

;AgriBot.c,90 :: 		void trigger_pulse(){
;AgriBot.c,91 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 0
;AgriBot.c,92 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse10:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse10
	NOP
;AgriBot.c,93 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 0
;AgriBot.c,94 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,96 :: 		unsigned int measure_distance(){
;AgriBot.c,97 :: 		unsigned int time = 0;
;AgriBot.c,100 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,103 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,104 :: 		while (!(PORTB & 0x02)) {
L_measure_distance11:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance12
;AgriBot.c,105 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance37
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance37:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance13
;AgriBot.c,106 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,107 :: 		}
L_measure_distance13:
;AgriBot.c,108 :: 		}
	GOTO       L_measure_distance11
L_measure_distance12:
;AgriBot.c,111 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,112 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,113 :: 		T1CON = 0x01;  // Enable Timer1 with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,116 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,117 :: 		while (PORTB & 0x02) {
L_measure_distance14:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance15
;AgriBot.c,118 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance38
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance38:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance16
;AgriBot.c,119 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,120 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,121 :: 		}
L_measure_distance16:
;AgriBot.c,122 :: 		}
	GOTO       L_measure_distance14
L_measure_distance15:
;AgriBot.c,125 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,126 :: 		time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,129 :: 		return time / 116u;
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,130 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_initCutter:

;AgriBot.c,134 :: 		void initCutter(void) {
;AgriBot.c,135 :: 		TRISB.F4 = 0;
	BCF        TRISB+0, 4
;AgriBot.c,136 :: 		PORTB.F4    = 0;
	BCF        PORTB+0, 4
;AgriBot.c,137 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,139 :: 		void cutter_on(void)  { PORTB.F4 = 1; }
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,140 :: 		void cutter_off(void) { PORTB.F4 = 0; }
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeedLeft:

;AgriBot.c,143 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
>>>>>>> Stashed changes
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

<<<<<<< Updated upstream
;AgriBot.c,25 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
=======
;AgriBot.c,144 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
>>>>>>> Stashed changes
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setupPWM:

<<<<<<< Updated upstream
;AgriBot.c,28 :: 		void setupPWM(void)
;AgriBot.c,31 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,32 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,35 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,36 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,39 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,40 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,42 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,43 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,44 :: 		}
=======
;AgriBot.c,147 :: 		void setupPWM(void)
;AgriBot.c,150 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,151 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,154 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,155 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,158 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,159 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,161 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,162 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,163 :: 		}
>>>>>>> Stashed changes
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

<<<<<<< Updated upstream
;AgriBot.c,47 :: 		void motors_stop(void)
;AgriBot.c,49 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,50 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,51 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,52 :: 		}
=======
;AgriBot.c,166 :: 		void motors_stop(void)
;AgriBot.c,168 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,169 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,170 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,171 :: 		}
>>>>>>> Stashed changes
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

<<<<<<< Updated upstream
;AgriBot.c,54 :: 		void motors_forward(void)
;AgriBot.c,56 :: 		PORTD = 0b01011010;            // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,57 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,58 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,59 :: 		}
=======
;AgriBot.c,193 :: 		void motors_forward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,196 :: 		while (1) {
L_motors_forward17:
;AgriBot.c,197 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_motors_forward19
;AgriBot.c,198 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,199 :: 		break;  // break out to handle new command
	GOTO       L_motors_forward18
;AgriBot.c,200 :: 		}
L_motors_forward19:
;AgriBot.c,201 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,202 :: 		if (distance < 20u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motors_forward47
	MOVLW      20
	SUBWF      R0+0, 0
L__motors_forward47:
	BTFSC      STATUS+0, 0
	GOTO       L_motors_forward20
;AgriBot.c,203 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,204 :: 		} else {
	GOTO       L_motors_forward21
L_motors_forward20:
;AgriBot.c,205 :: 		PORTD = 0b01011010;  // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,206 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_forward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,207 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_forward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,208 :: 		}
L_motors_forward21:
;AgriBot.c,209 :: 		}
	GOTO       L_motors_forward17
L_motors_forward18:
;AgriBot.c,210 :: 		}
>>>>>>> Stashed changes
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

<<<<<<< Updated upstream
;AgriBot.c,61 :: 		void motors_backward(void)
;AgriBot.c,63 :: 		PORTD = 0b10100101;            // backward
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,64 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,65 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,66 :: 		}
=======
;AgriBot.c,212 :: 		void motors_backward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,214 :: 		PORTD = 0b10100101;  // Backward direction
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,215 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_backward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,216 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_backward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,217 :: 		}
>>>>>>> Stashed changes
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

<<<<<<< Updated upstream
;AgriBot.c,68 :: 		void motors_left(void)
;AgriBot.c,70 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,71 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,72 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,73 :: 		}
=======
;AgriBot.c,219 :: 		void motors_left(void)
;AgriBot.c,221 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,222 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,223 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,224 :: 		}
>>>>>>> Stashed changes
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

<<<<<<< Updated upstream
;AgriBot.c,75 :: 		void motors_right(void)
;AgriBot.c,77 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,78 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,79 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,80 :: 		}
=======
;AgriBot.c,226 :: 		void motors_right(void)
;AgriBot.c,228 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,229 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,230 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,231 :: 		}
>>>>>>> Stashed changes
L_end_motors_right:
	RETURN
; end of _motors_right

<<<<<<< Updated upstream
_trigger_pulse:

;AgriBot.c,84 :: 		void trigger_pulse(){
;AgriBot.c,85 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 2
;AgriBot.c,86 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse6:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse6
	NOP
;AgriBot.c,87 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 2
;AgriBot.c,88 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,90 :: 		unsigned int measure_distance(){
;AgriBot.c,91 :: 		unsigned int time = 0;
;AgriBot.c,94 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,97 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,98 :: 		while (!(PORTB & 0x02)) {
L_measure_distance7:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance8
;AgriBot.c,99 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance32
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance32:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance9
;AgriBot.c,100 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,101 :: 		}
L_measure_distance9:
;AgriBot.c,102 :: 		}
	GOTO       L_measure_distance7
L_measure_distance8:
;AgriBot.c,105 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,106 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,107 :: 		T1CON = 0x01;  // Enable Timer1 with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,110 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,111 :: 		while (PORTB & 0x02) {
L_measure_distance10:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance11
;AgriBot.c,112 :: 		if (--timeout == 0) {
	MOVLW      1
	SUBWF      measure_distance_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       measure_distance_timeout_L0+1, 1
	MOVLW      0
	XORWF      measure_distance_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__measure_distance33
	MOVLW      0
	XORWF      measure_distance_timeout_L0+0, 0
L__measure_distance33:
	BTFSS      STATUS+0, 2
	GOTO       L_measure_distance12
;AgriBot.c,113 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,114 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,115 :: 		}
L_measure_distance12:
;AgriBot.c,116 :: 		}
	GOTO       L_measure_distance10
L_measure_distance11:
;AgriBot.c,119 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,120 :: 		time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,123 :: 		return time / 116u;
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,124 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_setup:

;AgriBot.c,127 :: 		void setup(){
;AgriBot.c,136 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,137 :: 		TRISC = 0x40;
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,138 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;AgriBot.c,140 :: 		PORTB = 0x00;  // Initialize PORTB
	CLRF       PORTB+0
;AgriBot.c,141 :: 		PORTC = 0x00;  // Initialize PORTC
	CLRF       PORTC+0
;AgriBot.c,142 :: 		PORTD = 0x00;  // Initialize PORTD
	CLRF       PORTD+0
;AgriBot.c,148 :: 		our_delay_ms(100);
=======
_setup:

;AgriBot.c,235 :: 		void setup(){
;AgriBot.c,246 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,247 :: 		TRISC = 0x40;
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,248 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;AgriBot.c,250 :: 		PORTB = 0x00;  // Initialize PORTB
	CLRF       PORTB+0
;AgriBot.c,251 :: 		PORTC = 0x00;  // Initialize PORTC
	CLRF       PORTC+0
;AgriBot.c,252 :: 		PORTD = 0x00;  // Initialize PORTD
	CLRF       PORTD+0
;AgriBot.c,258 :: 		our_delay_ms(100);
>>>>>>> Stashed changes
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
<<<<<<< Updated upstream
;AgriBot.c,149 :: 		}
=======
;AgriBot.c,259 :: 		}
>>>>>>> Stashed changes
L_end_setup:
	RETURN
; end of _setup

_bluetooth_init:

;AgriBot.c,261 :: 		void bluetooth_init() {
;AgriBot.c,262 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;AgriBot.c,263 :: 		our_delay_ms(100);   // Initialize UART with 9600 baud rate
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,264 :: 		}
L_end_bluetooth_init:
	RETURN
; end of _bluetooth_init

_main:

<<<<<<< Updated upstream
;AgriBot.c,152 :: 		void main(void)
;AgriBot.c,158 :: 		setup();
	CALL       _setup+0
;AgriBot.c,161 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,167 :: 		while (1) {
L_main15:
;AgriBot.c,168 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,169 :: 		if (distance < 20u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main36
	MOVLW      20
	SUBWF      R0+0, 0
L__main36:
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;AgriBot.c,170 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,171 :: 		continue;        // skip to next reading
	GOTO       L_main15
;AgriBot.c,172 :: 		}
L_main17:
;AgriBot.c,173 :: 		motors_forward();
	CALL       _motors_forward+0
;AgriBot.c,174 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	DECFSZ     R11+0, 1
	GOTO       L_main18
	NOP
;AgriBot.c,175 :: 		}
	GOTO       L_main15
;AgriBot.c,188 :: 		}
=======
;AgriBot.c,268 :: 		void main(void)
;AgriBot.c,273 :: 		setup();
	CALL       _setup+0
;AgriBot.c,274 :: 		bluetooth_init();
	CALL       _bluetooth_init+0
;AgriBot.c,275 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,276 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,278 :: 		Timer1_Init();         // Start 20ms frame timer
	CALL       _Timer1_Init+0
;AgriBot.c,279 :: 		Timer2_Init();         // Prepare Timer2 for pulse width
	CALL       _Timer2_Init+0
;AgriBot.c,280 :: 		Set_Servo_Angle(90);   // Initial angle (e.g., 90°)
	MOVLW      90
	MOVWF      FARG_Set_Servo_Angle_angle+0
	CALL       _Set_Servo_Angle+0
;AgriBot.c,281 :: 		TRISB.F3 = 0;
	BCF        TRISB+0, 3
;AgriBot.c,282 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,284 :: 		while (1)
L_main22:
;AgriBot.c,339 :: 		PORTB.F3 = 1;
	BSF        PORTB+0, 3
;AgriBot.c,340 :: 		Delay_us(15000);    // 90° position
	MOVLW      39
	MOVWF      R12+0
	MOVLW      245
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
;AgriBot.c,341 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,342 :: 		Delay_ms(20);      // Total frame = 20ms
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	NOP
	NOP
;AgriBot.c,344 :: 		}
	GOTO       L_main22
;AgriBot.c,345 :: 		}
>>>>>>> Stashed changes
L_end_main:
	GOTO       $+0
; end of _main
