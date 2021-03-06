  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 

retardo equ 0x20 
unidad equ 0x21
decena equ 0x22
centena equ 0x23
unmil equ 0x24
salto equ 0x25
aux equ 0x26
 
org 0x00
goto COMIENZO
org 0x04
goto INTERRUPCION
 
COMIENZO
    movlw b'01101001'
    movwf ADCON0 ; fosc/8 - AN10 - conversion detenida - conversor activado
    movlw b'11100000'
    movwf INTCON ; habilito interrupciones de perifericos y timer0
    movlw d'100'
    movwf TMR0 ;inicializo timer 0 (2.5ms)
    bsf STATUS,RP0 ; banco 1
    movlw b'11010011'
    movwf OPTION_REG
    movlw b'00000000'
    movwf ADCON1 ; uso referencia interna, formato justificado a la izquierda
    bsf PIE1,6 ; habilito interrupcion de conversor a/d (interrumpirá cada vez que una conversion se termine de realizar
    clrf TRISD ; portd como salida
    clrf TRISC
    bcf STATUS,RP0 ; banco 0
    movlw d'20'
    movwf retardo
    clrf unidad
    clrf decena
    clrf centena
    clrf unmil
    clrf salto
    
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
    btfsc INTCON,T0IF ;interrupcion por timer0?
    goto TIMER ; si
    goto CONVERSOR
    
CONVERSOR ; comienzo de interrupcion de conversion a/d
    movf ADRESH,0
    movwf aux
    clrf unidad
    clrf decena
    clrf centena
    clrf unmil
    
CARGABCD
    movlw d'0'
    xorwf aux
    btfsc STATUS,Z ;aux llego a cero?
    goto FIN1 ;si
    decf aux,1 ;no, decremento una vez
    call INCUNIDAD
    btfsc STATUS,Z
    call INCDECENA
    btfsc STATUS,Z
    call INCCENTENA
    btfsc STATUS,Z
    call INCUNMIL
    goto CARGABCD
FIN1
    bcf PIR1,6 ;bajo bandera de interrupcion
    retfie
    
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

    
TIMER ; comienzo de interrupcion de timer0
    movlw d'100'
    movwf TMR0 ;inicializo timer 0
    call REFRESCO ; actualiza los displays con los nuevos valores
    call CAMBIOSALTO ; cambia el salto para habilitar el display siguiente
    bcf INTCON,T0IF
    retfie
    
REFRESCO
    movf salto,0
    addwf PCL,1
    goto D1 ; habilito display 1 (unidad)
    goto D2 ; habilito display 2 (decena)
    goto D3 ; habilito display 3 (centena)
    goto D4 ; habilito display 4 (unmil)
    
D1
    clrf PORTC
    movf unidad,0
    call TABLA
    movwf PORTD
    bsf PORTC,6
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
    
CAMBIOSALTO
    incf salto,1
    movlw d'4'
    xorwf salto,0
    btfsc STATUS,Z
    clrf salto
    return
    
TABLA
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
    


