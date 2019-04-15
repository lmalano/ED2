  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 

retardo equ 0x20 
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
COMIENZO
    movlw b'01101001'
    movwf ADCON0 ; fosc/8 - AN10 - conversion detenida - conversor activado
    movlw b'11000000'
    movwf INTCON ; habilito interrupciones de perifericos
    bsf STATUS,RP0 ; banco 1
    movlw b'00000000'
    movwf ADCON1 ; uso referencia interna, formato justificado a la izquierda
    bsf PIE1,6 ; habilito interrupcion de conversor a/d (interrumpirá cada vez que una conversion se termine de realizar
    clrf TRISD ; portd como salida
    bcf STATUS,RP0 ; banco 0
    movlw d'20'
    movwf retardo
    
PRINCIPAL
    call RETARDO ; retardo de 20 uS
    bsf ADCON0,1 ; go/done activo (comienzo conversion)
    goto PRINCIPAL
    
RETARDO
    decfsz retardo,1
    goto RETARDO
    movlw d'20'
    movwf retardo
    return
    
INTERRUPCION
    movf ADRESH,0
    movwf PORTD ; muestro en portd el valor puro convertido
    bcf PIR1,6 ; bajo bandera de interrupcion
    retfie
    
end
    