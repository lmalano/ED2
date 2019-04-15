list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF


ORG 0x00

goto INICIO

INICIO
bcf STATUS, RP1
bsf STATUS, RP0 ;voy al banco 1
clrf TRISD
bcf STATUS, RP0 ; vuelvo al banco 0

BIT4
btfsc PORTC,4
goto SET4
btfss PORTC,4
goto RESET4

BIT5
btfsc PORTC,5
goto SET5
btfss PORTC,5
goto RESET5

BIT6
btfsc PORTC,6
goto SET6
btfss PORTC,6
goto RESET6

BIT7
btfsc PORTC,7
goto SET7
btfss PORTC,7
goto RESET7

SET4
bsf PORTD,4
goto BIT5
RESET4
bcf PORTD,4
goto BIT5

SET5
bsf PORTD,5
goto BIT6
RESET5
bcf PORTD,5
goto BIT6

SET6
bsf PORTD,6
goto BIT7
RESET6
bcf PORTD,6
goto BIT7

SET7
bsf PORTD,7
goto BIT4
RESET7
bcf PORTD,7
goto BIT4

end




