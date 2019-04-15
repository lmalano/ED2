  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
mult equ 0x20
salto equ 0x21
limite equ 0x22
unidad equ 0x23
decena equ 0x24 
centena equ 0x25
unmil equ 0x26
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    bsf STATUS,RP0 ; banco 1
    movlw b'11010101'
    movwf OPTION_REG ; configuro flancos y prescaler
    clrf TRISD ; puerto D como salida 
    clrf TRISC ;puerto c como salida
    bcf STATUS, RP0 ; banco 0
    movlw d'100'
    movwf TMR0 ; timer 0 comienza desde 100
    movlw d'20'
    movwf mult ; inicio el multiplicador con 20
    movlw d'4'
    movwf limite
    clrf PORTC
    clrf salto
    movlw b'01110111'
    movwf unidad
    movlw b'00111000'
    movwf decena
    movlw b'00111111'
    movwf centena
    movlw b'01110110'
    movwf unmil
    
    
RUTINA
    nop
    goto RUTINA
    
INTERRUPCION
    movlw d'61'
    movwf TMR0
    call CONTADOR
    movf salto,0
    addwf PCL
    goto B7
    goto B6
    goto B5
    goto B4
FIN
    bcf INTCON,T0IF
    retfie


CONTADOR
    incf salto,1
    movf limite,0
    xorwf salto,0
    btfsc STATUS,Z
    clrf salto
    return
    
B4
    clrf PORTC
    movf unmil,0
    movwf PORTD
    bsf PORTC,4
    goto FIN
    
B5
    clrf PORTC
    movf centena,0
    movwf PORTD
    bsf PORTC,5
    goto FIN
    
B6
    clrf PORTC
    movf unidad,0
    movwf PORTD
    bsf PORTC,6
    goto FIN
    
B7
    clrf PORTC
    movf decena,0
    movwf PORTD
    bsf PORTC,7
    goto FIN
    
end