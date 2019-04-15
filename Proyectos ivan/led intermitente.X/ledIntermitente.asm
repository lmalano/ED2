  list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR
; CONFIG1
; __config 0xFFE2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
				    
				    
cont1 equ 0x20
cont2 equ 0x21
cont3 equ 0x22 


    ORG 0x00
    GOTO INICIO
    ORG 0X05


    RETARDO1 ;me da un retardo mas lento
	movlw d'250'
	movwf cont1
	movlw d'10'
	movwf cont2
	movlw d'40'
	movwf cont3
	BUCLE1
	    decfsz cont1
	    goto BUCLE1
	    movlw d'250'
	    movwf cont1
	    decfsz cont2
	    goto BUCLE1
	    movlw d'10'
	    movwf cont2
	    decfsz cont3
	    goto BUCLE1
	return
	
    RETARDO2 ; me da un retardo mas rapido
	movlw d'25'
	movwf cont1
	movlw d'5'
	movwf cont2
	movlw d'40'
	movwf cont3
	BUCLE2
	    decfsz cont1
	    goto BUCLE2
	    movlw d'25'
	    movwf cont1
	    decfsz cont2
	    goto BUCLE2
	    movlw d'5'
	    movwf cont2
	    decfsz cont3
	    goto BUCLE2
	return
	
    PARPADEO1
	bsf PORTC,0
	call RETARDO1
	bcf PORTC,0
	call RETARDO1
	goto LED
	
    PARPADEO2
	bsf PORTC,0
	call RETARDO2
	bcf PORTC,0
	call RETARDO2
	goto LED
	
	
INICIO
	bsf STATUS,RP0
	bcf STATUS,RP1 ; paso al banco 1 para trabajar con el registro TRISC
	bcf TRISC,0 ; configuro como salida al bit 0 del puerto C
	bcf STATUS,RP0 ;vuelvo al banco 0
	bcf PORTC,0 ;me aseguro que el bit 0 del puerto C este en 0
	
	LED
	    btfsc PORTC,7 ;uso el bit 7 del puerto C como controlador. si es 1, se hace el parpadeo 1, sino, vuelve a verificar
	    goto PARPADEO1 ; se hace el parpadeo 1, el mas lento
	    btfss PORTC,7 ; si el bit de control 7 esta en bajo, se accede al parpadeo 2, el mas rapido
	    goto PARPADEO2 ; se hace el parpadeo2, el mas rapido
	    goto LED
	
	    end