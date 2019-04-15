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
 
 org 0x00
 goto COMIENZO
 org 0x04
 goto INTERRUPCION


COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    bsf STATUS,RP0 ; banco 1
    movlw b'11010111'
    movwf OPTION_REG ; configuro flancos y prescaler
    clrf TRISD ; puerto D como salida (solo usamos bit 4)
    bcf STATUS, RP0 ; banco 0
    clrf TMR0 ; timer 0 comienza desde cero
    movlw d'15'
    movwf mult ; inicio el multiplicador con 15
    clrf PORTD
NADA
    nop
    goto NADA
    nop
    goto NADA
    
INTERRUPCION
    movwf w_temp
    swapf STATUS, 0
    movwf status_temp ;en estas tres lineas realizamos el guardado de contexto
    movlw 0xff 
    decfsz mult,1
    goto FIN
    xorwf PORTD,1 ;enciende o apaga el led
    movlw d'15'
    movwf mult
FIN
    bcf INTCON,T0IF ;bajo la bandera de interrupcion
    swapf status_temp,0
    movwf STATUS
    swapf w_temp,1
    swapf w_temp,0 ; en las ultimas 4 instrucciones recupero contexto
    retfie
end
    
    