.data
Branco:  .word 0xffffffff

.text



RAQUETE1:
#PRIMEIRA RAQUETE
	li $t1,0xFF00ACA4 #POSI��O Y INICIAL
	li $s2,0xFF0070A4 #POSI��O Y FINAL	
	lw $s1,Branco	  #cor da raquete

LOOPR1: #LOOP RAQUETE 1
	beq $s2,$t1,RAQUETE2
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPR1
	
RAQUETE2:
#SEGUNDA RAQUETE
	li $t1,0xFF00AD48 #POSI��O Y INICIAL
	li $s2,0xFF007148 #POSI��O Y FINAL	
	lw $s1,Branco	  #cor da raquete

LOOPSR1: #LOOP RAQUETE 1
	beq $s2,$t1,BOLINHA
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPSR1
	
	
BOLINHA: #BOLINHA1
	li $s2,0xFF004538 #POSI��O Y INICIAL
	li $t1,0xFF005078 #POSI��O Y FINAL	
	lw $s1,Branco	  #cor da bolinha

LOOPB1: #LOOP bolinha1
	beq $s2,$t1,BOLINHA1.2
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPB1

BOLINHA1.2: #segundo loop para aumentar a "expessura"
	li $s2,0xFF00453C	#posi��o Yi + 4(deslocamento no eixo X)							
	li $t1,0xFF00507C	#posi��o Yf + 4(deslocamento no eixo X)
	lw $s1,Branco
	
LOOPB2: beq $s2,$t1,new
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPB2
new:


#BARRINHAS VERTICAIS E BOLINHA
	li $t5, 0 # utilizado como "contador"
	RAQUETEv1:

#PRIMEIRA RAQUETE vertical
	li $s2,0xFF002AF8 #POSI��O X INICIAL
	li $t1,0xFF002B28 #POSI��O X FINAL	
	lw $s1,Branco	  #cor da raquete

LOOVPR1: #LOOP RAQUETE 1
	beq $s2,$t1,RAQUETEv1.2
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOVPR1	
	
	RAQUETEv1.2:
	sub $s2, $s2, 48 #retorna o valor anterior do x inicial(Xf-48 pixels)
	#aumenta expessura
	
	addi $s2, $s2,0x140
	addi $t1, $t1, 0x140  #soma 320(pula linha y)
	beq $t5, 3, RAQUETEV2 #o segundo numero determina a quantidade de loops("EXPESSURA")
	addi $t5,$t5, 1  
	j LOOVPR1
	
	
	RAQUETEV2:
	#segunda raquete vertical
	li $t5, 0 # utilizado como "contador"
	
	li $s2,0xFF00FF78 #POSI��O X INICIAL
	li $t1,0xFF00FFA8 #POSI��O X FINAL	
	lw $s1,Branco	  #cor da raquete


LOOVPR2: #LOOP RAQUETE 2

	beq $s2,$t1,RAQUETEv2.2
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOVPR2	
	
	RAQUETEv2.2:
	sub $s2, $s2, 48 #retorna o valor anterior do x inicial(Xf-48 pixels)
	#aumenta expessura
	
	addi $s2, $s2,0x140
	addi $t1, $t1, 0x140  #soma 320(pula linha y)
	beq $t5, 3, next #o segundo numero determina a quantidade de loops("EXPESSURA")
	addi $t5,$t5, 1  
	j LOOVPR2
	
	
	next:
