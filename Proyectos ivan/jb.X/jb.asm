list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
    __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

	      
Contador EQU 0X21

              ORG  0X00

              GOTO  INICIO

              ORG  0X04

              

INICIO
	      swapf PORTB,1
	      call RUTINA1
	      swapf PORTB,1
	      goto INICIO
	      
RUTINA1
	      nop
	      nop
	      call RUTINA2
	      nop
	      return

RUTINA2
	      nop
	      nop
	      return
	      end