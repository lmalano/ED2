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


    org 0x100
BUSCARFILA
    movlw b'00000001'
    movwf PCLATH
    movlw d'32'
    subwf INDF,0 ; resto 32 al valor de char 1,2,3,4 o 5 para poder acceder a una tabla (en ASCII, 16 = 48 , si se resta, accederemos al caracter nro 0 (el 0))
TABLA
    addwf PCL ; le sumo el resultado de la resta a PCL para acceder a un determinado valor de la tabla
    goto ESPACIO	; " "
    goto EXCL		; "!"
    goto COMILLAD	; """
    goto NUM		; "#"
    goto PESO		; "$"
    goto PORCENTAJE	; "%"
    goto AMPERSAND	; "&"
    goto COMILLAS	; "'"
    goto PARENTESISAB	; "("
    goto PARENTESISCER	; ")"
    goto AST		; "*"
    goto MAS		; "+"
    goto COMA		; ","
    goto MENOS		; "-"
    goto PUNTO		; "."
    goto BARRA		; "/"
    goto CERO		; "0"
    goto UNO		; "1"
    goto DOS		; "2"
    goto TRES
    goto CUATRO
    goto CINCO
    goto SEIS
    goto SIETE
    goto OCHO
    goto NUEVE
    goto DOSPT		; ":"
    goto PTCOMA		; ";"
    goto MENOR		; "<"
    goto IGUAL		; "="
    goto MAYOR		; ">"
    goto PREGUNTAC	; "?"
    goto ARROBA		; "@"
    goto A		; "A"
    goto BE		; "B"
    goto CE
    goto DEE
    goto E
    goto EFE
    goto G
    goto H
    goto I
    goto J
    goto K
    goto L
    goto M
    goto N
    goto O
    goto PE
    goto Q
    goto ERE
    goto ESE
    goto T
    goto U
    goto V
    goto WW
    goto X
    goto Y
    goto ZETA
    
ESPACIO
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    
EXCL
    movf numFila,0
    addwf PCL,1
    retlw b'00001100'
    retlw b'00001100'
    retlw b'00001100'
    retlw b'00001100'
    retlw b'00001100'
    retlw b'00000000'
    retlw b'00001100'
    retlw b'00001100'
    
COMILLAD
    movf numFila,0
    addwf PCL,1
    retlw b'00100100'
    retlw b'00100100'
    retlw b'00100100'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    
NUM
    movf numFila,0
    addwf PCL,1
    retlw b'00001010'
    retlw b'00001010'
    retlw b'00011111'
    retlw b'00001010'
    retlw b'00001010'
    retlw b'00011111'
    retlw b'00001010'
    retlw b'00001010'
    
PESO
    movf numFila,0
    addwf PCL,1
    retlw b'00000100'
    retlw b'00001110'
    retlw b'00010101'
    retlw b'00010100'
    retlw b'00001110'
    retlw b'00000101'
    retlw b'00011110'
    retlw b'00000100'
    
PORCENTAJE
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00011000'
    retlw b'00011001'
    retlw b'00000010'
    retlw b'00000100'
    retlw b'00001000'
    retlw b'00010011'
    retlw b'00000011'
    
AMPERSAND
    movf numFila,0
    addwf PCL,1
    retlw b'00001100'
    retlw b'00010010'
    retlw b'00010010'
    retlw b'00001101'
    retlw b'00011110'
    retlw b'00010010'
    retlw b'00010010'
    retlw b'00001101'
    
COMILLAS
    movf numFila,0
    addwf PCL,1
    retlw b'00001000'
    retlw b'00001000'
    retlw b'00001000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    
PARENTESISAB
    movf numFila,0
    addwf PCL,1
    retlw b'00000111'
    retlw b'00001100'
    retlw b'00011000'
    retlw b'00011000'
    retlw b'00011000'
    retlw b'00011000'
    retlw b'00001100'
    retlw b'00000111'
    
PARENTESISCER
    movf numFila,0
    addwf PCL,1
    retlw b'00011100'
    retlw b'00000110'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000110'
    retlw b'00011100'
    
AST
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00010101'
    retlw b'00001110'
    retlw b'00011111'
    retlw b'00011111'
    retlw b'00001110'
    retlw b'00010101'
    retlw b'00000000'
    
MAS
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00011111'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000000'
    retlw b'00000000'
    
COMA
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000011'
    retlw b'00000001'
    retlw b'00000010'
    
MENOS
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00011111'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    
PUNTO
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00001110'
    retlw b'00001110'
    retlw b'00001110'
    
BARRA
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000001'
    retlw b'00000011'
    retlw b'00000110'
    retlw b'00001100'
    retlw b'00011000'
    retlw b'00110000'
    retlw b'00100000'
    
org 0x200
CERO
    movlw b'00000010'
    movwf PCLATH
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
    movlw b'00000010'
    movwf PCLATH
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
    movlw b'00000010'
    movwf PCLATH
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
    
TRES
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00000110'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00010001'
    retlw b'00001110'
    
CUATRO
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000010'
    retlw b'00000110'
    retlw b'00001010'
    retlw b'00010010'
    retlw b'00011111'
    retlw b'00000010'
    retlw b'00000010'
    retlw b'00000010'
    
CINCO
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011110'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00010001'
    retlw b'00001110'
    
SEIS
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
    
SIETE
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00000010'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    
OCHO
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
    
NUEVE
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001111'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00001110'
    
DOSPT
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00001110'
    retlw b'00001110'
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00001110'
    retlw b'00001110'
    retlw b'00001110'
    
PTCOMA
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00000011'
    retlw b'00000011'
    retlw b'00000000'
    retlw b'00000011'
    retlw b'00000001'
    retlw b'00000010'
    
MENOR
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000010'
    retlw b'00000110'
    retlw b'00001100'
    retlw b'00011000'
    retlw b'00001100'
    retlw b'00000110'
    retlw b'00000010'
    
IGUAL
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00000000'
    retlw b'00011111'
    retlw b'00011111'
    retlw b'00000000'
    retlw b'00011111'
    retlw b'00011111'
    retlw b'00000000'
    
MAYOR
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00001000'
    retlw b'00001100'
    retlw b'00000110'
    retlw b'00000011'
    retlw b'00000110'
    retlw b'00001100'
    retlw b'00001000'
    
PREGUNTAC
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00011011'
    retlw b'00000011'
    retlw b'00000110'
    retlw b'00001100'
    retlw b'00001100'
    retlw b'00000000'
    retlw b'00001100'
    
ARROBA
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000000'
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010111'
    retlw b'00010101'
    retlw b'00010111'
    retlw b'00010000'
    retlw b'00001110'
    
A
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011111'
    retlw b'00011111'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    
BE
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011110'
    
CE
    movlw b'00000010'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010001'
    retlw b'00001110'
    
org 0x300
    
DEE
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011110'
    
E
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011110'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011111'
    
EFE
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011110'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    
G
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010000'
    retlw b'00011111'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
   

H
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011111'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    
I
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    
J
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00000010'
    retlw b'00000010'
    retlw b'00000010'
    retlw b'00000010'
    retlw b'00000010'
    retlw b'00010010'
    retlw b'00001100'
    
K
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010010'
    retlw b'00010100'
    retlw b'00011000'
    retlw b'00011000'
    retlw b'00010100'
    retlw b'00010010'
    retlw b'00010001'
    
L
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00011111'
    
M
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00011011'
    retlw b'00011011'
    retlw b'00010101'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    
N
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00011001'
    retlw b'00011001'
    retlw b'00010101'
    retlw b'00010011'
    retlw b'00010011'
    retlw b'00010011'
    retlw b'00010001'
    
O
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
    
PE
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011110'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    retlw b'00010000'
    
Q
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010101'
    retlw b'00010101'
    retlw b'00001110'
    retlw b'00000010'
    retlw b'00000010'
    
ERE
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011110'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00011110'
    retlw b'00010010'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    
ESE
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00001110'
    retlw b'00010001'
    retlw b'00010000'
    retlw b'00001110'
    retlw b'00000001'
    retlw b'00000001'
    retlw b'00010001'
    retlw b'00001110'
    
T
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    
U
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001110'
    
V
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001010'
    retlw b'00000100'
    
WW
    movlw b'00000011'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010101'
    retlw b'00010101'
    retlw b'00011011'
    retlw b'00011011'
    retlw b'00010001'
    
org 0x400
    
X
    movlw b'00000100'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001010'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00001010'
    retlw b'00010001'
    retlw b'00010001'
    
Y
    movlw b'00000100'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00010001'
    retlw b'00001010'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    retlw b'00000100'
    
ZETA
    movlw b'00000100'
    movwf PCLATH
    movf numFila,0
    addwf PCL,1
    retlw b'00011111'
    retlw b'00000001'
    retlw b'00000011'
    retlw b'00000110'
    retlw b'00001100'
    retlw b'00011000'
    retlw b'00010000'
    retlw b'00011111'

    

HABILITARFILA
    movlw b'00000100'
    movwf PCLATH
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