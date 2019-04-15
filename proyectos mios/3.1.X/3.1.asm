  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF ;USAR SIEMPRE ESTA CONFIGURACION!!!!
 
cont1 equ 0x20
cont2 equ 0x21
cont3 equ 0x22
contador equ 0x23
 
	ORG	0X00
	
	bsf	STATUS,RP0
	movlw	0x10
	movwf	TRISA
	movlw	0x00
	movwf	TRISD
	bcf	STATUS,RP0

	
PRINCIPAL
	
	btfss PORTA,0
	goto TEST		
	goto PRINCIPAL
	    
TEST
	incf contador
	movf contador,0
	movwf PORTD
	goto PRINCIPAL
	;call RETARDO1
	;btfsc PORTA,0
	
	
	
	
	
RETARDO1 ;me da un retardo mas lento
	movlw d'250'
	movwf cont1
	movlw d'100'
	movwf cont2
	movlw d'100'
	movwf cont3
	BUCLE1
	    decfsz cont1
	    goto BUCLE1
	    movlw d'250'
	    movwf cont1
	    decfsz cont2
	    goto BUCLE1
	    movlw d'100'
	    movwf cont2
	    decfsz cont3
	    goto BUCLE1
	return
	
	
	END
	
	
	
	
	
	








