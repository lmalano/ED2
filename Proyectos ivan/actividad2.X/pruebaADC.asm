 list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 

unidades equ 0x20 
decenas equ 0x21
centenas equ 0x22
auxL equ 0x23
auxH equ 0x24
 
 
 
INTERRUPCION_ADC
 
    clrf unidades
    clrf decenas
    clrf centenas
    clrf auxL
    clrf auxH
    
    movf ADRESL,0
    movwf auxL
    movf ADRESH,0
    movwf auxH
    
     

    
CONVERSION
    CENTENAS
       movlw d'100'      ;W=d'100'
       subwf auxL,W     ;auxL - d'100' (W)
       btfss STATUS,C    ;auxL menor que d'100'?
       goto DECENAS     ;SI
       movwf auxL       ;NO, Salva auxL
       call INCCENTENA   ;Incrementa el contador de centenas BCD
       goto CENTENAS    ;Realiza otra resta
    DECENAS
       movlw d'10'       ;W=d'10'
       subwf auxL,W     ;auxL - d'10' (W)
       btfss STATUS,C    ;auxL menor que d'10'?
       goto UNIDADES    ;Si
       movwf auxL       ;No, Salva auxL
       call INCDECENA    ;Incrementa el contador de centenas BCD
       goto DECENAS     ;Realiza otra resta
    UNIDADES
       movf auxL,0
       btfsc STATUS,Z	;auxL es cero?
       goto CONTROLFINAL;si
       call INCUNIDAD	;no, incremento una vez unidades
       decf auxL
       goto UNIDADES
       
       
       
CONTROLFINAL       
    movf auxH,0
    btfsc STATUS,Z   ;el registro de bits MSB llego a cero?
    goto FIN        ;si
    movlw 0xff	    ;no, vuelvo a cargar auxL
    movwf auxL
    decf auxH,1	    ;decremento el registro de bits MSB
    incf unidades
    goto CONVERSION       
       
INCUNIDAD
    incf unidades,1
    movlw d'10'
    xorwf unidades,0
    btfss STATUS,Z
    return
    clrf unidades
    call INCDECENA
    return
    
INCDECENA
    incf decenas,1
    movlw d'10'
    xorwf decenas,0
    btfss STATUS,Z
    return
    clrf decenas
    call INCCENTENA
    return

INCCENTENA
    incf centenas,1
    movlw d'10'
    xorwf centenas,0
    btfsc STATUS,Z
    clrf centenas
    return
    

FIN
    nop       
    end


