    list P=16f887 ;Comando que indica el Pic usado
    #include "p16f887.inc"          ;inclusión de archivo con definiciones
                                    ;necesarias para utilizar los nosmbres de los registros
                                    ;de funciones especiales SFR

ITERACION       EQU 0X20        ;CANTIDAD DE ITERACIONES DE CADA BUCLE
DATO            EQU 0x21        ;VARIABLES QUE IRÉ INCREMENTANDO DENTRO DE CBUCLE

    ORG 0x00
    GOTO INICIO
    ORG 0X05
INICIO
    CLRF    DATO                 ;INICIALIZO DATO E ITERACION
    MOVLW   D'5'
    MOVWF   ITERACION

BUCLE
    INCF    DATO,1
    DECFSZ  ITERACION,1          ;SI ITERACION NO LLEGO A CERO
    GOTO    BUCLE                ;SALTO A LA ETIQUETA BUCLE
    GOTO INICIO                  ;SI LLEGO A CERO SALTO A LA ETIQUETA INICIO
    END







;    MOVLW   D'8'                    ;Inicializamos variables DATO_1 y DATO_2
;    MOVWF   DATO_1
;    MOVLW   d'4'
;    MOVWF   DATO_2
