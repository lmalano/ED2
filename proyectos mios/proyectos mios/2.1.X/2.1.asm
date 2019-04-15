 LIST P=16F887
   #include <p16f887.inc> 
   
   SUM1 equ 21H
   SUM2 equ 22H
   RESL equ 23H
   RESH equ 24H   ;definicion de variables
   org 0
 
 INICIO
 
 movf	SUM1 ; cargo en w a sum1
 addwf  SUM2 ; sumo w (sum1) + sum2 y almaceno en w
 movwf RESL  ; muevo el resultado en el byte bajo
 clrf  RESH  ; byte alto =0
 btfsc STATUS,C ; verifica si existe carry, salta si no hay carry la siguiente instrucion
 incf RESH ; carry =1 ya que existe carry y cumple con la instrucion anterior

 
 END
 
 


