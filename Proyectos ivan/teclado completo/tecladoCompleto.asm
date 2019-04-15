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
N equ 0x27
M equ 0x28
 
 
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
    movlw b'01010101'
    movwf OPTION_REG ; habilito permisos de pull up, selecciono reloj interno para TMR0 y prescaler de 32
    ;bcf OPTION_REG,7 ;habilito permisos de pull up
    movlw b'10101000'
    movwf INTCON ;configuro interrupcion por cambios en portb y timer 0, y habilito interrupcion global
    bcf STATUS,RP1 ; banco 1
    movlw b'11111111'
    movwf IOCB
    movlw b'11110000'
    movwf WPUB ; resistencias de pull up bits <4:7>
    clrf TRISD ; portd como salida
    clrf PORTC ; portc como salida (usado para el multiplexado de los displays)
    bcf STATUS,RP0 ; banco 0
    clrf PORTD
    clrf PORTB
    movlw d'100'
    movwf TMR0 ; timer 0 comienza desde 100
    movlw d'4'
    movwf limite
    clrf unidad
    clrf decena
    clrf centena
    clrf unmil
    clrf salto
    
PRINCIPAL
    nop
    goto PRINCIPAL
    
INTERRUPCION
    btfsc INTCON,RBIF ;¿fue una intrerrupcion causada por el teclado?
    goto TECLADO ; Si, fue una interrupcion de teclado
    goto REFRESCO ;No, fue del timer 0
    
TECLADO
    call RETARDO ;llamo a un retardo de 20ms por software para eliminar rebotes
    movlw d'100'
    movwf TMR0

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
    
BIT2		    ; pruebo bit de la columna RB2
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
    
BIT3		    ; pruebo bit de la columna RB3
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
    clrf PORTB ; dejo el puerto B tal cual quedo al incicio de la ejecucion (los 4 bits mas altos no son afectados por el clrf, quedando en alto por ser de entrada)
    bcf INTCON,RBIF
    bcf INTCON,T0IF ; se baja la bandera de T0IF porque dentro de esta rutina es muy probable que el timer 0 desborde
    retfie
    

UNO
    call MOVERNUM
    movlw d'1'
    call TABLA
    movwf unidad
    goto FIN
    
DOS
    call MOVERNUM
    movlw d'2'
    call TABLA
    movwf unidad
    goto FIN
    
TRES
    call MOVERNUM
    movlw d'3'
    call TABLA
    movwf unidad
    goto FIN
    
CUATRO
    call MOVERNUM
    movlw d'4'
    call TABLA
    movwf unidad
    goto FIN
    
CINCO
    call MOVERNUM
    movlw d'5'
    call TABLA
    movwf unidad
    goto FIN
    
SEIS
    call MOVERNUM
    movlw d'6'
    call TABLA
    movwf unidad
    goto FIN
    
SIETE
    call MOVERNUM
    movlw d'7'
    call TABLA
    movwf unidad
    goto FIN
    
OCHO
    call MOVERNUM
    movlw d'8'
    call TABLA
    movwf unidad
    goto FIN
    
NUEVE
    call MOVERNUM
    movlw d'9'
    call TABLA
    movwf unidad
    goto FIN
    
CERO
    call MOVERNUM
    movlw d'0'
    call TABLA
    movwf unidad
    goto FIN
    
AST
    call MOVERNUM
    movlw d'0'
    call TABLA
    movwf unidad
    goto FIN
    
NUM
    call MOVERNUM
    movlw d'0'
    call TABLA
    movwf unidad
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
    
RETARDO
    movlw d'26'
    movwf M
BUCLE2
    movlw d'255'
    movwf N
BUCLE1
    decfsz N,1
    goto BUCLE1
    decfsz M,1
    goto BUCLE2
    return
    
MOVERNUM
    movf centena,0
    movwf unmil ;muevo el digito de la centena al de la unmil
    movf decena,0
    movwf centena ;muevo el digito de la decena al de la centena
    movf unidad,0
    movwf decena ;muevo el digito de la unidad al de la decena
    return
    
REFRESCO
    movlw d'100'
    movwf TMR0 ;vuelvo a inicializar timer 0 con 100
    call CONTADOR
    movf salto,0
    addwf PCL
    goto B7
    goto B6
    goto B5
    goto B4
FIN2
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
    goto FIN2
    
B5
    clrf PORTC
    movf centena,0
    movwf PORTD
    bsf PORTC,5
    goto FIN2
    
B6
    clrf PORTC
    movf unidad,0
    movwf PORTD
    bsf PORTC,6
    goto FIN2
    
B7
    clrf PORTC
    movf decena,0
    movwf PORTD
    bsf PORTC,7
    goto FIN2
    
end