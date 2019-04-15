org 0x300
TECLADO
    ;call RETARDO ;llamo a un retardo de 5ms por software para eliminar rebotes
    
BIT0		    ; pruebo columna de RB0
    movlw b'00001110'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TECLA1
    btfss PORTB,5
    goto TECLA2
    btfss PORTB,6
    goto TECLA3
    btfss PORTB,7
    goto TECLAA

BIT1		    ; pruebo columna de RB1
    movlw b'00001101'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TECLA4
    btfss PORTB,5
    goto TECLA5
    btfss PORTB,6
    goto TECLA6
    btfss PORTB,7
    goto TECLAB
    
BIT2		    ; pruebo bit de la columna RB2
    movlw b'00001011'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TECLA7
    btfss PORTB,5
    goto TECLA8
    btfss PORTB,6
    goto TECLA9
    btfss PORTB,7
    goto TECLAC
    
BIT3		    ; pruebo bit de la columna RB3
    movlw b'00000111'
    movwf PORTB
    btfss PORTB,4 ;se apreto tecla en la fila de RB4? (0 si/1 no)
    goto TECLAAST
    btfss PORTB,5
    goto TECLA0
    btfss PORTB,6
    goto TECLANUM
    btfss PORTB,7
    goto TECLAD

FINTECLADO
    clrf PORTB		    ; dejo el puerto B tal cual quedo al incicio de la ejecucion (los 4 bits mas altos no son afectados por el clrf, quedando en alto por ser de entrada)
    ;bcf banderas,teclado    ; bajo bandera para no volver a entrar en esta rutina hasta que se vuelva a presionar otra tecla
    ;goto CONTROL1
    bcf INTCON,RBIF
    retfie
    

TECLA1
    movlw "1"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA2
    movlw "2"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA3
    movlw "3"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA4
    movlw "4"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA5
    movlw "5"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA6
    movlw "6"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA7
    movlw "7"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA8
    movlw "8"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA9
    movlw "9"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA0
    movlw "0"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLAAST
    movlw "*"
    movwf char5
    ;clrf banderas2
    ;bsf banderas2,reloj
    goto FINTECLADO
    
TECLANUM
    movlw d'48'
    subwf confMinutoL,0
    movwf minutoLAux		;confirmo la unidad de minutos y lo guardo como binario puro
    movlw d'48'
    subwf confMinutoH,0
    movwf minutoHAux		;confirmo la decena de minutos y lo guardo como binario puro
    movlw d'48'
    subwf confHoraL,0
    movwf horaLAux		;confirmo la unidad de horas y lo guardo como binario puro
    movlw d'48'
    subwf confHoraH,0
    movwf horaHAux		;cofirmo la unidad de minutos y lo guardo como binario puro
    clrf banderasDisplay
    bsf banderasDisplay,reloj	;ahora doy la orden para mostrar el reloj nuevamente
    goto FINTECLADO
    
TECLAA				;se encarga de entrar en el modo de configuracion del reloj
    clrf banderasDisplay
    bsf banderasDisplay,configuracion
    goto FINTECLADO
    
TECLAB
    goto FINTECLADO
    
TECLAC
    goto FINTECLADO
    
TECLAD
    goto FINTECLADO
    
RETARDO
    movlw d'9'
    movwf M
BUCLE2
    movlw d'180'
    movwf N
BUCLE1
    decfsz N,1
    goto BUCLE1
    decfsz M,1
    goto BUCLE2
    return

ASIGNARHORA
    movf punteroHora,0
    movwf FSR			    ;apunto a la posicion de un caracter a modificar
    movf confAux,0		    
    movwf INDF			    ;cargo en uno de los registros de configuracion el valor segun el teclado
    decf punteroHora,1		    ;en el proximo acceso a esta rutina el puntero apuntara a la posicion anterior
    decf posNum,1		    
    movlw d'2'
    xorwf posNum,0		    ; verifico si llegue a la posicion del registto del separador ":" para no borrarlo
    btfsc STATUS,Z		    ; llegue?
    decf punteroHora,1		    ; si, decremento otro valor del puntero para no sobreescribir el separador
    movf posNum,0
    btfss STATUS,Z		    ; ya cargue la unidad de minutos?
    return			    ; no
    movlw d'4'
    movwf posNum		    ; si, vuelvo a cargar el contador para comenzar a cargar las decenas de horas
    movlw 0x3E
    movwf punteroHora		    ; el puntero volvera a apuntar al registro de configuracion de las decenas de horas
    return
    
    