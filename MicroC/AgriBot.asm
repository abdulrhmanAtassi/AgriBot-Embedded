
<<<<<<< Updated upstream
_our_delay_ms:

;AgriBot.c,18 :: 		void our_delay_ms(unsigned int ms) {
;AgriBot.c,20 :: 		for (i = 0; i < ms; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_our_delay_ms0:
	MOVF       FARG_our_delay_ms_ms+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms28
	MOVF       FARG_our_delay_ms_ms+0, 0
	SUBWF      R1+0, 0
L__our_delay_ms28:
	BTFSC      STATUS+0, 0
	GOTO       L_our_delay_ms1
;AgriBot.c,21 :: 		for (j = 0; j < 111; j++) NOP();
	CLRF       R3+0
	CLRF       R3+1
L_our_delay_ms3:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__our_delay_ms29
	MOVLW      111
	SUBWF      R3+0, 0
L__our_delay_ms29:
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

_Timer1_Init:

;AgriBot.c,33 :: 		void Timer1_Init()
;AgriBot.c,36 :: 		T1CON = 0b00000001;   // Timer1 ON, Prescaler 1:1
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,37 :: 		TMR1H = 0x0B;         // Preload for 20ms overflow at 20MHz
	MOVLW      11
	MOVWF      TMR1H+0
;AgriBot.c,38 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;AgriBot.c,39 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,40 :: 		TMR1IE_bit = 1;       // Enable Timer1 interrupt
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;AgriBot.c,41 :: 		PEIE_bit = 1;         // Enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;AgriBot.c,42 :: 		GIE_bit = 1;          // Enable global interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;AgriBot.c,43 :: 		}
L_end_Timer1_Init:
	RETURN
; end of _Timer1_Init

_Timer2_Init:

;AgriBot.c,46 :: 		void Timer2_Init()
;AgriBot.c,48 :: 		T2CON = 0b00000111;   // Prescaler 1:16, Timer2 ON when needed
	MOVLW      7
	MOVWF      T2CON+0
;AgriBot.c,49 :: 		PR2 = 249;            // Will be set dynamically
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,50 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,51 :: 		TMR2IE_bit = 1;       // Enable Timer2 interrupt
	BSF        TMR2IE_bit+0, BitPos(TMR2IE_bit+0)
;AgriBot.c,52 :: 		}
L_end_Timer2_Init:
	RETURN
; end of _Timer2_Init

_Set_Servo_Angle:

;AgriBot.c,55 :: 		void Set_Servo_Angle(unsigned char angle)
;AgriBot.c,58 :: 		servo_pulse_us = ((angle * 10) / 9) + 1000;
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
;AgriBot.c,59 :: 		}
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

;AgriBot.c,62 :: 		void interrupt()
;AgriBot.c,67 :: 		if (TMR1IF_bit)
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt6
;AgriBot.c,69 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,70 :: 		TMR1H = 0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;AgriBot.c,71 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;AgriBot.c,73 :: 		pulse_started = 1;
	MOVLW      1
	MOVWF      _pulse_started+0
;AgriBot.c,74 :: 		PORTB.F3 = 1;  // ✅ Servo pulse HIGH on RB3
	BSF        PORTB+0, 3
;AgriBot.c,77 :: 		ticks = servo_pulse_us / 4; // 1 tick = 4us (20MHz, prescaler 16)
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
;AgriBot.c,78 :: 		PR2 = ticks;
	MOVF       R0+0, 0
	MOVWF      PR2+0
;AgriBot.c,79 :: 		TMR2 = 0;
	CLRF       TMR2+0
;AgriBot.c,80 :: 		TMR2ON_bit = 1;
	BSF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,81 :: 		}
L_interrupt6:
;AgriBot.c,84 :: 		if (TMR2IF_bit && pulse_started)
	BTFSS      TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
	GOTO       L_interrupt9
	MOVF       _pulse_started+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt9
L__interrupt26:
;AgriBot.c,86 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,87 :: 		PORTB.F3 = 0;  // ✅ Servo pulse LOW
	BCF        PORTB+0, 3
;AgriBot.c,88 :: 		pulse_started = 0;
	CLRF       _pulse_started+0
;AgriBot.c,89 :: 		TMR2ON_bit = 0;
	BCF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,90 :: 		}
L_interrupt9:
;AgriBot.c,91 :: 		}
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

;AgriBot.c,98 :: 		void trigger_pulse(){
;AgriBot.c,99 :: 		TRIG = 1;  // Set Trigger pin high
	BSF        PORTB+0, 0
;AgriBot.c,100 :: 		delay_us(10);  // 10us pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_pulse10:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_pulse10
	NOP
;AgriBot.c,101 :: 		TRIG = 0;  // Set Trigger pin low
	BCF        PORTB+0, 0
;AgriBot.c,102 :: 		}
L_end_trigger_pulse:
	RETURN
; end of _trigger_pulse

_measure_distance:

;AgriBot.c,104 :: 		unsigned int measure_distance(){
;AgriBot.c,105 :: 		unsigned int time = 0;
;AgriBot.c,108 :: 		trigger_pulse();
	CALL       _trigger_pulse+0
;AgriBot.c,111 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,112 :: 		while (!(PORTB & 0x02)) {
L_measure_distance11:
	BTFSC      PORTB+0, 1
	GOTO       L_measure_distance12
;AgriBot.c,113 :: 		if (--timeout == 0) {
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
;AgriBot.c,114 :: 		return 0;  // Timeout prevention, no object detected
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,115 :: 		}
L_measure_distance13:
;AgriBot.c,116 :: 		}
	GOTO       L_measure_distance11
L_measure_distance12:
;AgriBot.c,119 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AgriBot.c,120 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AgriBot.c,121 :: 		T1CON = 0x01;  // Enable Timer1 with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,124 :: 		timeout = 0xFFFF;
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+0
	MOVLW      255
	MOVWF      measure_distance_timeout_L0+1
;AgriBot.c,125 :: 		while (PORTB & 0x02) {
L_measure_distance14:
	BTFSS      PORTB+0, 1
	GOTO       L_measure_distance15
;AgriBot.c,126 :: 		if (--timeout == 0) {
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
;AgriBot.c,127 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,128 :: 		return 0;  // Timeout prevention
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_measure_distance
;AgriBot.c,129 :: 		}
L_measure_distance16:
;AgriBot.c,130 :: 		}
	GOTO       L_measure_distance14
L_measure_distance15:
;AgriBot.c,133 :: 		T1CON = 0x00;  // Disable Timer1
	CLRF       T1CON+0
;AgriBot.c,134 :: 		time = (TMR1H << 8) | TMR1L;  // Combine high and low bytes
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AgriBot.c,137 :: 		return time / 116u;
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
;AgriBot.c,138 :: 		}
L_end_measure_distance:
	RETURN
; end of _measure_distance

_initCutter:

;AgriBot.c,142 :: 		void initCutter(void) {
;AgriBot.c,143 :: 		TRISB.F4 = 0;
	BCF        TRISB+0, 4
;AgriBot.c,144 :: 		PORTB.F4    = 0;
	BCF        PORTB+0, 4
;AgriBot.c,145 :: 		}
L_end_initCutter:
	RETURN
; end of _initCutter

_cutter_on:

;AgriBot.c,147 :: 		void cutter_on(void)  { PORTB.F4 = 1; }
	BSF        PORTB+0, 4
L_end_cutter_on:
	RETURN
; end of _cutter_on

_cutter_off:

;AgriBot.c,148 :: 		void cutter_off(void) { PORTB.F4 = 0; }
	BCF        PORTB+0, 4
L_end_cutter_off:
	RETURN
; end of _cutter_off

_setSpeedLeft:

;AgriBot.c,151 :: 		void setSpeedLeft (unsigned char duty) { CCPR1L = duty; }   // 0-255
	MOVF       FARG_setSpeedLeft_duty+0, 0
	MOVWF      CCPR1L+0
L_end_setSpeedLeft:
	RETURN
; end of _setSpeedLeft

_setSpeedRight:

;AgriBot.c,152 :: 		void setSpeedRight(unsigned char duty) { CCPR2L = duty; }
	MOVF       FARG_setSpeedRight_duty+0, 0
	MOVWF      CCPR2L+0
L_end_setSpeedRight:
	RETURN
; end of _setSpeedRight

_setupPWM:

;AgriBot.c,155 :: 		void setupPWM(void)
;AgriBot.c,158 :: 		TRISC.F2 = 0;   // RC2
	BCF        TRISC+0, 2
;AgriBot.c,159 :: 		TRISC.F1 = 0;   // RC1
	BCF        TRISC+0, 1
;AgriBot.c,162 :: 		CCP1CON = 0b00001100;     // CCP1 PWM
	MOVLW      12
	MOVWF      CCP1CON+0
;AgriBot.c,163 :: 		CCP2CON = 0b00001100;     // CCP2 PWM
	MOVLW      12
	MOVWF      CCP2CON+0
;AgriBot.c,166 :: 		PR2   = 249;              // period
	MOVLW      249
	MOVWF      PR2+0
;AgriBot.c,167 :: 		T2CON = 0b00000101;       // prescaler 4, TMR2 on
	MOVLW      5
	MOVWF      T2CON+0
;AgriBot.c,169 :: 		setSpeedLeft (128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,170 :: 		setSpeedRight(128);       // 50 %
	MOVLW      128
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,171 :: 		}
L_end_setupPWM:
	RETURN
; end of _setupPWM

_motors_stop:

;AgriBot.c,174 :: 		void motors_stop(void)
;AgriBot.c,176 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;AgriBot.c,177 :: 		setSpeedLeft(0);
	CLRF       FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,178 :: 		setSpeedRight(0);
	CLRF       FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,179 :: 		}
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;AgriBot.c,201 :: 		void motors_forward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,204 :: 		while (1) {
L_motors_forward17:
;AgriBot.c,205 :: 		if (UART1_Data_Ready()) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_motors_forward19
;AgriBot.c,206 :: 		command = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _command+0
;AgriBot.c,207 :: 		break;  // break out to handle new command
	GOTO       L_motors_forward18
;AgriBot.c,208 :: 		}
L_motors_forward19:
;AgriBot.c,209 :: 		distance = measure_distance();
	CALL       _measure_distance+0
;AgriBot.c,210 :: 		if (distance < 20u) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motors_forward47
	MOVLW      20
	SUBWF      R0+0, 0
L__motors_forward47:
	BTFSC      STATUS+0, 0
	GOTO       L_motors_forward20
;AgriBot.c,211 :: 		motors_stop();
	CALL       _motors_stop+0
;AgriBot.c,212 :: 		} else {
	GOTO       L_motors_forward21
L_motors_forward20:
;AgriBot.c,213 :: 		PORTD = 0b01011010;  // forward
	MOVLW      90
	MOVWF      PORTD+0
;AgriBot.c,214 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_forward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,215 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_forward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,216 :: 		}
L_motors_forward21:
;AgriBot.c,217 :: 		}
	GOTO       L_motors_forward17
L_motors_forward18:
;AgriBot.c,218 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_motors_backward:

;AgriBot.c,220 :: 		void motors_backward(unsigned char left_speed, unsigned char right_speed)
;AgriBot.c,222 :: 		PORTD = 0b10100101;  // Backward direction
	MOVLW      165
	MOVWF      PORTD+0
;AgriBot.c,223 :: 		setSpeedLeft(left_speed);
	MOVF       FARG_motors_backward_left_speed+0, 0
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,224 :: 		setSpeedRight(right_speed);
	MOVF       FARG_motors_backward_right_speed+0, 0
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,225 :: 		}
L_end_motors_backward:
	RETURN
; end of _motors_backward

_motors_left:

;AgriBot.c,227 :: 		void motors_left(void)
;AgriBot.c,229 :: 		PORTD = 0b01010101;            // turn left
	MOVLW      85
	MOVWF      PORTD+0
;AgriBot.c,230 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,231 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,232 :: 		}
L_end_motors_left:
	RETURN
; end of _motors_left

_motors_right:

;AgriBot.c,234 :: 		void motors_right(void)
;AgriBot.c,236 :: 		PORTD = 0b10101010;            // turn right
	MOVLW      170
	MOVWF      PORTD+0
;AgriBot.c,237 :: 		setSpeedLeft(150);
	MOVLW      150
	MOVWF      FARG_setSpeedLeft_duty+0
	CALL       _setSpeedLeft+0
;AgriBot.c,238 :: 		setSpeedRight(150);
	MOVLW      150
	MOVWF      FARG_setSpeedRight_duty+0
	CALL       _setSpeedRight+0
;AgriBot.c,239 :: 		}
L_end_motors_right:
	RETURN
; end of _motors_right

_setup:

;AgriBot.c,243 :: 		void setup(){
;AgriBot.c,254 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;AgriBot.c,255 :: 		TRISC = 0x40;
	MOVLW      64
	MOVWF      TRISC+0
;AgriBot.c,256 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;AgriBot.c,258 :: 		PORTB = 0x00;  // Initialize PORTB
	CLRF       PORTB+0
;AgriBot.c,259 :: 		PORTC = 0x00;  // Initialize PORTC
	CLRF       PORTC+0
;AgriBot.c,260 :: 		PORTD = 0x00;  // Initialize PORTD
	CLRF       PORTD+0
;AgriBot.c,266 :: 		our_delay_ms(100);
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,267 :: 		}
=======
_setup:

;AgriBot.c,423 :: 		void setup(void)
;AgriBot.c,426 :: 		TRISB  = 0x00;      // all PORTB as output for demo
	CLRF       TRISB+0
;AgriBot.c,427 :: 		PORTB  = 0x00;
	CLRF       PORTB+0
;AgriBot.c,430 :: 		TRISB.F3 = 0;       // output
	BCF        TRISB+0, 3
;AgriBot.c,431 :: 		PORTB.F3 = 0;       // low
	BCF        PORTB+0, 3
;AgriBot.c,432 :: 		}
>>>>>>> Stashed changes
L_end_setup:
	RETURN
; end of _setup

_Timer1_Init:

<<<<<<< Updated upstream
;AgriBot.c,269 :: 		void bluetooth_init() {
;AgriBot.c,270 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;AgriBot.c,271 :: 		our_delay_ms(100);   // Initialize UART with 9600 baud rate
	MOVLW      100
	MOVWF      FARG_our_delay_ms_ms+0
	MOVLW      0
	MOVWF      FARG_our_delay_ms_ms+1
	CALL       _our_delay_ms+0
;AgriBot.c,272 :: 		}
L_end_bluetooth_init:
=======
;AgriBot.c,435 :: 		void Timer1_Init(void)
;AgriBot.c,440 :: 		T1CON      = 0b00000001;   // prescaler 1:1, Timer-1 ON
	MOVLW      1
	MOVWF      T1CON+0
;AgriBot.c,441 :: 		TMR1H      = 0x63;
	MOVLW      99
	MOVWF      TMR1H+0
;AgriBot.c,442 :: 		TMR1L      = 0xC0;
	MOVLW      192
	MOVWF      TMR1L+0
;AgriBot.c,443 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,444 :: 		TMR1IE_bit = 1;            // enable Timer-1 interrupt
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;AgriBot.c,445 :: 		}
L_end_Timer1_Init:
>>>>>>> Stashed changes
	RETURN
; end of _Timer1_Init

_Timer2_Init:

;AgriBot.c,448 :: 		void Timer2_Init(void)
;AgriBot.c,451 :: 		T2CON      = 0b00000100;   // prescaler 1:16, Timer-2 OFF
	MOVLW      4
	MOVWF      T2CON+0
;AgriBot.c,452 :: 		PR2        = 250;          // dummy, overwritten each frame
	MOVLW      250
	MOVWF      PR2+0
;AgriBot.c,453 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,454 :: 		TMR2IE_bit = 1;            // enable Timer-2 interrupt
	BSF        TMR2IE_bit+0, BitPos(TMR2IE_bit+0)
;AgriBot.c,455 :: 		}
L_end_Timer2_Init:
	RETURN
; end of _Timer2_Init

_Set_Servo_Angle:

;AgriBot.c,458 :: 		void Set_Servo_Angle(unsigned char angle)
;AgriBot.c,461 :: 		servo_pulse_us = ((unsigned int)angle * 1000u) / 180u + 1000u;
	MOVF       FARG_Set_Servo_Angle_angle+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      180
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
	MOVLW      232
	ADDWF      R0+0, 0
	MOVWF      _servo_pulse_us+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      3
	MOVWF      _servo_pulse_us+1
;AgriBot.c,462 :: 		}
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

;AgriBot.c,465 :: 		void interrupt(void)
;AgriBot.c,468 :: 		if (TMR1IF_bit)
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt0
;AgriBot.c,472 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;AgriBot.c,473 :: 		TMR1H = 0x63;          // reload 20 ms
	MOVLW      99
	MOVWF      TMR1H+0
;AgriBot.c,474 :: 		TMR1L = 0xC0;
	MOVLW      192
	MOVWF      TMR1L+0
;AgriBot.c,476 :: 		pulse_started = 1;
	MOVLW      1
	MOVWF      _pulse_started+0
;AgriBot.c,477 :: 		PORTB.F3 = 1;          // raise servo pulse
	BSF        PORTB+0, 3
;AgriBot.c,480 :: 		ticks = servo_pulse_us / 8u;   // 125-250 (=1-2 ms)
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
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
;AgriBot.c,481 :: 		PR2   = (unsigned char)ticks;
	MOVF       R0+0, 0
	MOVWF      PR2+0
;AgriBot.c,482 :: 		TMR2  = 0;
	CLRF       TMR2+0
;AgriBot.c,483 :: 		TMR2ON_bit = 1;        // start Timer-2
	BSF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,484 :: 		}
L_interrupt0:
;AgriBot.c,487 :: 		if (TMR2IF_bit && pulse_started)
	BTFSS      TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
	GOTO       L_interrupt3
	MOVF       _pulse_started+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
L__interrupt9:
;AgriBot.c,489 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;AgriBot.c,490 :: 		TMR2ON_bit = 0;
	BCF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;AgriBot.c,491 :: 		PORTB.F3   = 0;        // lower servo pulse
	BCF        PORTB+0, 3
;AgriBot.c,492 :: 		pulse_started = 0;
	CLRF       _pulse_started+0
;AgriBot.c,493 :: 		}
L_interrupt3:
;AgriBot.c,494 :: 		}
L_end_interrupt:
L__interrupt15:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

<<<<<<< Updated upstream
;AgriBot.c,276 :: 		void main(void)
;AgriBot.c,279 :: 		setup();
	CALL       _setup+0
;AgriBot.c,280 :: 		bluetooth_init();
	CALL       _bluetooth_init+0
;AgriBot.c,281 :: 		initCutter();
	CALL       _initCutter+0
;AgriBot.c,282 :: 		setupPWM();
	CALL       _setupPWM+0
;AgriBot.c,284 :: 		Timer1_Init();         // Start 20ms frame timer
	CALL       _Timer1_Init+0
;AgriBot.c,285 :: 		Timer2_Init();         // Prepare Timer2 for pulse width
	CALL       _Timer2_Init+0
;AgriBot.c,286 :: 		Set_Servo_Angle(90);   // Initial angle (e.g., 90°)
	MOVLW      90
	MOVWF      FARG_Set_Servo_Angle_angle+0
	CALL       _Set_Servo_Angle+0
;AgriBot.c,287 :: 		TRISB.F3 = 0;
	BCF        TRISB+0, 3
;AgriBot.c,288 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,290 :: 		while (1)
L_main22:
;AgriBot.c,345 :: 		PORTB.F3 = 1;
	BSF        PORTB+0, 3
;AgriBot.c,346 :: 		Delay_us(15000);    // 90° position
	MOVLW      39
=======
;AgriBot.c,497 :: 		void main(void)
;AgriBot.c,499 :: 		setup();
	CALL       _setup+0
;AgriBot.c,501 :: 		Timer1_Init();
	CALL       _Timer1_Init+0
;AgriBot.c,502 :: 		Timer2_Init();
	CALL       _Timer2_Init+0
;AgriBot.c,504 :: 		PEIE_bit = 1;              // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;AgriBot.c,505 :: 		GIE_bit  = 1;              // global interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;AgriBot.c,508 :: 		while (1)
L_main4:
;AgriBot.c,510 :: 		Set_Servo_Angle(0);    Delay_ms(1000);
	CLRF       FARG_Set_Servo_Angle_angle+0
	CALL       _Set_Servo_Angle+0
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
>>>>>>> Stashed changes
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
<<<<<<< Updated upstream
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
;AgriBot.c,347 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;AgriBot.c,348 :: 		Delay_ms(20);      // Total frame = 20ms
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
;AgriBot.c,350 :: 		}
	GOTO       L_main22
;AgriBot.c,352 :: 		}
=======
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;AgriBot.c,511 :: 		Set_Servo_Angle(90);   Delay_ms(1000);
	MOVLW      90
	MOVWF      FARG_Set_Servo_Angle_angle+0
	CALL       _Set_Servo_Angle+0
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;AgriBot.c,512 :: 		Set_Servo_Angle(180);  Delay_ms(1000);
	MOVLW      180
	MOVWF      FARG_Set_Servo_Angle_angle+0
	CALL       _Set_Servo_Angle+0
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;AgriBot.c,513 :: 		}
	GOTO       L_main4
;AgriBot.c,514 :: 		}
>>>>>>> Stashed changes
L_end_main:
	GOTO       $+0
; end of _main
