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
 numero equ 0x21
 unidad equ 0x22
 decena equ 0x23
 undec equ 0x24
 
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
    clrf TRISC
    bcf STATUS,RP0 ; banco 0
    clrf PORTD
    clrf PORTB
    bcf undec,0 ; bandera comenzara guardando en unidad
    movlw d'0'
    call TABLA
    movwf unidad
    
    
PRINCIPAL
    movf unidad,0
    movwf PORTD
    goto PRINCIPAL

    
    
INTERRUPCION
   ; movlw b'00001110'
   ; movwf PORTB ; comienzo a probar si en la columna del bit RB0 se pulso la tecla
;BIT0
 ;   btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
  ;  goto UNO
   ; btfss PORTB,5
   ; goto CUATRO
   ; btfss PORTB,6
   ; goto SIETE
   ; btfss PORTB,7
   ; goto AST
    
BIT1		    ; pruebo columna de RB1
    movlw b'00001101'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TRES
    btfss PORTB,5
    goto SEIS
    btfss PORTB,6
    goto NUEVE
    btfss PORTB,7
    goto NUM
    
BIT2
    movlw b'00001011'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto DOS
    btfss PORTB,5
    goto CINCO
    btfss PORTB,6
    goto OCHO
    btfss PORTB,7
    goto CERO
    
BIT3
    movlw b'00000111'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto UNO
    btfss PORTB,5
    goto CUATRO
    btfss PORTB,6
    goto SIETE
    btfss PORTB,7
    goto AST
    
NADAAPRETADO
    movlw b'00001111'
    movwf PORTB
    goto FIN

FIN
    clrf PORTB
    ;comf undec,1 ; cambia la bandera en bit 0 para ver si se guarda en unidad o decena
    bcf INTCON,RBIF
    retfie
    
UNO
    movlw d'1'
    call TABLA
    movwf unidad
    goto FIN
    
DOS
    movlw d'2'
    call TABLA
    movwf PORTD
    goto FIN
    
TRES
    movlw d'3'
    call TABLA
    movwf PORTD
    goto FIN
    
CUATRO
    movlw d'4'
    call TABLA
    movwf PORTD
    goto FIN
    
CINCO
    movlw d'5'
    call TABLA
    movwf PORTD
    goto FIN
    
SEIS
    movlw d'6'
    call TABLA
    movwf PORTD
    goto FIN
    
SIETE
    movlw d'7'
    call TABLA
    movwf PORTD
    goto FIN
    
OCHO
    movlw d'8'
    call TABLA
    movwf PORTD
    goto FIN
    
NUEVE
    movlw d'9'
    call TABLA
    movwf PORTD
    goto FIN
    
CERO
    movlw d'0'
    call TABLA
    movwf PORTD
    goto FIN
    
AST
    movlw d'0'
    call TABLA
    movwf PORTD
    goto FIN
    
NUM
    movlw d'0'
    call TABLA
    movwf PORTD
    goto FIN
    
TABLA
    ;movf contador,0
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

    end

