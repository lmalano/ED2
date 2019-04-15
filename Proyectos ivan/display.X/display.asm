list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

contador1 equ 0x20
contador2 equ 0x21
contador3 equ 0x22
				    
    ORG 0x00
    GOTO INICIO
    ORG 0X05
    
    
    RETARDO
    movlw d'250'
    movwf contador1
    movlw d'100'
    movwf contador2
    movlw d'40'
    movwf contador3
    BUCLE1
	decfsz contador1
	goto BUCLE1
    BUCLE2
	movlw d'2'
	movwf contador1
	decfsz contador2
	goto BUCLE1
    BUCLE3
	movlw d'1'
	movwf contador2
	decfsz contador3
	goto BUCLE1
    return
	
INICIO	
    bsf STATUS,RP0
    movlw b'00000000'
    movwf TRISB
    bcf STATUS,RP0
	
	
CUENTA
	movlw b'00000000'
	movwf PORTB
	call RETARDO
	movlw b'00000001'
	movwf PORTB
	call RETARDO
	movlw b'00000010'
	movwf PORTB
	call RETARDO
	movlw b'00000011'
	movwf PORTB
	call RETARDO
	movlw b'00000100'
	movwf PORTB
	call RETARDO
	movlw b'00000101'
	movwf PORTB
	call RETARDO
	goto CUENTA
	end