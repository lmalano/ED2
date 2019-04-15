  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
;CONSTANTES

dato equ d'2'		;indica el pin de salida de datos
clk equ d'1'		;indica el pin de clock
latch equ d'3'		;indica el pin de señal de latch
caracteres equ d'5'	;indica la cantidad de caracteres a mostrar
anchoChar equ d'6'	;indica el ancho de cara caracter
carga equ d'6'		;indica la carga del timer 0
multiplicador equ d'5'	;indica cuántas veces debe interrumpir el timer para incrementar el reloj
conSinPt equ d'0'	;bandera que me indica si muestro los dos puntos o no en el modo reloj

 
 
;REGISTROS
 
numChar equ 0x20
filAux equ 0x21
numBits equ 0x22
numFila equ 0x23
char5 equ 0x24
char4 equ 0x25
char3 equ 0x26
char2 equ 0x27
char1 equ 0x28
mult equ 0x29
relojMinutoL equ 0x2A
relojMinutoH equ 0x2B
relojSeparador equ 0x2C
relojHoraL equ 0x2D
relojHoraH equ 0x2E
sePuedeInc equ 0x2F
unidadAux equ 0x30
decenaAux equ 0x31
centenaAux equ 0x32
unmilAux equ 0x33
minutoLAux equ 0x34
minutoHAux equ 0x35
horaLAux equ 0x36
horaHAux equ 0x37
banderas equ 0x38


 
org 0x00
    goto COMIENZO
org 0x04
    goto INTERRUPCIONES
   ; #include "tablaCaracteres.inc"
    
COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    movlw carga
    movwf TMR0 ; cargo timer con 6
    bsf STATUS,RP0 ; banco 1
    movlw b'11010010'
    movwf OPTION_REG ; configuro flancos y prescaler (x4)
    clrf TRISD ; puerto D como salida
    clrf TRISC ; puerto C como salida
    bcf STATUS, RP0 ; banco 0
    movlw 0xFF
    movwf PORTD ; todas las salidas en alto para inhabilitar el display
    clrf PORTC ; todas las salidas en bajo por defecto
    movlw "#"
    movwf char5
    movlw "A"
    movwf char4
    movlw "T"
    movwf char3
    movlw "U"
    movwf char2
    movlw "P"
    movwf char1
    movlw "0"
    movwf relojMinutoL ;inicializo los caracteres del reloj
    movlw "0"
    movwf relojMinutoH
    movlw "0"
    movwf relojHoraL
    movlw "0"
    movwf relojHoraH
    movlw ":"
    movwf relojSeparador
    movlw caracteres
    movwf numChar
    clrf filAux
    clrf numFila
    movlw anchoChar
    movwf numBits
    movlw d'20'
    movwf mult
    movlw multiplicador
    movwf sePuedeInc
    clrf unidadAux
    clrf decenaAux
    clrf centenaAux
    clrf unmilAux
    clrf minutoLAux
    clrf minutoHAux
    clrf horaLAux
    clrf horaHAux
    clrf banderas
    movlw d'9'
    movwf minutoLAux
    movlw d'5'
    movwf minutoHAux
    movlw d'3'
    movwf horaLAux
    movlw d'2'
    movwf horaHAux
    
CONTROLPRINCIPAL  
    btfss banderas,conSinPt
    goto PONERPUNTOS
    goto BORRARPUNTOS
    
PONERPUNTOS
    movlw ":"
    movwf relojSeparador
    goto CONTROLPRINCIPAL
    
BORRARPUNTOS
    movlw " "
    movwf relojSeparador
    goto CONTROLPRINCIPAL
    
INTERRUPCIONES
    btfsc INTCON,T0IF ; fue interrupcion de timer 0?
    goto TIMER ; si
    
TIMER
    movlw carga
    movwf TMR0
    movlw 0x2A
    movwf FSR
    call CARGARDATOS
    decfsz sePuedeInc,1 ; ya es hora de incrementar el reloj?
    goto FINCUENTA ; No
    call INCREMENTOHORA ;Si
AASCII ; codifico valor binario que quiero mostrar en pantalla en codigo ascii
    movlw d'48'
    addwf minutoLAux,0
    movwf relojMinutoL
    movlw d'48'
    addwf minutoHAux,0
    movwf relojMinutoH
    movlw d'48'
    addwf horaLAux,0
    movwf relojHoraL
    movlw d'48'
    addwf horaHAux,0
    movwf relojHoraH
CAMBIOBANDERA
    movf decenaAux,0
    btfss STATUS,Z
    goto FINCUENTA
    movf unidadAux,0
    btfss STATUS,Z
    goto FINCUENTA
    movlw d'1'
    xorwf banderas,1
FINCUENTA
    bcf INTCON,T0IF
    retfie
    
INCREMENTOHORA
    call INCUNIDAD	;incrementa una centecima
    btfsc STATUS,Z
    call INCDECENA	;incrementa una decima
    btfsc STATUS,Z
    call INCCENTENA	;incrementa un segundo
    btfsc STATUS,Z
    call INCUNMIL	; incrementa una decena de segundos
    btfsc STATUS,Z
    call INCMINUTOL	; incrementa un minuto
    btfsc STATUS,Z
    call INCMINUTOH	;incrementa una decena de minutos
    btfsc STATUS,Z
    call INCHORAL	;incrementa una hora
    btfsc STATUS,Z
    call INCHORAH	;incrementa una decena de horas
    movlw multiplicador ; constante a cargar en sePuedeInc que cuenta los nros de int poor timer de espera para incrementar
    movwf sePuedeInc
    return
    
INCUNIDAD
    incf unidadAux,1
    movlw d'10'
    xorwf unidadAux,0
    btfsc STATUS,Z
    clrf unidadAux
    return
    
INCDECENA
    incf decenaAux,1
    movlw d'10'
    xorwf decenaAux,0
    btfsc STATUS,Z
    clrf decenaAux
    return
    
INCCENTENA
    incf centenaAux,1
    movlw d'10'
    xorwf centenaAux,0
    btfsc STATUS,Z
    clrf centenaAux
    return
    
INCUNMIL
    incf unmilAux,1
    movlw d'6'
    xorwf unmilAux,0
    btfsc STATUS,Z
    clrf unmilAux
    return
    
INCMINUTOL
    incf minutoLAux,1
    movlw d'10'
    xorwf minutoLAux,0
    btfsc STATUS,Z
    clrf minutoLAux
    return
    
INCMINUTOH
    incf minutoHAux,1
    movlw d'6'
    xorwf minutoHAux,0
    btfsc STATUS,Z
    clrf minutoHAux
    return
    
INCHORAL
    incf horaLAux,1
    movlw d'4'
    xorwf horaLAux,0 
    btfss STATUS,Z ;llego a 4 horaLAux? si es así hay que verificar si horaHAux llegó a 2
    goto FININCHORAL ;no llegó a 4. entonces voy al final a verificar si llego a 10
    movlw d'2'
    xorwf horaHAux,0
    btfss STATUS,Z ;llego a 2 horaHAux? si es así hay que resetear horaLAux, y sino hay que verificar si este llego a 10
    goto FININCHORAL ;no llegó a 2. entonces voy al final a verificar si llego a 10
    clrf horaLAux ;si, borro dicho registro
    return
FININCHORAL
    movlw d'10'
    xorwf horaLAux,0
    btfsc STATUS,Z ;llego a 10 horaLAux?
    clrf horaLAux ;si
    return ;no

INCHORAH
    incf horaHAux,1
    movlw d'3'
    xorwf horaHAux,0
    btfsc STATUS,Z
    clrf horaHAux
    return
    
    
    
    
    
    #include "cargaDeDatos.inc"
end