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
    bsf STATUS,RP0
    bsf STATUS,RP1 ; banco 3
    clrf ANSELH ; e/s digital portb
    movlw b'11110000'
    movwf TRISB ; entrada <7:4> / salida <3:0>
    bcf OPTION_REG,7 ;habilito permisos de pull up
    movlw b'10001000'
    movwf INTCON ;configuro interrupcion por cambios en portb y habilito interrupcion global
    bcf STATUS,RP1 ; banco 1
    movlw b'11111111'
    movwf IOCB
    movlw b'11110000'
    movwf WPUB ; resistencias de pull up bits <4:7>
    clrf TRISD ; portd como salida
    bcf STATUS,RP0 ; banco 0
    clrf PORTD
    clrf PORTB
    
NADA
    nop
    goto NADA
    nop
    goto NADA
    
INTERRUPCION
    movlw b'00001110'
    movwf PORTB ; comienzo a probar si en la columna del bit RB0 se pulso la tecla
BIT0
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto UNO
    btfss PORTB,5
    goto CUATRO
    btfss PORTB,6
    goto SIETE
    btfss PORTB,7
    goto AST
    
BIT1		    ; pruebo columna de RB1
    movlw b'00001101'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto DOS
    btfss PORTB,5
    goto CINCO
    btfss PORTB,6
    goto OCHO
    btfss PORTB,7
    goto CERO
    
BIT2
    movlw b'00001011'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TRES
    btfss PORTB,5
    goto SEIS
    btfss PORTB,6
    goto NUEVE
    btfss PORTB,7
    goto NUM
    
BIT3
    movlw b'00000111'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto UNO
    btfss PORTB,5
    goto CUATRO
    btfss PORTB,6
    goto OCHO
    btfss PORTB,7
    goto AST
    
NADAAPRETADO
    movlw b'00001111'
    movwf PORTB
    goto FIN

FIN
    bcf INTCON,RBIF
    retfie
    
UNO
    movf PORTB,0
    movwf PORTD
    goto FIN
    
DOS
    movf PORTB,0
    movwf PORTD
    goto FIN
    
TRES
    movf PORTB,0
    movwf PORTD
    goto FIN
    
CUATRO
    movf PORTB,0
    movwf PORTD
    goto FIN
    
CINCO
    movf PORTB,0
    movwf PORTD
    goto FIN
    
SEIS
    movf PORTB,0
    movwf PORTD
    goto FIN
    
SIETE
    movf PORTB,0
    movwf PORTD
    goto FIN
    
OCHO
    movf PORTB,0
    movwf PORTD
    goto FIN
    
NUEVE
    movf PORTB,0
    movwf PORTD
    goto FIN
    
CERO
    movf PORTB,0
    movwf PORTD
    goto FIN
    
AST
    movf PORTB,0
    movwf PORTD
    goto FIN
    
NUM
    movf PORTB,0
    movwf PORTD
    goto FIN
    
end


