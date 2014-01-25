
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _next_symbol=R3
	.DEF _line_pointer=R2
	.DEF _dir=R5
	.DEF _enable_update=R4
	.DEF _enable_check=R7
	.DEF _last_inf_time=R8
	.DEF _last_value=R6
	.DEF _last_time=R10
	.DEF _more_last_time=R12

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _period_overflow
	RJMP _next_sym
	RJMP _next_value
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _line_overflow
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_Frame:
	.DB  0xF0,0x88,0x8C,0x88,0xF0,0x88,0x88,0xF0

_0x7:
	.DB  0x0
_0x60003:
	.DB  0x1
_0x60004:
	.DB  0x78,0x1E
_0x60016:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x03
	.DW  _0x7*2

	.DW  0x01
	.DW  _dir_counter
	.DW  _0x60003*2

	.DW  0x02
	.DW  _period
	.DW  _0x60004*2

	.DW  0x08
	.DW  0x02
	.DW  _0x60016*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;#include <sweep.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;eeprom int x=0;
;char next_symbol=0;
;
;void main(void)
; 0000 0007 {

	.CSEG
_main:
; 0000 0008     #asm("sei")      //set enable interrupts
	sei
; 0000 0009     sweep_init();
	RCALL _sweep_init
; 0000 000A     while(1)
_0x3:
; 0000 000B     {
; 0000 000C         try_update();
	RCALL _try_update
; 0000 000D         #asm("sleep")
	sleep
; 0000 000E         #asm("nop")
	nop
; 0000 000F     }
	RJMP _0x3
_0x5:
; 0000 0010     x=0;
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 0011 }
_0x6:
	RJMP _0x6
;#include<progI2C.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;void I2C_init()
; 0001 0005 {

	.CSEG
_I2C_init:
; 0001 0006     ACCDDR |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA);   //SDA,SCL,POWER set out
	IN   R30,0x11
	ORI  R30,LOW(0x7)
	OUT  0x11,R30
; 0001 0007     ACCPORT |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA);  //SDA,SCL,POWER set 1
	IN   R30,0x12
	ORI  R30,LOW(0x7)
	OUT  0x12,R30
; 0001 0008 }
	RET
;
;void send_start()
; 0001 000B {
_send_start:
; 0001 000C     ACCDDR |= (1<<SDA);         //SDA set out
	SBI  0x11,0
; 0001 000D     ACCPORT |= (1<<SDA);        //SDA=1
	SBI  0x12,0
; 0001 000E     ACCPORT |= (1<<SCL);        //SCL=1
	SBI  0x12,1
; 0001 000F     ACCPORT &= ~(1<<SDA);       //SDA=0
	RCALL SUBOPT_0x0
; 0001 0010     delay_us(hold_time);
; 0001 0011 }
	RET
;
;void repeat_start()
; 0001 0014 {
_repeat_start:
; 0001 0015     ACCDDR |= (1<<SDA);         //SDA set out
	SBI  0x11,0
; 0001 0016     ACCPORT |= (1<<SDA);        //SDA=1
	SBI  0x12,0
; 0001 0017     ACCPORT |= (1<<SCL);        //SCL=1
	RCALL SUBOPT_0x1
; 0001 0018     delay_us(clock_hight);
; 0001 0019     ACCPORT &= ~(1<<SDA);       //SDA=0
	RCALL SUBOPT_0x0
; 0001 001A     delay_us(hold_time);
; 0001 001B }
	RET
;
;void send_byte(char message)
; 0001 001E {
_send_byte:
; 0001 001F     char i;
; 0001 0020     char mask=0b10000000;
; 0001 0021     ACCDDR |= (1<<SDA);         //SDA set out
	RCALL __SAVELOCR2
;	message -> Y+2
;	i -> R17
;	mask -> R16
	LDI  R16,128
	SBI  0x11,0
; 0001 0022     ACCPORT &= ~(1<<SCL);       //SCL=0
	CBI  0x12,1
; 0001 0023     delay_us(clock_low);
	__DELAY_USB 13
; 0001 0024     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x20005
; 0001 0025     {
; 0001 0026         if(message&mask)
	MOV  R30,R16
	LDD  R26,Y+2
	AND  R30,R26
	BRNE PC+2
	RJMP _0x20006
; 0001 0027             ACCPORT |= (1<<SDA); //SDA=1
	SBI  0x12,0
; 0001 0028         else
	RJMP _0x20007
_0x20006:
; 0001 0029             ACCPORT &= ~(1<<SDA);//SDA=0
	CBI  0x12,0
; 0001 002A         mask=mask>>1;       //enough time for setup
_0x20007:
	LSR  R16
; 0001 002B         //delay_us(setup_time);
; 0001 002C         ACCPORT |= (1<<SCL);    //SCL=1
	RCALL SUBOPT_0x1
; 0001 002D         delay_us(clock_hight);
; 0001 002E         ACCPORT &= ~(1<<SCL);   //SCL=0
	RCALL SUBOPT_0x2
; 0001 002F         delay_us(hold_time);
; 0001 0030     }
_0x20003:
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0031     get_sak();
	RCALL _get_sak
; 0001 0032 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;char get_byte()
; 0001 0035 {
_get_byte:
; 0001 0036     char i,temp=0x00;
; 0001 0037     ACCPORT &= ~(1<<SCL);       //SCL=0
	RCALL __SAVELOCR2
;	i -> R17
;	temp -> R16
	LDI  R16,0
	CBI  0x12,1
; 0001 0038     ACCDDR &= ~(1<<SDA);        //SDA set in
	CBI  0x11,0
; 0001 0039     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x20009:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x2000A
; 0001 003A     {
; 0001 003B         ACCPORT |= (1<<SCL);        //SCL=1
	SBI  0x12,1
; 0001 003C         temp = temp<<1;
	LSL  R16
; 0001 003D         delay_us(setup_time);
	RCALL SUBOPT_0x3
; 0001 003E         temp |= ACCPIN&(1<<SDA);
	OR   R16,R30
; 0001 003F         ACCPORT &= ~(1<<SCL);       //SCL=0
	RCALL SUBOPT_0x2
; 0001 0040         delay_us(hold_time);
; 0001 0041     }
_0x20008:
	SUBI R17,-1
	RJMP _0x20009
_0x2000A:
; 0001 0042     return temp;
	MOV  R30,R16
	RCALL __LOADLOCR2P
	RET
; 0001 0043 }
;
;char get_sak()
; 0001 0046 {
_get_sak:
; 0001 0047     char temp;
; 0001 0048     ACCPORT &= ~(1<<SCL);       //SCL=0
	ST   -Y,R17
;	temp -> R17
	CBI  0x12,1
; 0001 0049     ACCDDR &= ~(1<<SDA);        //SDA set in
	CBI  0x11,0
; 0001 004A     ACCPORT |= (1<<SDA);        //SDA=1  line supporter
	SBI  0x12,0
; 0001 004B     ACCPORT |= (1<<SCL);        //SCL=1
	SBI  0x12,1
; 0001 004C     delay_us(setup_time);
	RCALL SUBOPT_0x3
; 0001 004D     temp=ACCPIN&(1<<SDA);
	MOV  R17,R30
; 0001 004E     ACCPORT &= ~(1<<SCL);       //SCL=0
	RCALL SUBOPT_0x2
; 0001 004F     delay_us(hold_time);
; 0001 0050     return temp;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 0051 }
;
;void send_mak(char mode)
; 0001 0054 {
_send_mak:
; 0001 0055     ACCDDR |= (1<<SDA);         //SDA set out
;	mode -> Y+0
	SBI  0x11,0
; 0001 0056     ACCPORT &= ~(1<<SCL);       //SCL=0
	CBI  0x12,1
; 0001 0057         if(mode)
	LD   R30,Y
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000B
; 0001 0058             ACCPORT |= (1<<SDA); //SDA=1
	SBI  0x12,0
; 0001 0059         else
	RJMP _0x2000C
_0x2000B:
; 0001 005A             ACCPORT &= ~(1<<SDA);//SDA=0
	CBI  0x12,0
; 0001 005B     delay_us(setup_time);
_0x2000C:
	__DELAY_USB 3
; 0001 005C     ACCPORT |= (1<<SCL);    //SCL=1
	RCALL SUBOPT_0x1
; 0001 005D     delay_us(clock_hight);
; 0001 005E     ACCPORT &= ~(1<<SCL);   //SCL=0
	RCALL SUBOPT_0x2
; 0001 005F     delay_us(hold_time);
; 0001 0060 }
	ADIW R28,1
	RET
;
;void send_stop()
; 0001 0063 {
_send_stop:
; 0001 0064     ACCDDR |= (1<<SDA);         //SDA set out
	SBI  0x11,0
; 0001 0065     ACCPORT &= ~(1<<SDA);       //SDA=0
	CBI  0x12,0
; 0001 0066     ACCPORT |= (1<<SCL);        //SCL=1
	SBI  0x12,1
; 0001 0067     delay_us(setup_time);
	__DELAY_USB 3
; 0001 0068     ACCPORT |= (1<<SDA);        //SDA=1
	SBI  0x12,0
; 0001 0069     delay_us(clock_hight);
	__DELAY_USB 11
; 0001 006A }
	RET
;#include <lis331dl.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;char get_at_address(char reg_addr)
; 0002 0004 {

	.CSEG
_get_at_address:
; 0002 0005     char temp;
; 0002 0006     send_start();
	ST   -Y,R17
;	reg_addr -> Y+1
;	temp -> R17
	RCALL SUBOPT_0x4
; 0002 0007     send_byte(address<<1);
; 0002 0008     send_byte(reg_addr);
; 0002 0009     repeat_start();
	RCALL _repeat_start
; 0002 000A     send_byte((address<<1)+1);
	LDI  R30,LOW(59)
	ST   -Y,R30
	RCALL _send_byte
; 0002 000B     temp=get_byte();
	RCALL _get_byte
	MOV  R17,R30
; 0002 000C     send_mak(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _send_mak
; 0002 000D     send_stop();
	RCALL _send_stop
; 0002 000E     return temp;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0002 000F }
;
;void set_at_address(char reg_addr, char data)
; 0002 0012 {
_set_at_address:
; 0002 0013     send_start();
;	reg_addr -> Y+1
;	data -> Y+0
	RCALL SUBOPT_0x4
; 0002 0014     send_byte(address<<1);
; 0002 0015     send_byte(reg_addr);
; 0002 0016     send_byte(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _send_byte
; 0002 0017     send_stop();
	RCALL _send_stop
; 0002 0018 }
	ADIW R28,2
	RET
;
;void acc_init()
; 0002 001B {
_acc_init:
; 0002 001C     I2C_init();
	RCALL _I2C_init
; 0002 001D     delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0002 001E     set_at_address(CTRL_REG1,0b11100111); //set DR, PD, FS, Zen, Yen, Xen
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(231)
	ST   -Y,R30
	RCALL _set_at_address
; 0002 001F }
	RET
;
;signed char get_X()
; 0002 0022 {
; 0002 0023     return get_at_address(OUT_X);
; 0002 0024 }
;signed char get_Y()
; 0002 0026 {
_get_Y:
; 0002 0027     return get_at_address(OUT_Y);
	LDI  R30,LOW(43)
	ST   -Y,R30
	RCALL _get_at_address
	RET
; 0002 0028 }
;/*
;signed char get_Z()
;{
;    return get_at_address(OUT_Z);
;}
;
;axis_values get_axis_values()
;{
;    axis_values temp;
;    temp.X=get_at_address(OUT_X);
;    temp.Y=get_at_address(OUT_Y);
;    temp.Z=get_at_address(OUT_Z);
;    return temp;
;}  */
;#include <sweep.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;__flash char Frame[]={0xf0,0x88,0x8c,0x88,0xf0,0x88,0x88,0xf0}; //symbol B //{0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};//{0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00}; //symbol A
;
;extern char next_symbol;
;
;char line_pointer=0;
;char dir=0;                 //0-up 1-down
;
;char enable_update=0;               //permission to update the acceleration data
;char enable_check=0;                //permission to processing acceleration data
;unsigned int last_inf_time=0;
;signed char last_value=0;
;int last_time,more_last_time;
;char dir_counter=1;  //0 - negative direction=1; 2 - positive direction=0;

	.DSEG
;
;unsigned int periods_arr[8];
;unsigned int period=7800;   //time of one swing
;
;void sweep_init()
; 0003 0015 {

	.CSEG
_sweep_init:
; 0003 0016     acc_init();
	RCALL _acc_init
; 0003 0017     DDRB=0xff;              //set output portB
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0003 0018     set_periods();
	RCALL _set_periods
; 0003 0019     TCCR0B |=(1<<CS02);     //set prescale 256 on TIMER0
	IN   R30,0x33
	ORI  R30,4
	OUT  0x33,R30
; 0003 001A     TCCR1B |=(1<<CS12);     //set prescale 256 on TIMER1
	IN   R30,0x2E
	ORI  R30,4
	OUT  0x2E,R30
; 0003 001B     TIMSK |=(1<<OCIE1A)|(1<<OCIE1B)|(1<<TOIE1)|(1<<TOIE0);     //set enable Compare A/B Match interrupts on TIMER1 and Overflows
	IN   R30,0x39
	ORI  R30,LOW(0xE2)
	OUT  0x39,R30
; 0003 001C 
; 0003 001D     OCR0A=128;
	LDI  R30,LOW(128)
	OUT  0x36,R30
; 0003 001E     OCR1A=TCNT1+period;
	IN   R30,0x2C
	IN   R31,0x2C+1
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0003 001F     set_line();
; 0003 0020 }
	RET
;
;void set_line()
; 0003 0023 {
_set_line:
; 0003 0024     if(dir)
	TST  R5
	BRNE PC+2
	RJMP _0x60005
; 0003 0025         FRAMEPORT=Frame[7-line_pointer];          //set output line
	LDI  R30,LOW(7)
	SUB  R30,R2
	RCALL SUBOPT_0x7
; 0003 0026     else
	RJMP _0x60006
_0x60005:
; 0003 0027         FRAMEPORT=Frame[line_pointer];
	MOV  R30,R2
	RCALL SUBOPT_0x7
; 0003 0028     OCR1B=TCNT1+periods_arr[line_pointer];      //set time for line
_0x60006:
	__INWR 0,1,44
	MOV  R30,R2
	LDI  R26,LOW(_periods_arr)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	ADD  R30,R0
	ADC  R31,R1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0003 0029     if(line_pointer<7) line_pointer++;
	LDI  R30,LOW(7)
	CP   R2,R30
	BRLO PC+2
	RJMP _0x60007
	INC  R2
; 0003 002A }
_0x60007:
	RET
;
;void set_periods()     //set periods of lines
; 0003 002D {
_set_periods:
; 0003 002E     periods_arr[0]=(period/(int)4-period/(int)50);      //23%
	RCALL SUBOPT_0x8
	RCALL __LSRW2
	RCALL SUBOPT_0x9
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STS  _periods_arr,R26
	STS  _periods_arr+1,R27
; 0003 002F     periods_arr[1]=(period/(int)8-period/(int)50);      //10,5%
	RCALL SUBOPT_0x8
	RCALL __LSRW3
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	__PUTW1MN _periods_arr,2
; 0003 0030     periods_arr[2]=(period/(int)11-period/(int)200);    //8,6%
	RCALL SUBOPT_0x5
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RCALL __DIVW21U
	MOVW R22,R30
	RCALL SUBOPT_0x5
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL __DIVW21U
	RCALL SUBOPT_0xA
	__PUTW1MN _periods_arr,4
; 0003 0031     periods_arr[3]=(period/(int)12-period/(int)300);    //8%
	RCALL SUBOPT_0x5
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL __DIVW21U
	MOVW R22,R30
	RCALL SUBOPT_0x5
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL __DIVW21U
	RCALL SUBOPT_0xA
	__PUTW1MN _periods_arr,6
; 0003 0032     periods_arr[4]=periods_arr[3];
	__GETW1MN _periods_arr,6
	__PUTW1MN _periods_arr,8
; 0003 0033     periods_arr[5]=periods_arr[2];
	__GETW1MN _periods_arr,4
	__PUTW1MN _periods_arr,10
; 0003 0034     periods_arr[6]=periods_arr[1];
	__GETW1MN _periods_arr,2
	__PUTW1MN _periods_arr,12
; 0003 0035     periods_arr[7]=period;
	RCALL SUBOPT_0x8
	__PUTW1MN _periods_arr,14
; 0003 0036 }
	RET
;
;void set_new_swing()
; 0003 0039 {
_set_new_swing:
; 0003 003A     period=more_last_time-last_inf_time;
	MOVW R30,R12
	SUB  R30,R8
	SBC  R31,R9
	STS  _period,R30
	STS  _period+1,R31
; 0003 003B     set_periods();
	RCALL _set_periods
; 0003 003C     enable_check=0;
	CLR  R7
; 0003 003D     line_pointer=0;
	CLR  R2
; 0003 003E     TCNT1=more_last_time; //back to the past: set inf time
	__OUTWR 12,13,44
; 0003 003F     last_inf_time=TCNT1;
	__INWR 8,9,44
; 0003 0040     OCR1A=TCNT1+period/2;
	IN   R30,0x2C
	IN   R31,0x2C+1
	MOVW R26,R30
	RCALL SUBOPT_0x8
	LSR  R31
	ROR  R30
	RCALL SUBOPT_0x6
; 0003 0041     set_line();
; 0003 0042 }
	RET
;
;int check_inf(signed char value)
; 0003 0045 {
_check_inf:
; 0003 0046     if((value>last_value)&&(dir_counter<2))     dir_counter++;  //value rising -> dir_counter++
;	value -> Y+0
	LD   R26,Y
	CP   R6,R26
	BRLT PC+2
	RJMP _0x60009
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0x60009
	RJMP _0x6000A
_0x60009:
	RJMP _0x60008
_0x6000A:
	LDS  R30,_dir_counter
	SUBI R30,-LOW(1)
	STS  _dir_counter,R30
; 0003 0047     if((value<last_value)&&(dir_counter>0))     dir_counter--;  //value falling -> dir_counter--
_0x60008:
	LD   R26,Y
	CP   R26,R6
	BRLT PC+2
	RJMP _0x6000C
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x1)
	BRSH PC+2
	RJMP _0x6000C
	RJMP _0x6000D
_0x6000C:
	RJMP _0x6000B
_0x6000D:
	LDS  R30,_dir_counter
	SUBI R30,LOW(1)
	STS  _dir_counter,R30
; 0003 0048 
; 0003 0049     if(dir)
_0x6000B:
	TST  R5
	BRNE PC+2
	RJMP _0x6000E
; 0003 004A     {
; 0003 004B         if(dir_counter>1)
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x2)
	BRSH PC+2
	RJMP _0x6000F
; 0003 004C         {
; 0003 004D             dir=0;      //change direction
	CLR  R5
; 0003 004E             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ADIW R28,1
	RET
; 0003 004F         }
; 0003 0050     }
_0x6000F:
; 0003 0051     else
	RJMP _0x60010
_0x6000E:
; 0003 0052     {
; 0003 0053         if(dir_counter<1)
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x1)
	BRLO PC+2
	RJMP _0x60011
; 0003 0054         {
; 0003 0055             dir=1;      //change direction
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0003 0056             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ADIW R28,1
	RET
; 0003 0057         }
; 0003 0058     }
_0x60011:
_0x60010:
; 0003 0059     last_value=value;
	LDD  R6,Y+0
; 0003 005A     more_last_time=last_time;
	MOVW R12,R10
; 0003 005B     last_time=TCNT1;
	__INWR 10,11,44
; 0003 005C     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ADIW R28,1
	RET
; 0003 005D }
;
;void try_update()
; 0003 0060 {
_try_update:
; 0003 0061     if(enable_update&&enable_check)
	TST  R4
	BRNE PC+2
	RJMP _0x60013
	TST  R7
	BRNE PC+2
	RJMP _0x60013
	RJMP _0x60014
_0x60013:
	RJMP _0x60012
_0x60014:
; 0003 0062     {
; 0003 0063         enable_update=0;
	CLR  R4
; 0003 0064         if(check_inf(get_Y()))
	RCALL _get_Y
	ST   -Y,R30
	RCALL _check_inf
	SBIW R30,0
	BRNE PC+2
	RJMP _0x60015
; 0003 0065             set_new_swing();
	RCALL _set_new_swing
; 0003 0066     }
_0x60015:
; 0003 0067 }
_0x60012:
	RET
;
;interrupt [TIM1_COMPA] void period_overflow(void)
; 0003 006A {
_period_overflow:
	ST   -Y,R30
; 0003 006B     enable_check=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0003 006C }
	LD   R30,Y+
	RETI
;
;interrupt [TIM1_COMPB] void line_overflow(void)
; 0003 006F {
_line_overflow:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 0070     set_line();
	RCALL _set_line
; 0003 0071 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;interrupt [TIM0_OVF] void next_value(void)        //~120 OVF per second
; 0003 0074 {
_next_value:
	ST   -Y,R30
; 0003 0075     enable_update=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0003 0076 }
	LD   R30,Y+
	RETI
;
;interrupt [TIM1_OVF] void next_sym(void)        //~0.5 OVF per second
; 0003 0079 {
_next_sym:
	ST   -Y,R30
; 0003 007A     next_symbol=1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0003 007B }
	LD   R30,Y+
	RETI

	.ESEG
_x:
	.DW  0x0

	.DSEG
_dir_counter:
	.BYTE 0x1
_periods_arr:
	.BYTE 0x10
_period:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CBI  0x12,0
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	SBI  0x12,1
	__DELAY_USB 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	CBI  0x12,1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	__DELAY_USB 3
	IN   R30,0x10
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	RCALL _send_start
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _send_byte
	LDD  R30,Y+1
	ST   -Y,R30
	RJMP _send_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	LDS  R26,_period
	LDS  R27,_period+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	ADD  R30,R26
	ADC  R31,R27
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RJMP _set_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R31,0
	SUBI R30,LOW(-_Frame*2)
	SBCI R31,HIGH(-_Frame*2)
	LPM  R0,Z
	OUT  0x18,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDS  R30,_period
	LDS  R31,_period+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	MOVW R22,R30
	RCALL SUBOPT_0x5
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R26,_dir_counter
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
