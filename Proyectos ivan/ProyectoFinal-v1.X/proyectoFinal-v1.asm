  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
;CONSTANTES
carga equ d'6'
clk equ d'1'
dato equ d'2'
latch equ d'3'
 
 
;REGISTROS
contador equ 0x20
mult equ 0x21
salto equ 0x23
char1 equ 0x24
char2 equ 0x25
char3 equ 0x26
char4 equ 0x27
char5 equ 0x28
contCargaFila equ 0x29
aux equ 0x2A
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    movlw carga
    movwf TMR0 ; cargo timer con 6
    bsf STATUS,RP0 ; banco 1
    movlw b'11010001'
    movwf OPTION_REG ; configuro flancos y prescaler (x4)
    clrf TRISD ; puerto D como salida
    clrf TRISC ; puerto C como salida
    bcf STATUS, RP0 ; banco 0
    movlw d'6'
    movwf contCargaFila
    ;movlw d'2'
    ;movwf mult ; inicio el multiplicador con 15
    ;bsf PORTD,1 ; en alto el bit de datos
    ;bcf PORTD,0 ; en bajo el estado inicial del clock
    clrf salto
    movlw "F"
    movwf char1
    movlw "H"
    movwf char2
    movlw "K"
    movwf char3
    movlw "9"
    movwf char4
    movlw "P"
    movwf char5
    movlw d'50'
    movwf mult
    
PRINCIPAL
    nop
    goto PRINCIPAL
    
INTERRUPCION
    decfsz mult,1
    goto FIN8
    call CARGADATOS ; cargo los datos en los 4 registros de desplazamiento
FIN8
    bcf INTCON,T0IF
    retfie
    
    
#include "corrimientoBit.inc"
end