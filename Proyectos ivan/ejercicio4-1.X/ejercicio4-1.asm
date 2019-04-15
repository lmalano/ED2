  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
w_temp equ 0x70
status_temp equ 0x71
mult equ 0x20
limite equ 0x21
contador equ 0x22
bcd equ 0x23

org 0x00
goto COMIENZO
org 0x04
goto ONOFF
 
COMIENZO
    movlw b'10010000'
    movwf INTCON
    bsf STATUS,RP0
    bsf STATUS,RP1
    bcf ANSELH,4
    bsf TRISB,0
    bcf STATUS,RP1
    clrf TRISD
    bcf STATUS,RP0
    movlw d'1'
    movwf contador
    clrf PORTD
    
CONTEO
    btfsc PORTA,4
    goto INCREMENTO
    goto CODIFICACION
    
INCREMENTO
    incf contador,1
    movf contador,0
    sublw d'7'
    btfss STATUS,Z
    goto CONTEO
    movlw d'1'
    movwf contador
    goto CONTEO
    
CODIFICACION
    call TABLA
    movwf bcd
    goto CONTEO
    
TABLA
    movf contador,0
    addwf PCL,1
    retlw b'00111111'
    retlw b'00000110'
    retlw b'01011011'
    retlw b'01001111'
    retlw b'01100110'
    retlw b'01101101'
    retlw b'01111101'
    retlw b'00000111'
    retlw b'01111111'
    retlw b'01101111'
    
ONOFF
    movf w_temp
    swapf STATUS,0
    movwf status_temp
    bcf INTCON,1
    movf bcd,0
    xorwf PORTD,1
    swapf status_temp,0
    movwf STATUS
    swapf w_temp,1
    swapf w_temp,0
    retfie
    
    end


