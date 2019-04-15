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
	
	ORG	0X00
	
	bsf	STATUS,RP0
	movlw	b'00000000'
	movwf	TRISD
	bcf	STATUS,RP0

	
	
PRINCIPAL
	bsf PORTD,0
	call RETARDO1
	bcf PORTD,0
	bsf PORTD,3
	call RETARDO1
	bcf PORTD,3
	bsf PORTD,7
	call RETARDO1
	bcf PORTD,7
	call RETARDO1
	goto PRINCIPAL
	    
		
	
RETARDO1 ;me da un retardo mas lento
	movlw d'250'
	movwf cont1
	movlw d'100'
	movwf cont2
	movlw d'40'
	movwf cont3
	BUCLE1
	    decfsz cont1
	    goto BUCLE1
	    movlw d'250'
	    movwf cont1
	    decfsz cont2
	    goto BUCLE1
	    movlw d'10'
	    movwf cont2
	    decfsz cont3
	    goto BUCLE1
	return	
	END
	
	
	
	
	
	





