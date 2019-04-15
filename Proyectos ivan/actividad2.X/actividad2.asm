list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

total equ 0x21
ciclosb equ 0x22
ciclosr equ 0x23
				    
    ORG 0x00
    GOTO INICIO
    ORG 0X05
    
    INICIO
    
    movlw b'01101001'
    movwf 0x24
    movlw b'10000111'
    movwf 0x25
    movlw b'01111001'
    movwf 0x26
    movlw b'11101000'
    movwf 0x27
    movlw b'11111001'
    movwf 0x28
    movlw 0x24
    movwf FSR
    clrf total
    movlw d'5'
    movwf ciclosr
    
BUCLE1
	movlw d'8'
	movwf ciclosb
BUCLE2
	btfss INDF,7
	incf total,1
	rlf INDF,1
	decfsz ciclosb
	goto BUCLE2
	incf FSR,1
	decfsz ciclosr
	goto BUCLE1
	end



