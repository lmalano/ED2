; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF ;USAR SIEMPRE ESTA CONFIGURACION!!!!
LISTP=16F887
#include<p16f887.inc>
    
selector    equ	    0x21
CONT1	    equ	    0x22
CONT2	    EQU	    0X23
FLAG	    EQU	    0X24
PRENDER	    EQU	    0	    
CONTADOR    EQU     0x25
CONTADOR2   EQU	    0X26
CONTADOR3   EQU	    0X27
W_TEMP	    EQU	    0X28
STATUS_TEMP EQU	    0X29
MUNIDAD	    EQU	    0X32
MCENTENA    EQU	    0X33
SUNIDAD	    EQU	    0X34
SCENTENA    EQU	    0X35
MINUNIDAD   EQU	    0X36
MINCENTENA EQU	    0X37

	    ORG	    0X00
	    GOTO INICIO
	    
	    ORG	    0X04
	    GOTO    INTER
INTER
	    MOVWF	W_TEMP ;SALVO EL ENTORNO
	    SWAPF	STATUS,W
	    MOVWF	STATUS_TEMP
	    btfss	INTCON,2
	    goto        INTERRUP
	    goto	TIMER
	    
TIMER
	    bcf	    INTCON,T0IF;hubo una interrupcion seteo en 0 el tmr
	    bsf	    FLAG,PRENDER
	    goto    RECU
	   
RECU
	    SWAPF	STATUS_TEMP,0
	    MOVWF	STATUS
	    SWAPF	W_TEMP,1
	    SWAPF	W_TEMP,0
	    RETFIE
	    
INTERRUP
	    goto    INICIO
	    btfsc  INTCON,INTF; pregunta si fue inter exter o interna(tmr0)
	    goto EXTERNA ;si
	    goto PRINCIPAL ;no

INICIO	    
	    bsf	    STATUS,RP0
	    bcf	    STATUS,RP1
	    clrf    TRISD
	    clrf    TRISC
	    movlw   b'10100000'
	    movwf   INTCON
	    movlw   b'10010001' ;plescaler 1:4
	    movwf   OPTION_REG
	    bcf	    STATUS,RP0
	    CLRF    CONTADOR
	    clrf    PORTD
	    clrf    PORTC  
	    movlw   d'254'
	    movwf   TMR0
	    
RESETEAR
	    call RETARDO ;retardo  esot hasta la linea82 lo agregue, no se si esat bien
	    btfsc PORTB,0
	
	    call RETARDO
	    
	     movlw b'00000001'
	     xorwf FLAG,1  ; linea 81 y 82 no se si estan bien adaptada de la variable bandera del tp2 de ivan
	     btfss FLAG,0 ; si el bit 0 esta en bajo, se detiene la cuenta pero no borramos nada. si esta en alto, borramos todo y comenzamos a contar
    	    clrf    MUNIDAD
	    clrf    MCENTENA
	    clrf    SUNIDAD
	    clrf    SCENTENA
	    clrf    MINUNIDAD
	    clrf    MINCENTENA
	    clrf    CONTADOR
	    clrf    CONTADOR2
	    clrf    CONTADOR3
AGAIN
	    movlw   b'11111110'
	    movwf   selector
	    movwf   PORTC
	    movlw   MUNIDAD
	    movwf   FSR 
	    
	    
	    
PRINCIPAL
	    
	    movf    INDF,0
	    call    CONVERTIR
	    movwf   PORTD
	    call    RETARDO
	    incf    FSR,1
	    bsf	    STATUS,C
	    rlf	    selector
	    btfss   selector,6
	    goto    AGAIN
	    movf    selector,0
	    movwf   PORTC
	    
	    btfss   FLAG,PRENDER
	    GOTO    PRINCIPAL
	    bcf	    FLAG,PRENDER
	    movlw   d'254'
	    movwf   TMR0
	    incf    CONTADOR,1
	    incf    MUNIDAD,1
	    movlw   d'10'
	    subwf   MUNIDAD,0
	    btfsc   STATUS,Z
	    goto    AUMENTADECENA
SIGUE	    movlw   d'100'
	    subwf   CONTADOR,0
	    btfsc   STATUS,Z
	    goto    SEGUNDOS
SIGUE2	    movlw   d'10'
	    subwf   SUNIDAD,0
	    btfsc   STATUS,Z
	    goto    AUMENTASDECENA
SIGUE3	    movlw   d'60'
	    subwf   CONTADOR2,0
	    btfsc   STATUS,Z
	    goto    MINUTOS	    
SIGUE4	    movlw   d'10'
	    subwf   MINUNIDAD,0
	    btfsc   STATUS,Z
	    goto    AUMENTASDECENAA
SIGUE5	    movlw   d'60'
	    subwf   CONTADOR2,0
	    btfsc   STATUS,Z
	    goto    RESETEAR
	    goto    PRINCIPAL
MINUTOS
	    clrf    CONTADOR2
	    CLRF    SCENTENA
	    incf    CONTADOR3,1
	    incf    MINUNIDAD,1
	    GOTO    SIGUE4
SEGUNDOS
	   clrf	    CONTADOR
	   clrf	    MCENTENA
	   incf	    CONTADOR2,1
	   incf	    SUNIDAD,1
	   goto	    SIGUE2
AUMENTASDECENAA
	   clrf	   MINUNIDAD
	   incf    MINCENTENA,1
	   goto	   SIGUE5
AUMENTASDECENA
	   clrf   SUNIDAD
	   incf    SCENTENA,1
	   goto	   SIGUE3
AUMENTADECENA 
	   clrf    MUNIDAD
	   incf    MCENTENA,1
	   goto	   SIGUE

CONVERTIR
	    addwf   PCL,1; suma a PC el valor del dígito
	    retlw   b'11000000'; obtiene el valor 7 segmentos del 0
	    retlw   b'11111001' ; obtiene el valor 7 segmentos del 1
	    retlw   b'10100100'; obtiene el valor 7 segmentos del 2
	    retlw   b'10110000'; obtiene el valor 7 segmentos del 3
	    retlw   b'10011001'; obtiene el valor 7 segmentos del 4
	    retlw   b'10010010'; obtiene el valor 7 segmentos del 5
	    retlw   b'10000010'; obtiene el valor 7 segmentos del 6
	    retlw   b'11111000'; obtiene el valor 7 segmentos del 7
	    retlw   b'10000000'; obtiene el valor 7 segmentos del 8
	    retlw   b'10010000'; obtiene el valor 7 segmentos del 9	    
	    
			
RETARDO 	
	    MOVLW 		D'255' ;RETARDO DE 1 mS APROX.
	    MOVWF		CONT1
REP	    DECFSZ 		CONT1,1
	    GOTO 		REP

	    MOVLW 		D'255'
	    MOVWF 		CONT2
RET1	    DECFSZ		CONT2,1
	    GOTO		RET1
	    RETURN
	    
   
	    end



	    
	    
	    
	 
	    

	    
	    
	    




	    
	    
	    
	    





