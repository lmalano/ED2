    list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

AL equ 0x21
AH equ 0x20
BL equ 0x23
BH equ 0x22
ResL equ 0x24
ResH equ 0x25
Carry equ 0x26
 
    ORG 0x00
    GOTO INICIO
    ORG 0X05

INICIO
    
    movlw b'10011100'
    movwf AL
    movlw b'00001101'
    movwf AH
    movlw b'11011000'
    movwf BL
    movlw b'00111101'
    movwf BH
    
    movf AL,0
    addwf BL,0
    btfsc STATUS,0
    incf BH,1
    movwf ResL
    movf BH,0
    addwf AH,0
    movwf ResH
    
    end
