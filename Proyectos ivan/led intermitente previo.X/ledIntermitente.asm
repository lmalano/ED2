  list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR
cont1 equ 0x20
cont2 equ 0x21
cont3 equ 0x22 


    ORG 0x00
    GOTO INICIO
    ORG 0X05


    RETARDO
	movlw d'2'
	movwf cont1
	movlw d'10'
	movwf cont2
	movlw d'40'
	movwf cont3
	BUCLE1
	    decfsz cont1
	    goto BUCLE1
	    movlw d'2'
	    movwf cont1
	    decfsz cont2
	    goto BUCLE1
	    movlw d'10'
	    movwf cont2
	    decfsz cont3
	    goto BUCLE1
	return
	
INICIO
	bsf STATUS,RP0
	bcf TRISB,0
	bcf STATUS,RP0
	
	LED
	    bsf PORTB,0
	    call RETARDO
	    bcf PORTB,0
	    call RETARDO
	    goto LED
	end