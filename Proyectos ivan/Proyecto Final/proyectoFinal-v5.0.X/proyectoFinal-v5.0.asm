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
reloj equ d'0'		;bandera que me indica si debo mostrar el reloj en display (1) o si no (0)
configuracion equ d'1'	;bandera para saber si debo mostrar la configuracion de la hora y asi descartar cambios si quiero
temperatura equ d'2'	;bandera para indicar que se debe mostrar la temperatura en el display
textoConf equ d'3'	;bandera para indicar si se debe mostrar la entrada de texto

 
 
;REGISTROS
 
numChar equ 0x20		    ;registro que carga la cantidad de caracteres a mostrar
filAux equ 0x21			    ;registro que carga provisoriamente la fila de un caracter para ir enviando bit a bit
numBits equ 0x22		    ;ancho de bits del caracter mas un bit de separacion
numFila equ 0x23		    ;indica la fila que hay que utilizar para cada caracter, y ademas indica la fila completa a mostrar
puntero1 equ 0x24		    ;puntero que marca el limite a mostrar en el modo de configuracion de ingreso de texto
puntero2 equ 0x25		    ;puntero que indica en que registro debe almacenarse el caracter ingresado desde la pc
puntero1Aux equ 0x26		    ;registro auxiliar para hacer operaciones con el valor de puntero1
;char2 equ 0x27
;char1 equ 0x28
mult equ 0x29
relojMinutoL equ 0x2A		    ;caracter a mostrar en unidades de minutos (ascii)
relojMinutoH equ 0x2B		    ;caracter a mostrar en decenas de minutos (ascii)
relojSeparador equ 0x2C		    ;caracter de separacion de horas con minutos ":"
relojHoraL equ 0x2D		    ;caracter a mostrar en unidades de horas (ascii)
relojHoraH equ 0x2E		    ;caracter a mostrar en decenas de horas (ascii)
sePuedeInc equ 0x2F		    ;contador para indicar cuando hay que incrementar el reloj
unidadAux equ 0x30		    ;valor de centecima de segundo (binario puro)
decenaAux equ 0x31		    ;valor de decima de segundo (binario puro)
centenaAux equ 0x32		    ;valor de unidad de segundo (binario puro)
unmilAux equ 0x33		    ;valor de decena de segundo (binario puro)
minutoLAux equ 0x34		    ;valor de unidad de minuto (binario puro)
minutoHAux equ 0x35		    ;valor de decena de minuto (binario puro)
horaLAux equ 0x36		    ;valor de unidad de horas (binario puro)
horaHAux equ 0x37		    ;valor de decena de horas (binario puro)
banderas equ 0x38		    ;registro de banderas 
banderasDisplay equ 0x39	    ;registro de banderas de seleccion de muestras en display. indica qué voy a ver ahí
confMinutoL equ 0x3A		    ;configuracion de unidades de minutos (ascii)
confMinutoH equ 0x3B		    ;configuracion de decenas de minutos (ascii)
separadorHoraConf equ 0x3C	    ;separador ":" para configuracion de horas
confHoraL equ 0x3D		    ;configuracion de unidades de horas (ascii)
confHoraH equ 0x3E		    ;configuracion de decenas de horas (ascii)
confAux	equ 0x3F		    ;guardo un valor auxiliar segun la tecla apretada
posNum	equ 0x40		    ;registro que me indica la posicion del reloj que deseo modificar (guardo en los registros auxiliares)
punteroHora equ 0x41		    ;se encarga de apuntar a la posicion de decenas de horas de configuracion
conversionL equ 0x42		    ;almacena el byte bajo convertido por el ADC
conversionH equ 0x43		    ;almacena el byte alto convertido por el ADC
unidadADC equ 0x44		    ;almacena en primera instancia las decimas de grados en BCD y luego se convierte en ASCII
separadorTemp equ 0x45		    ;separador entre unidades de grados y decimas (".")
decenaADC equ 0x46		    ;almacena en primera instancia las unidades de grados en BCD y luego se convierte en ASCII
centenaADC equ 0x47		    ;almacena en primera instancia las decenas de grados en BCD y luego se convierte en ASCII
tempChar equ 0x48		    ;almacena la "T" para darle el formato correcto en el display, haciendo referencia a Temperatura (en ASCII)
w_temp equ 0x70			    ;registro auxiliar para guardar temporalmente el valor de w mientras se atiende una interrupcion
status_temp equ 0x71		    ;registro auxiliar para guardar temporalmente el valor de status mientras se atiende una interrupcion
char1 equ 0x49			    ;serie de caracteres para mostrar en el panel de mensajes (en ASCII)
char2 equ 0x4A
char3 equ 0x4B
char4 equ 0x4C
char5 equ 0x4D
char6 equ 0x4E
char7 equ 0x4F
char8 equ 0x50
char9 equ 0x51
char10 equ 0x52
char11 equ 0x53
char12 equ 0x54
char13 equ 0x55
char14 equ 0x56
char15 equ 0x57
char16 equ 0x58
char17 equ 0x59
char18 equ 0x5A
char19 equ 0x5B
char20 equ 0x5C
char21 equ 0x5D
char22 equ 0x5E
char23 equ 0x5F
 

 
org 0x00
    goto COMIENZO
org 0x04
    goto INTERRUPCIONES
    
COMIENZO
    movlw b'01010001'
    movwf ADCON0			; fosc/8 - AN4 (RA5) - conversion detenida - conversor activado
    bcf PIR1,ADIF			; bajo la bandera de interrupcion de adc por si llegara a comenzar levantada
    clrf ADRESH				; limpio el byte alto de los resultados de conversiones
    movlw b'10010000'
    movwf RCSTA				; habilito puerto serial, recepcion de 8 bits, recepcion continua
    bsf STATUS,RP0
    bsf STATUS,RP1			; banco 3
    movlw b'01000000'
    movwf BAUDCTL			; transmision sin inversion de polaridad, no usamos spbrgh
    clrf ANSELH
    movlw b'11110000'
    movwf TRISB				; nibble alto como entrada - nibble bajo como salida
    movlw b'01010010'
    movwf OPTION_REG			; configuro flancos, prescaler (x8) y habilito permisos de pull up
    bcf STATUS,RP1			; banco 1
    movlw b'00100100'
    movwf TXSTA				; habilito transmision de datos, asincronica, 8 bits
    movlw d'25'
    movwf SPBRG				; configuro la velocidad en baudios de los bits a transmitir (9600 con un error del 0,16%)
    movlw b'10110000'
    movwf ADCON1			; uso referencia externa, formato justificado a la derecha
    bsf PIE1,6				; habilito interrupcion adc
    bsf PIE1,RCIE			; habilito interrupcion por recepcion de datos
    clrf ADRESL				; limpio el byte bajo de los resultados de conversiones
    clrf TRISD				; puerto D como salida
    movlw b'11110001'
    movwf TRISC				; puerto C como salida en pines <1:3>
    movlw b'11110000'
    movwf IOCB				; habilito todos los bits del puerto b como fuente de interrupcion (saco rb6  y rb7 para debugging)
    movlw b'11111111'
    movwf WPUB				; habilito pull up en todos los bits del puerto b
    bcf STATUS, RP0			; banco 0
    clrf PORTD				; todas las salidas en bajo para inhabilitar el display
    clrf PORTC				; todas las salidas en bajo por defecto
    movlw b'11101000'
    movwf INTCON			; configuro las interrupciones por desbordamiento de timer 0, cambios en puerto b y perifericos
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
    movlw b'00001000'
    movwf banderasDisplay   ;por defecto comienza mostrando la hora ( por ahora lo cambie a la entrada de texto)
    movlw d'4'
    movwf posNum	    ;inicializo el registro
    movlw 0x3E
    movwf punteroHora	    ;el puntero comienza con el valor del primer caracter a mostrar en el modo configuracion
    movlw "0"
    movwf confMinutoL
    movlw "0"
    movwf confMinutoH
    movlw ":"
    movwf separadorHoraConf
    movlw "0"
    movwf confHoraL
    movlw "0"
    movwf confHoraH
    movlw "-"
    movwf unidadADC
    movlw "."
    movwf separadorTemp
    movlw "-"
    movwf decenaADC
    movlw "-"
    movwf centenaADC
    movlw "T"
    movwf tempChar
    movlw 0x5B
    movwf puntero1				    ;inicializo puntero1
    movlw 0x5F
    movwf puntero2				    ;inicializo puntero2
    movlw "-"
    movwf char1
    movwf char2
    movwf char3
    movwf char4
    movwf char5
    movwf char6
    movwf char7
    movwf char8
    movwf char9
    movwf char10
    movwf char11
    movwf char12
    movwf char13
    movwf char14
    movwf char15
    movwf char16
    movwf char17
    movwf char18
    movwf char19
    movwf char20
    movwf char21
    movwf char22
    movwf char23
    
;----------------------RUTINA PRINCIPAL DE CONTROLES---------------------;
    
CONTROL1			    ;controla el parpadeo de ":" del reloj
    btfss banderas,conSinPt
    goto PONERPUNTOS
    goto BORRARPUNTOS
    
CONTROL2			    ;da la orden de volver a mostrar el reloj siempre que se esté mostrando la temperatura
    btfss banderasDisplay,temperatura
    goto CONTROL1
    movlw d'5'
    xorwf centenaAux,0
    btfss STATUS,Z		    ;centenaAux llego a los 5 segundos?
    goto CONTROL1		    ;no
    bcf banderasDisplay,temperatura ;si. dejo de mostrar la temperatura y vuelvo a mostrar el reloj
    bsf banderasDisplay,reloj
    goto CONTROL1
    
;---------------------RUTINAS DE INTERRUPCIONES--------------------------;
    
INTERRUPCIONES
    btfsc INTCON,T0IF	; fue interrupcion de timer 0?
    goto TIMER		; si
    btfsc INTCON,RBIF	; fue interrupcion de teclado?
    goto TECLADO	; si
    btfsc PIR1,ADIF	; fue interrupcion de fin de conversion?
    goto ADCLECTURA	; si
    btfsc PIR1,RCIF	; fue interrupcion de recepcion de dato?
    goto INTRECEPCION	; si
    
TIMER			    ;rutina de interrupcion de timer
    call GUARDCONTEXTO
    movlw carga
    movwf TMR0
    ;decfsz mult,1
    ;goto FINCUENTA
    ;movlw d'20'
    ;movwf mult
    btfsc banderasDisplay,reloj ;muestro la hora?
    goto MOSTRARHORA
    btfsc banderasDisplay,configuracion
    goto MOSTRARCONFIG
    btfsc banderasDisplay,temperatura
    goto MOSTRARTEMP
    btfsc banderasDisplay,textoConf
    goto MOSTRARENTRADA
TIMERCONTROL
    decfsz sePuedeInc,1		;ya es hora de incrementar el reloj?
    goto FINCUENTA		;No
    call INCREMENTOHORA		;Si
AASCII				;codifico valor binario que quiero mostrar en pantalla en codigo ascii
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
CAMBIOBANDERA			;modifica la bandera que determina en la rutina principal si se debe mostrar o no el separador de horas y minutos ":"
    movf decenaAux,0
    btfss STATUS,Z
    goto FINCUENTA
    movf unidadAux,0
    btfss STATUS,Z
    goto FINCUENTA
    movlw d'1'
    xorwf banderas,1
SENSARTEMP			;si decena de segundos es impar y el rersto de los submultiplos es cero, manda a sensar la temperatura con el ADC
    movf unidadAux,0		
    btfsc STATUS,Z		;es cero la centecima de segundos?
    movf decenaAux,0		
    btfsc STATUS,Z		;es cero la decima de segundos?
    movf centenaAux,0
    btfss STATUS,Z		;es cero la unidad de segundos?
    goto FINCUENTA		;no
    btfsc unmilAux,0		;si. ahora, es impar la decena de segundos? En caso negativo se salta a FINCUENTA
    bsf ADCON0,1		;si. se lanza la conversion del ADC
FINCUENTA
    bcf INTCON,T0IF
    call RECCONTEXTO
    retfie
    
ADCLECTURA				; rutina de interrupcion de ADC
    btfss banderasDisplay,reloj		; se está mostrando el reloj?
    goto FINADCLECTURA			; no, no hago nada
    bcf banderasDisplay,reloj		; si. se deja de mostrarlo y se habilita la muestra de la temperatura (siguiente instruccion), y ademas se acomodan los datos para mostrarse correctamente
    bsf banderasDisplay,temperatura
    movf ADRESH,0
    movwf conversionH			; cargo el byte alto convertido a un registro auxiliar
    bsf STATUS,RP0			; accedo al banco 1 para leer ADRESL
    movf ADRESL,0
    bcf STATUS,RP0			; vuelvo al banco 0
    movwf conversionL			; cargo el byte bajo convertido a un registro auxiliar
    clrf unidadADC			; borro los tres registros que contendran los valores en BDC
    clrf decenaADC
    clrf centenaADC
    call CONVERTBCD			; llamo a una rutina que me convierta los 10 bits del ADC en BCD
    call TEMPASCII			; llamo a una rutina que me convierta los tres digitos en BCD a ASCII
FINADCLECTURA
    bcf PIR1,ADIF			; bajo bandera de interrupcion por fin de conversion
    retfie
    
INTRECEPCION				; rutina de interrupcion de recepcion de datos
    call GUARDCONTEXTO			; hago copia temporal de w y status
    movf puntero2,0
    movwf FSR				; FSR apunta a la posicion donde debe almacenarce el caracter recibido
    movf RCREG,0			; leo el byte recibido y lo cargo en w
    movwf TXREG				; lo reenvio a la pc para verificar que se recibió correctamente
    movwf INDF				; ahora lo copio a la posicion solicitada por puntero2
    call INCPUNTERO2			; modifico puntero2 y si es necesario, puntero1
    call INCPUNTERO1			; incremento puntero1 en caso de ser necesario
    btfsc PIR1,RCIF			; el buffer de recepcion está vacío?
    goto INTRECEPCION			; no, vuelvo a leerlo y almaceno el siguiente caracter en la siguiente posicion
    call RECCONTEXTO			; recupero los valores de w y status de la rutina principal
    retfie				; si, vuelvo a la rutina principal
    
    
    
;-----------------------RUTINAS DEL RELOJ----------------------;    
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
    
INCCENTENA			;incremento de unidades de segundos
    incf centenaAux,1
    movlw d'10'
    xorwf centenaAux,0
    btfsc STATUS,Z
    clrf centenaAux
    return
    
INCUNMIL			;incremento de decenas de segundos
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
    
;--------------------------RUTINAS DE CONTROL1-------------------------;    
PONERPUNTOS
    movlw ":"
    movwf relojSeparador
    goto CONTROL2
    
BORRARPUNTOS
    movlw " "
    movwf relojSeparador
    goto CONTROL2
        
;----------------------RUTINAS PARA DISTINAS MUESTRAS EN DISPLAY----------------------;
    
MOSTRARHORA		;rutina que carga los registros con el formato del reloj
    movlw 0x2A
    movwf FSR
    call CARGARDATOS
    goto TIMERCONTROL
    
MOSTRARCONFIG		;rutina que carga los registros de la configuracion del reloj
    movlw 0x3A
    movwf FSR
    call CARGARDATOS
    goto TIMERCONTROL
    
MOSTRARTEMP		;rutina que carga los registros de la temperatura
    movlw 0x44
    movwf FSR
    call CARGARDATOS
    goto TIMERCONTROL
    
MOSTRARENTRADA		;rutina que carga los registros segun se van ingresando los caracteres
    movf puntero1,0
    movwf FSR
    call CARGARDATOS
    goto TIMERCONTROL
    
 
;------------------------------RUTINAS DEL ADC-----------------------------------;    
    
CONVERTBCD		    ;rutina que convierte el binario natural del ADC a BCD de tres digitos
CENTENASADC
   movlw d'100'		    ;W=d'100'
   subwf conversionL,0	    ;auxL - d'100' (W)
   btfss STATUS,C	    ;auxL menor que d'100'?
   goto DECENASADC	    ;SI
   movwf conversionL	    ;NO, Salva conversionL
   call INCCENTENAADC	    ;Incrementa el contador de centenas BCD
   goto CENTENASADC	    ;Realiza otra resta
DECENASADC
   movlw d'10'		    ;W=d'10'
   subwf conversionL,0		    ;auxL - d'10' (W)
   btfss STATUS,C	    ;auxL menor que d'10'?
   goto UNIDADESADC	    ;Si
   movwf conversionL		    ;No, Salva auxL
   call INCDECENAADC	    ;Incrementa el contador de centenas BCD
   goto DECENASADC	    ;Realiza otra resta
UNIDADESADC
   movf conversionL,0
   btfsc STATUS,Z	    ;auxL es cero?
   goto CONTROLFINAL;si
   call INCUNIDADADC	;no, incremento una vez unidades
   decf conversionL
   goto UNIDADESADC
             
CONTROLFINAL       
    movf conversionH,0
    btfsc STATUS,Z		    ;el registro de bits MSB llego a cero?
    goto FINCONVERT		    ;si
    movlw 0xff			    ;no, vuelvo a cargar auxL
    movwf conversionL
    decf conversionH,1		    ;decremento el registro de bits MSB
    call INCUNIDADADC
    goto CONVERTBCD      
       
INCUNIDADADC
    incf unidadADC,1
    movlw d'10'
    xorwf unidadADC,0
    btfss STATUS,Z
    return
    clrf unidadADC
    call INCDECENAADC
    return
    
INCDECENAADC
    incf decenaADC,1
    movlw d'10'
    xorwf decenaADC,0
    btfss STATUS,Z
    return
    clrf decenaADC
    call INCCENTENAADC
    return

INCCENTENAADC
    incf centenaADC,1
    movlw d'10'
    xorwf centenaADC,0
    btfsc STATUS,Z
    clrf centenaADC
    return
    
FINCONVERT
    return
    
    
TEMPASCII		    ; convierte los valores de temperatura que estan en BCD a ASCII para poder mostrarlos en el display
    movlw d'48'
    addwf unidadADC,1
    addwf decenaADC,1
    addwf centenaADC,1
    return
    

GUARDCONTEXTO
    movwf w_temp
    swapf STATUS,0
    movwf status_temp
    return
    
RECCONTEXTO
    swapf status_temp,0
    movwf STATUS
    swapf w_temp,1
    swapf w_temp,0
    return
    
 
    
;--------------------------------------------RUTINAS DE LA COMUNICACION SERIE--------------------------------------;
INCPUNTERO2				; rutina que se encarga de decrementar puntero2 hasta el valor limite y vuelve a la posicion inicial
    decf puntero2,1			; decremento una unidad puntero2
    movlw 0x48
    xorwf puntero2,0
    btfss STATUS,Z			; puntero2 llegó al limite de caracteres?
    return				; no, regreso a la rutina anterior
    movlw 0x5F				; si, reinicializo los punteros a los valores iniciales (se sobreescribirá el texto ingresado)
    movwf puntero2
    movlw 0x5B
    movwf puntero1
    return
    
INCPUNTERO1				; rutina que se encarga de "correr" el texto para que el ultimo caracter ingresado pueda verse en el display
    movf puntero1,0
    movwf puntero1Aux			; copio el valor de puntero1 a un registro auxiliar
    decf puntero1Aux,1			; decremento 2 veces
    decf puntero1Aux,0
    subwf puntero2,0
    btfsc STATUS,Z			; puntero1Aux es igual a puntero2? en caso negativo, retorno directamente
    decf puntero1,1			; si. decremento una vez puntero1 para seguir al ultimo caracter ingresado
    return

    
    
    
    #include "usoTeclado.inc"
    #include "cargaDeDatos.inc"
end