  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
;CONSTANTES

dato equ d'2'
clk equ d'1'
latch equ d'3'
caracteres equ d'5'
anchoChar equ d'6'
carga equ d'6'

 
 
;REGISTROS
 
numChar equ 0x20
filAux equ 0x21
numBits equ 0x22
numFila equ 0x23
char5 equ 0x24
char4 equ 0x25
char3 equ 0x26
char2 equ 0x27
char1 equ 0x28
mult equ 0x29


 
org 0x00
    goto COMIENZO
org 0x04
    goto INTERRUPCIONES
    
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
    movlw 0xFF
    movwf PORTD ; todas las salidas en alto para inhabilitar el display
    clrf PORTC ; todas las salidas en bajo por defecto
    movlw "2"
    movwf char5
    movlw "7"
    movwf char4
    movlw "5"
    movwf char3
    movlw "3"
    movwf char2
    movlw "0"
    movwf char1
    movlw caracteres
    movwf numChar
    clrf filAux
    clrf numFila
    movlw anchoChar
    movwf numBits
    movlw d'20'
    movwf mult
    
ESPERA
    nop
    goto ESPERA
    
INTERRUPCIONES
    movlw carga
    movwf TMR0
    movlw 0x24
    movwf FSR
    call CARGARDATOS
    bcf INTCON,T0IF
    retfie

#include "cargaDatosAux.inc"

end