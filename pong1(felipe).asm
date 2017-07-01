.data
	PLAYER1: .asciiz "Player 1"
	PLAYER2: .asciiz "Player 2"
	TIME: .asciiz "Time"
	LEFT: .asciiz "Left:"
	ESPAÇOPRETO: .asciiz "  "	# Reseta o contador de segundos
	TELAINICIO: .asciiz "telainicio.bin"
	TELAINICIO1: .asciiz "telainicio1.bin"
	Branco:  .word 0xffffffff
	hex: .word 0xff000000
	backgroundColor: .word 0x00000000
	BARRASGERAIS: .asciiz "barrasgerais.bin"
		
		
.text
### TELA DE INICIO ###



# Abre o arquivo
inicio:
	la $a0,TELAINICIO
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	
	

	ENTER:	la $t1,0xFF100000
	lw $t0,0($t1)
	andi $t0,$t0,0x0001	# Le bit de Controle Teclado
  	lw $t2,4($t1)		# Tecla lida
  	addi $t3, $zero, 10	# Coloca 10 (ascii de enter) em $t3 para a comparacao seguinte
  	beq $t2, $t3, JOGO	# Se enter for pressionado, vai para jogo
	j ENTER	
	

	# Verifica se enter for pressionado
	# Continua no loop se enter nao for pressionado

	
	
### INICIO DO JOGO ###

JOGO: 
# Preenche o fundo de preto + carrega as barras

	la $a0,BARRASGERAIS
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	
	j RAQUETE1
	
	RAQUETE1:

#PRIMEIRA RAQUETE

	li $t1,0xFF00ACA4 #POSIÇÃO Y INICIAL
	li $s2,0xFF0070A4 #POSIÇÃO Y FINAL	
	lw $s1,Branco	  #cor da raquete
	
	
	
	
	


LOOPR1: #LOOP RAQUETE 1

	beq $s2,$t1,RAQUETE2
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPR1
	

	
RAQUETE2:

#SEGUNDA RAQUETE

	li $t1,0xFF00AD48 #POSIÇÃO Y INICIAL
	li $s2,0xFF007148 #POSIÇÃO Y FINAL	
	lw $s1,Branco	  #cor da raquete


LOOPSR1: #LOOP RAQUETE 1

	beq $s2,$t1,BOLINHA
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPSR1
	



BOLINHA:
	
	#BOLINHA1

	li $s2,0xFF004538 #POSIÇÃO Y INICIAL
	li $t1,0xFF005078 #POSIÇÃO Y FINAL	
	lw $s1,Branco	  #cor da bolinha

LOOPB1: #LOOP bolinha1

	beq $s2,$t1,BOLINHA1.2
	sw $s1,0($s2)
	addi $s2,$s2,320
	j LOOPB1

BOLINHA1.2: #segundo loop para aumentar a "expessura"

	li $s2,0xFF00453C	#posição Yi + 4(deslocamento no eixo X)							
	li $t1,0xFF00507C	#posição Yf + 4(deslocamento no eixo X)
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

	li $s2,0xFF002AF8 #POSIÇÃO X INICIAL
	li $t1,0xFF002B28 #POSIÇÃO X FINAL	
	li $s1,0xFF9999	  #cor da raquete


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
	
	li $s2,0xFF00FF78 #POSIÇÃO X INICIAL
	li $t1,0xFF00FFA8 #POSIÇÃO X FINAL	
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



	
PLACAR:	addi $t0,$zero,0	# Valor de $t0 = 0
	addi $t2,$zero,0	# Valor de $t2 = 0
	
# Placar do jogador 1
	la $a0,PLAYER1	# Endereco da P1
	li $a1,240	# Coluna
	li $a2,50	# Linha
	li $a3,0x00A3	# Cores da letra (A3) e fundo(00)
	li $v0,104	# print string	(do system53)
	syscall
# Pontuação do jogador 1
	la $a0,($t0)
	li $a1,240
	li $a2,60
	li $a3,0x00FF
	li $v0,101	# print int (do system53)
	syscall
	
# Placar do jogador 2
	la $a0,PLAYER2  # Endereco da P2
	li $a1,240	# Coluna
	li $a2,80	# Linha
	li $a3,0x002E	# Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
# Pontuação do jogador 2
	la $a0,($t2)
	li $a1,240
	li $a2,90
	li $a3,0X00FF
	li $v0,101	# print int (do system53)
	syscall
		
	
# Placar de tempo restante
	la $a0,TIME	# Endereco da TIME
	li $a1,240	# Coluna
	li $a2,120	# Linha
	li $a3,0xFF	# Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
	
	la $a0,LEFT	# Endereco da TIME
	li $a1,240	# Coluna
	li $a2,130	# Linha
	li $a3,0xFF	# Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
	
#Loop da contagem de segundos

addi $s3,$zero,90	# Valor de $s3 = 90, valor dos segundos

TIMER:	la $a0, ESPAÇOPRETO	# Reseta o contador
	li $a1,290
	li $a2,130
	li $a3,0X00
	li $v0,104
	syscall
	
	la $a0,($s3)		# Imprime o tempo
	li $a1,290
	li $a2,130
	li $a3,0XFF
	li $v0,101		# print int (do system53)
	syscall
	
	addi $a0, $zero, 1000	# Sleep por 1s
	li $v0,32
	syscall
	
	subi $s3, $s3, 1	# Decrementa o tempo em 1
	beq $s3,-1 , FIM
	j TIMER
	
	
FIM: 	li $v0, 10
	syscall
	
