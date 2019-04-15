 list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

suma1 equ 0x20
suma2 equ 0x21
resultado equ 0x22
carry equ 0x23

    ORG 0x00
    GOTO INICIO
    ORG 0X05

INICIO
movlw b'11111111'
movwf suma1
movlw b'00001011'
movwf suma2
addwf suma1,0
movwf resultado
btfsc STATUS,0
incf carry,1

    
    end


