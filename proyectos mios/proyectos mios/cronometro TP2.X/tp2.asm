  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

unidad equ 0x20
decena equ 0x21
centena equ 0x22
unmil equ 0x23
decmil equ 0x29
cenmil equ 0x30 
salto equ 0x24
mult equ 0x25
bandera equ 0x26
N equ 0x27
M equ 0x28
 
org 0x00
goto COMIENZO
org 0x04; cuando interrumpe va a esta direccion
goto INTERRUPCION
 
 
COMIENZO
    bsf STATUS,RP0 ; banco 1
    clrf TRISD ; portd como salida
    clrf TRISC
    movlw b'00000011'
    movwf OPTION_REG
    movlw b'10110000'
    movwf INTCON ;habilito interrupciones
    bsf STATUS,RP1 ;banco 3
    clrf ANSELH ; e/s digital en puerto b
    bcf STATUS,RP1
    bcf STATUS,RP0 ;banco 0
    movlw d'100'
    movwf TMR0 ;inicializo timer 0 (5ms)
    clrf unidad
    clrf decena
    clrf centena
    clrf unmil
    clrf decmil
    clrf cenmil
    
    clrf salto	     ;indica el nro de display a habilitar
    clrf bandera
    movlw d'4'; cada 4 interr hace algo; si la interrupcion es cada 5ms , esto lo multiplica x 4 20ms
    movwf mult

PRINCIPAL
    nop
    goto PRINCIPAL
    
INTERRUPCION
    btfsc INTCON,INTF ; ¿fue interrupcion externa?
    goto EXTERNA ;si
    goto TIMER ;no
    
TIMER
    movlw d'100'
    movwf TMR0 ;inicializo timer 0
    call REFRESCO ; actualiza los displays con los nuevos valores
    decfsz mult,1; salta si es 0
    goto FIN
    btfss bandera,0 ;¿se activo el cronometro?
    goto FIN ;no, se detiene o no comienza la cuenta
    call INCREMENTO ; bandera en alto: incrementa los digitos del cronometro
FIN
    call CAMBIOSALTO ; cambia el salto para habilitar el display siguiente
    bcf INTCON,T0IF; bajo bandera del timer
    retfie; return con habilitacion de interr grales
    
INCREMENTO
    call INCUNIDAD
    btfsc STATUS,Z
    call INCDECENA
    btfsc STATUS,Z
    call INCCENTENA
    btfsc STATUS,Z
    call INCUNMIL
    btfsc STATUS,Z
    call INCDECMIL
    btfsc STATUS,Z
    call INCCENMIL
    
    movlw d'4'
    movwf mult
    return
    
TABLA
    addwf PCL,1; INVERTIR
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
    
REFRESCO
    movf salto,0
    addwf PCL,1
    goto D1 ; habilito display 1 (unidad)
    goto D2 ; habilito display 2 (decena)
    goto D3 ; habilito display 3 (centena)
    goto D4 ; habilito display 4 (unmil)
    goto D5 ; habilito display 5 (decmil)
    goto D6 ; habilito display 6 (cenmil)
D1
    clrf PORTC;  deshabilita display (todos)
    movf unidad ;cargo en w lo q esta en el reg unidad
    call TABLA ;llama tabla del nro
    movwf PORTD ; muestro nro
    bsf PORTC,6 ; habilito el display INVERTIR --> bcf
    return
    
D2
    clrf PORTC
    movf decena,0
    call TABLA
    movwf PORTD
    bsf PORTC,7
    return
    
D3
    clrf PORTC
    movf centena,0
    call TABLA
    movwf PORTD
    bsf PORTC,5
    return
    
D4
    clrf PORTC
    movf unmil,0
    call TABLA
    movwf PORTD
    bsf PORTC,4
    return
    
D5
    clrf PORTC
    movf unmil,0
    call TABLA
    movwf PORTD
    bsf PORTC,4;verrrrrrrrrr
    return
    
D6
    clrf PORTC
    movf unmil,0
    call TABLA
    movwf PORTD
    bsf PORTC,4; verrrrr
    return
  
    
    
    
CAMBIOSALTO; habilita prox display
    incf salto,1; incre salto para q en  la prox interr m habilite el sig display
    movlw d'4'; cambiar x el 6
    xorwf salto,0 ; verifi si llego al maximo
    btfsc STATUS,Z; es cero?
    clrf salto; si no es cero salta
    return
    
INCUNIDAD
    incf unidad,1
    movlw d'10'
    xorwf unidad,0
    btfsc STATUS,Z
    clrf unidad
    return
    
INCDECENA
    incf decena,1
    movlw d'10'
    xorwf decena,0
    btfsc STATUS,Z
    clrf decena
    return
    
INCCENTENA
    incf centena,1
    movlw d'10'
    xorwf centena,0
    btfsc STATUS,Z
    clrf centena
    return
    
INCUNMIL
    incf unmil,1
    movlw d'6'
    xorwf unmil,0
    btfsc STATUS,Z
    clrf unmil
    return
    
   INCDECMIL
    incf unmil,1
    movlw d'6'
    xorwf unmil,0
    btfsc STATUS,Z
    clrf decmil
    return 
    
   INCCENMIL
    incf unmil,1
    movlw d'6'
    xorwf unmil,0
    btfsc STATUS,Z
    clrf cenmil
    return 
    
EXTERNA
    call RETARDO ;retardo de aprox 5ms
    btfsc PORTB,0
    goto FIN2
    call RETARDO
    btfsc PORTB,0
    goto FIN2; repite en caso si hay ruido
    movlw b'00000001'
    xorwf bandera,1
    btfss bandera,0 ; si el bit 0 esta en bajo, se detiene la cuenta pero no borramos nada. si esta en alto, borramos todo y comenzamos a contar
    goto FIN2
    clrf unidad
    clrf decena
    clrf centena
    clrf unmil;agregar dos lineas mas x los 2 sidplay mas
    clrf decmil
    clrf cenmil
FIN2
    bcf INTCON,INTF
    retfie
    
RETARDO
    movlw d'9'
    movwf M
BUCLE2
    movlw d'180'
    movwf N
BUCLE1
    decfsz N,1
    goto BUCLE1
    decfsz M,1
    goto BUCLE2
    return
    
end



