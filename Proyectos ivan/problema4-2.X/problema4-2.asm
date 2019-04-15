  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
COMIENZO
    bsf STATUS,RP1
    bsf STATUS,RP0
    bcf ANSELH,5
    bsf TRISB,0
    movlw b'10010000'
    movwf 


