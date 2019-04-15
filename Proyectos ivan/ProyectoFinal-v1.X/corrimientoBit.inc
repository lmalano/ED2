    CARGADATOS ;rutina de carga de los 32 bits de una fila pertenencientes a las 32 columnas del panel de leds
    movlw 0x24
    movwf FSR
    call CARGARFILA
    incf FSR,1
    call CARGARFILA
    incf FSR,1
    call CARGARFILA
    incf FSR
    call CARGARFILA
    incf FSR
    call CARGARFILA
    bsf PORTC,latch ;pongo en alto la señal de latch (bit 1) para mostrar en paralelo los datos enviados en serie por los reg.
    nop
    bcf PORTC,latch
    return
    
    
CARGARFILA
    movf INDF,0
    movwf aux
LOOP1
    bcf PORTC,clk ;pongo en bajo el clock
    btfss aux,0 ;bit que siempre vamos a evaluar para enviar datos
    goto DATOCERO
    goto DATOUNO
DATOCERO
    bcf PORTC,dato ;dato = bit 2
    nop
    bsf PORTC,clk ;clock paso a alto, para enviar un dato a los registros
    rrf aux,1 ;corro a la izquierda un bit
    decfsz contCargaFila
    goto LOOP1
    movlw d'6'
    movwf contCargaFila ;vuelvo a cargar el contador
    return
    
DATOUNO
    bsf PORTC,dato ;dato = bit 2
    nop
    bsf PORTC,clk ;clock paso a alto, para enviar un dato a los registros
    rrf aux,1 ;corro a la izquierda un bit
    decfsz contCargaFila
    goto LOOP1
    movlw d'6'
    movwf contCargaFila ;vuelvo a cargar el contador
    return
    