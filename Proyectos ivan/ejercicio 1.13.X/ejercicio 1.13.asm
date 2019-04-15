   list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

iter1 equ 0x20
iter2 equ 0x21
iter3 equ 0x22
				    
    ORG 0x00
    GOTO INICIO
    ORG 0X05
INICIO
   
    movlw d'250'
    movwf iter1
    movlw d'100'
    movwf iter2
    movlw d'40'
    movwf iter3
    
    BUCLE1
    decfsz iter1
    goto BUCLE1
    movlw d'250'
    movwf iter1
    decfsz iter2
    goto BUCLE1
    movlw d'100'
    movwf iter2
    decfsz iter3
    goto BUCLE1
    end
    
    
    


