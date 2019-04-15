 list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
				    
				    
cont1 equ 0x20
cont2 equ 0x21
cont3 equ 0x22 


    ORG 0x00
    GOTO INICIO
    ORG 0X05
    
RETARDO ;me da un retardo de aproximadamente 0.5 segundos
	movlw  d'3'
	movwf  cont3
BUCLE3  movlw  d'250'
	movwf  cont2
BUCLE2  movlw  d'250'
	movwf  cont1
BUCLE1  decfsz cont1,1
	goto   BUCLE1
	decfsz cont2
	goto   BUCLE2
	decfsz cont3
	goto BUCLE3
	return

SHOW_1
	movlw b'00000000'
	movwf PORTD
	call RETARDO
	movlw b'00010000'
	movwf PORTD
	call RETARDO
	movlw b'00100000'
	movwf PORTD
	call RETARDO
	movlw b'01000000'
	movwf PORTD
	call RETARDO
	movlw b'10000000'
	movwf PORTD
	call RETARDO
	movlw b'01000000'
	movwf PORTD
	call RETARDO
	movlw b'00100000'
	movwf PORTD
	call RETARDO
	movlw b'00010000'
	movwf PORTD
	call RETARDO
	movlw b'00000000'
	movwf PORTD
	call RETARDO
	movlw b'11110000'
	movwf PORTD
	call RETARDO
	movlw b'00000000'
	movwf PORTD
	call RETARDO
	movlw b'11110000'
	movwf PORTD
	call RETARDO
	movlw b'00000000'
	movwf PORTD
	call RETARDO
	return
	
SHOW_2
	movlw b'00000000'
	movwf PORTD
	call RETARDO
	movlw b'00010000'
	movwf PORTD
	call RETARDO
	movlw b'00110000'
	movwf PORTD
	call RETARDO
	movlw b'01110000'
	movwf PORTD
	call RETARDO
	movlw b'11110000'
	movwf PORTD
	call RETARDO
	movlw b'11100000'
	movwf PORTD
	call RETARDO
	movlw b'11000000'
	movwf PORTD
	call RETARDO
	movlw b'10000000'
	movwf PORTD
	call RETARDO
	return
    
    
INICIO 
    bcf STATUS,RP1
    bsf STATUS,RP0
    clrf TRISD
    
LEDS
    btfss PORTC,4
    goto SHOW_1
    btfsc PORTC,4
    goto SHOW_2
    goto LEDS
    end

