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
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 3 a decenas de horas?
    goto FINTECLADO			    ;si. descarto el ingreso
    call ASIGNARHORA			    ;no, entonces puedo asignar el numero
    goto FINTECLADO
    
TECLA4
    movlw "4"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 4 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 4 a unidades de horas?
    goto ASIGNART4			    ;no, se asignan a minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfsc STATUS,Z
    goto FINTECLADO
ASIGNART4
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA5
    movlw "5"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 5 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 5 a unidades de horas?
    goto ASIGNART4			    ;no, se asignan a minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfsc STATUS,Z
    goto FINTECLADO
ASIGNART5   
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA6
    movlw "6"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 6 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 6 a unidades de horas?
    goto VERIFMINT6			    ;no, se verifican minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
VERIFMINT6
    movlw d'2'
    subwf posNum,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO

    
TECLA7
    movlw "7"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 7 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 7 a unidades de horas?
    goto VERIFMINT7			    ;no, se verifican minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
VERIFMINT7
    movlw d'2'
    subwf posNum,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA8
    movlw "8"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 8 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 8 a unidades de horas?
    goto VERIFMINT8			    ;no, se verifican minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
VERIFMINT8
    movlw d'2'
    subwf posNum,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA9
    movlw "9"
    movwf confAux
    movlw d'4'
    subwf posNum,0
    btfsc STATUS,Z			    ;estoy por asignar un 9 a decenas de horas?
    goto FINTECLADO
    movlw d'3'
    subwf posNum,0
    btfss STATUS,Z			    ;estoy por asignar un 9 a unidades de horas?
    goto VERIFMINT9			    ;no, se verifican minutos
    movlw "2"				    ;si, se verifica que decenas de horas sea menor que 2 para poder asignar este valor, sino no se asigna nada
    subwf confHoraH,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
VERIFMINT9
    movlw d'2'
    subwf posNum,0
    btfss STATUS,Z
    call ASIGNARHORA
    goto FINTECLADO
    
TECLA0
    movlw "0"
    movwf confAux
    call ASIGNARHORA
    goto FINTECLADO
    
TECLAAST				    ;tecla para descartar cambios y desactivar alarma
    clrf banderasDisplay
    bsf banderasDisplay,reloj		    ;vuelvo a mostrar el reloj
    goto FINTECLADO
    
TECLANUM				    ;tecla para guardar cambios, de acuerdo a la bandera activa
    btfsc banderasDisplay,configuracion
    goto GUARDARHORA
    btfsc banderasDisplay,textoConf
    goto GUARDARTEXTO
    btfsc banderasDisplay,confAlarma
    goto GUARDARALARMA
    goto FINTECLADO			    ;se coloca por si se presiona esta tecla y no se habia entrado a ninguna configuracion
    
TECLAA					    ;se encarga de entrar en el modo de configuracion del reloj
    clrf banderasDisplay
    bsf banderasDisplay,configuracion
    goto FINTECLADO
    
TECLAB
    bsf banderas,cargarChar		    ;me habilita la posibilidad de cargar nuevos caracteres
    movlw d'23'
    movwf contChar			    ;reinicio el contador para poder ingresar los 23 caracteres
    clrf banderasDisplay
    bsf banderasDisplay,textoConf	    ;entro a la configuracion del mensaje de almarma
    call INICPANEL			    ;reseteo el panel de mensajes
    movlw 0x5B
    movwf puntero1				    ;reinicializo puntero1
    movlw 0x5F
    movwf puntero2				    ;reinicializo puntero2
    movlw d'18'
    movwf contCharRef				    ;reinicializo el contador de referencia
    goto FINTECLADO
    
TECLAC
    clrf banderasDisplay
    bsf banderasDisplay,confAlarma
    goto FINTECLADO
    
TECLAD
    goto FINTECLADO