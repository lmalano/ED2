    list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

A equ 0x20
Be equ 0x21
Ce equ 0x22
Resultado equ 0x23
 
 
    ORG 0x00
    GOTO INICIO
    ORG 0X05

INICIO
    
    movlw b'00001010'
    movwf A
    movlw b'00000110'
    movwf Be
    movlw b'00001001'
    movwf Ce
    
    
    movf A,0
    addwf Be,1
    movf Ce,0
    subwf Be,0
    movwf Resultado
    
    end