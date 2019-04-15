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
		
    PARPADEO1	bsf PORTD,4
		call RETARDO
		bcf PORTD,4
		call RETARDO
		goto LED
	
    PARPADEO2	bsf PORTD,4
		call RETARDO
		call RETARDO ;lo llamo dos veces seguidas para lograr un retardo de 1 segundo aprox.
		bcf PORTD,4
		call RETARDO
		call RETARDO
		goto LED
	
	
    INICIO
	    bsf STATUS,RP0
	    bcf STATUS,RP1 ; paso al banco 1 para trabajar con el registro TRISC
	    bcf TRISD,4 ; configuro como salida al bit 4 del puerto D
	    bcf STATUS,RP0 ;vuelvo al banco 0
	    bcf PORTD,0 ;me aseguro que el bit 4 del puerto D este en 0

    LED
	    btfsc PORTC,4 ;uso el bit 4 del puerto C como controlador. si es 1, se hace el parpadeo 1, sino, vuelve a verificar
	    goto PARPADEO1 ; se hace el parpadeo 1, el mas rapido
	    btfss PORTC,4 ; si el bit de control 7 esta en bajo, se accede al parpadeo 2, el mas rapido
	    goto PARPADEO2 ; se hace el parpadeo2, el mas lento
	    goto LED

	    end


