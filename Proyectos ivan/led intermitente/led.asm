list p = 16f84
include <p16f84a.inc> ; incluye la libreria del pic a utilizar con sus instrucciones

TIEMPO EQU 0X0C

org 0 ; posicion cero del banco de memoria
bsf STATUS,RP0 ; pongo en uno el bit RP0 (o bit 5 de STATUS, que tiene un total de 8) (me voy al banco 1)
CLRF PORTB ; como queda en cero, se considera salida
bcf STATUS,RP0 ; vuelvo al banco 0


; zona de codigo
INICIO

bcf PORTB,0 ; coloca en uno el primer pin (pin 0) del puerto B
bsf PORTB,1
CALL Retardo_1s
bsf PORTB,0
bcf PORTB,1
CALL Retardo_1s
GOTO INICIO

;RETARDO

;MOVLW D'255' ;carga W con 255
;MOVFW TIEMPO ;TIEMPO = 255

;DEC

;DECFSZ TIEMPO ; decrementa, y cuando sea cero TIEMPO, salta una linea
;GOTO DEC
;RETURN ;retorna a donde lo llamaron (lineas 16 y 18)

include <RETARDOS.inc>

END