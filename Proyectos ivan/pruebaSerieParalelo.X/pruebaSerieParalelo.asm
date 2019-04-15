  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
contador equ 0x20
mult equ 0x21
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
 
COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    bsf STATUS,RP0 ; banco 1
    movlw b'11010000'
    movwf OPTION_REG ; configuro flancos y prescaler
    clrf TRISD ; puerto D como salida
    ;clrf TRISC
    bcf STATUS, RP0 ; banco 0
    clrf TMR0 ; timer 0 comienza desde cero
    movlw d'2'
    movwf mult ; inicio el multiplicador con 15
    bsf PORTD,1 ; en alto el bit de datos
    bcf PORTD,0 ; en bajo el estado inicial del clock
    
PRINCIPAL
    nop
    goto PRINCIPAL
    
INTERRUPCION
    decfsz mult
    goto FIN1
    ;btfsc enviodato,0
    movlw d'2'
    movwf mult
    call ENVIARDATO
    goto MOVERDATO
    
FIN1
    bcf INTCON,T0IF
    retfie

ENVIARDATO
    movlw d'0'
    xorwf contador
    btfsc STATUS,Z
    goto DATOALTO
    goto DATOBAJO
    
DATOALTO
    bsf PORTD,1
    return
    
DATOBAJO
    bcf PORTD,1
    return

MOVERDATO
    movlw d'1'
    xorwf PORTD,1
    btfsc PORTD,0 ;el clock esta en alto?
    call INCCONTADOR ;si
    goto FIN1
    
INCCONTADOR
    incf contador,1
    movlw d'32'
    xorwf contador,0
    btfsc STATUS,Z
    clrf contador
    return
    
end   
    
    