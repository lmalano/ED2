   list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

SUMA1       EQU 0X21        ;CANTIDAD DE ITERACIONES DE CADA BUCLE
SUMA2       EQU 0x22        ;VARIABLES QUE IRÉ INCREMENTANDO DENTRO DE CBUCLE
RESULTADO   EQU 0X23
ACARREO     EQU 0X24

    ORG 0x00
    GOTO INICIO
    ORG 0X05
INICIO
    
    movf SUMA1,0
    addwf SUMA2,0
    movwf RESULTADO
    btfsc STATUS,0
    incf ACARREO,1
    
    END
    