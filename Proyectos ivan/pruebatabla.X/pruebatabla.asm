 list p= 16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xE7E2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
numero equ 0x20
bcd equ 0x21
mult equ 0x22
limite equ 0x23
 
org 0x00
goto INICIO
org 0x04
goto INTERRUPCION

 INICIO
    clrf TMR0
    bsf STATUS,RP0 ;banco 1
    clrf TRISD ;puerto D como salida
    movlw b'11000111'
    movwf OPTION_REG ;configuro uso de timer 0
    movlw b'10100000'
    movwf INTCON ;configuro interrupciones
    bcf STATUS,RP0 ; banco 0
    movlw d'15'
    movwf mult
    movlw d'10'
    movwf limite
    clrf PORTD
    clrf numero

ESPERA
    nop
    goto ESPERA
    nop
    goto ESPERA

TABLA
    movf numero,0
    addwf PCL,1
    retlw b'00111111'
    retlw b'00000110'
    retlw b'01011011'
    retlw b'01001111'
    retlw b'01100110'
    retlw b'01101101'

    
INTERRUPCION
    decfsz mult
    goto FIN
    incf numero
    movf numero,0
    subwf limite,0
    btfsc STATUS,Z
    clrf numero
    movlw d'15'
    movwf mult
FIN
    call TABLA
    movwf PORTD
    bcf INTCON,T0IF
    retfie
    end
    