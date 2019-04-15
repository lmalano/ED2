  list p= 16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xE7E2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 




org 0x00
goto INICIO
org 0x05


INICIO

bsf STATUS,RP1            ;voy al banco 3
bsf STATUS,RP0
clrf ANSELH		  ;seteo a los bits del puerto B como I/O digital 
movlw b'00000001'       ;seteo todos los bits del puerto B como salida, 
movwf TRISB             ; menos el RB0 que lo coloco como entrada
bcf OPTION_REG,0 ;habilito resistencias pull up
bsf WPUB,0 ;uso la resistencia de pull up de PORTB<0>
bcf STATUS,RP0
bcf STATUS,RP1


PUERTO_A4
btfsc PORTA,4 
goto SET3 
goto RESET3
 
SET3
bsf PORTB,3
goto PUERTO_B0
 
RESET3
bcf PORTB,3
goto PUERTO_B0   

PUERTO_B0
btfsc PORTB,0 
goto SET2
goto RESET2
 
SET2
bsf PORTB,2
goto PUERTO_A4
 
RESET2
bcf PORTB,2
goto PUERTO_A4   
 
end