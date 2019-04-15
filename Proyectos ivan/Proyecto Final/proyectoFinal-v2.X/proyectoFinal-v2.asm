  list p=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0xFFE1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
;CONSTANTES

dato equ d'2'
clk equ d'1'
latch equ d'3'
caracteres equ d'5'
anchoChar equ d'6'
carga equ d'6'

 
 
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


 
org 0x00
    goto COMIENZO
org 0x04
    goto INTERRUPCIONES
    
COMIENZO
    movlw b'10100000'
    movwf INTCON ; configuro las interrupciones por desbordamiento de timer 0
    movlw carga
    movwf TMR0 ; cargo timer con 6
    bsf STATUS,RP0 ; banco 1
    movlw b'11010110'
    movwf OPTION_REG ; configuro flancos y prescaler (x4)
    clrf TRISD ; puerto D como salida
    clrf TRISC ; puerto C como salida
    bcf STATUS, RP0 ; banco 0
    movlw 0xFF
    movwf PORTD ; todas las salidas en alto para inhabilitar el display
    clrf PORTC ; todas las salidas en bajo por defecto
    movlw "?"
    movwf char5
    movlw "N"
    movwf char4
    movlw "A"
    movwf char3
    movlw "V"
    movwf char2
    movlw "I"
    movwf char1
    movlw caracteres
    movwf numChar
    clrf filAux
    clrf numFila
    movlw anchoChar
    movwf numBits
    movlw d'20'
    movwf mult
    
ESPERA
    nop
    goto ESPERA
    
INTERRUPCIONES
    movlw carga
    movwf TMR0
    decfsz mult,1
    goto FIN
    movlw 0x24
    movwf FSR
    call CARGARDATOS
    movlw d'20'
    movwf mult
FIN
    bcf INTCON,T0IF
    retfie
    
CARGARDATOS
    call CARGARCARACTER ;reemplaza a CARGARFILA
    incf FSR,1 ;apunto a la siguiente direccion para cargar la siguiente fila del siguiente caracter
    decfsz numChar ; cargué todos los caracteres?
    goto CARGARDATOS ; ni
    movlw 0xFF
    movwf PORTD ; si. pongo en alto la fila activa para inhabilitarla y cargar los datos de la fila siguiente
    bsf PORTC,latch ;en alto el latch para mostrar los datos en los registros
    call HABILITARFILA ; habilito la fila segun el numFila actualizado
    bcf PORTC,latch ; en bajo el latch para la espera de los nuevos datos
    call CAMBIOFILA ; modifico el valor del registro numFila
    movlw caracteres
    movwf numChar ; cargo la cantidad de caracteres a mostrar en pantalla
    return
    
CARGARCARACTER
    call BUSCARFILA
    movwf filAux ; cargo la fila de cierto caracter que me retorna en w
CARGARBIT
    btfss filAux,0 ;es cero el primer bit de filAux?
    goto PONERCERO ;si
    goto PONERUNO ;no
ENVIARBIT ; da el pulso para que ingrese el dato al registro
    bcf PORTC,clk ;pongo en bajo el clock en espera al ingreso del nuevo dato
    nop ;espera prudente
    bsf PORTC,clk ; se ingresa el dato al registro
FINENVIO
    rrf filAux,1 ; muevo un bit a la derecha para enviar el siguiente bit
    decfsz numBits ; ¿recorri todos los bits del ancho de la palabra?
    goto CARGARBIT ; no
    movlw anchoChar ;si, vuelvo a cargar el contador numBits con la cantidad anchoChar y salgo de la subrutina
    movwf numBits
    return
    
PONERCERO
    bcf PORTC,dato ; pongo en cero el bit saliente de datos
    goto ENVIARBIT
    
PONERUNO
    bsf PORTC,dato ; pongo en uno el bit saliente de datos
    goto ENVIARBIT
    
CAMBIOFILA
    incf numFila
    movlw d'8'
    xorwf numFila,0
    btfsc STATUS,Z
    clrf numFila
    return
    
BUSCARFILA
    movlw d'48'
    subwf INDF,0 ; resto 32 al valor de char 1,2,3,4 o 5 para poder acceder a una tabla (en ASCII, 16 = 48 , si se resta, accederemos al caracter nro 0 (el 0))
TABLA
    addwf PCL ; le sumo el resultado de la resta a PCL para acceder a un determinado valor de la tabla
    goto CERO		; "0"
    goto UNO		; "1"
    goto DOS		; "2"
    
CERO
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010011'
    retlw b'00010011'
    retlw b'00010101'
    retlw b'00011001'
    retlw b'00011001'
    retlw b'00011001'
    retlw b'00001110'
    
UNO
    movf numFila,0
    addwf PCL,1
    retlw b'00000011'
    retlw b'00000111'
    retlw b'00001111'
    retlw b'00011011'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000011'
    
DOS
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00000001'
    retlw b'00000010'
    retlw b'00000100'
    retlw b'00001000'
    retlw b'00010000'
    retlw b'00011111'
    
HABILITARFILA
    movf numFila,0
    addwf PCL,1
    goto FILA0
    goto FILA1
    goto FILA2
    goto FILA3
    goto FILA4
    goto FILA5
    goto FILA6
    goto FILA7
    
FILA0
    bcf PORTD,0
    return

FILA1
    bcf PORTD,1
    return
    
FILA2
    bcf PORTD,2
    return
    
FILA3
    bcf PORTD,3
    return
    
FILA4
    bcf PORTD,4
    return
    
FILA5
    bcf PORTD,5
    return
    
FILA6
    bcf PORTD,6
    return
    
FILA7
    bcf PORTD,7
    return
end