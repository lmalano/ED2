list P=16f887
    #include "p16f887.inc"

numero equ 0x20
Resultado equ 0x21
 
ORG 0x00
 
goto INICIO
 
 INICIO
 
 movlw b'0100'
 movwf numero
 bcf STATUS,0
 rrf numero,1
 xorwf numero,0
 movwf Resultado
 end

