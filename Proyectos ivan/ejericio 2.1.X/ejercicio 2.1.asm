list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

A1 equ 0x20
A2 equ 0x21
Resp equ 0x22
				    
    ORG 0x00
    GOTO INICIO
    ORG 0X05
  
SUMA
    
    movf A2,0
    addwf A1,0
    return
    
INICIO

    movlw d'19'
    movwf A1
    movlw d'23'
    movwf A2
    
    movf A2,0
    subwf A1,0
    btfsc STATUS,2
    movwf Resp
    btfss STATUS,0
    call SUMA
    movwf Resp
    end

