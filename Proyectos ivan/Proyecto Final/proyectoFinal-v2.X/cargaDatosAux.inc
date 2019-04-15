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
