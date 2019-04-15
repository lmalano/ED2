 list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

suma1 equ 0x21
suma2 equ 0x22
resultado equ 0x23
carry equ 0x24

    ORG 0x00
    GOTO INICIO
    ORG 0X05

    movlw d'5'
    movwf suma1
    movlw d'7'
    movwf suma2
    addwf suma1,0
    movwf resultado
    btfsc status,0
    incf carry
    
    end
    
    

