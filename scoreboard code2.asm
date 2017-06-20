.data
	PLAYER1: .asciiz "Player 1"
	PLAYER2: .asciiz "Player 2"
	TIME:    .asciiz "Time"
	LEFT:	 .asciiz "Left:"
	
		
.text
#Pinta o fundo de preto
	li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x00000000
LOOP: 	beq $s2,$t1,PLACAR1
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOP
	PLACAR1:
	
	addi $t0,$zero,0	 #Valor de $t0 = 0
	addi $t2,$zero,0	 #Valor de $t2 = 0
	addi $t3,$zero,20	#Valor de $t3 = 90, valor dos segundos
	
#Placar do jogador 1
	la $a0,PLAYER1   #Endereco da P1
	li $a1,240	#Coluna
	li $a2,50	#Linha
	li $a3,0x00A3	#Cores da letra (A3) e fundo(00)
	li $v0,104	# print string	(do system53)
	syscall
#Pontuação do jogador 1
VALOR1:	la $a0,($t0)
	li $a1,240
	li $a2,60
	li $a3,0x00FF
	li $v0,101	#print int (do system53)
	syscall
	
#Placar do jogador 2
PLACAR2:la $a0,PLAYER2  #Endereco da P2
	li $a1,240	#Coluna
	li $a2,80	#Linha
	li $a3,0x002E	#Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
#Pontuação do jogador 2
VALOR2: la $a0,($t2)
	li $a1,240
	li $a2,90
	li $a3,0X00FF
	li $v0,101	#print int (do system53)
	syscall
	
	
	
	#Placar de tempo restante
Placar_De_Tempo:  la $a0,TIME  #Endereco da TIME
	li $a1,240	#Coluna
	li $a2,120	#Linha
	li $a3,0xFF	#Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
	
	la $a0,LEFT  #Endereco da TIME
	li $a1,240	#Coluna
	li $a2,130	#Linha
	li $a3,0xFF	#Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
	
	#Loop da contagem de segundos
	

	TIMER:
	
	la $a0,($t3)
	li $a1,290
	li $a2,130
	li $a3,0XFF
	li $v0,101	#print int (do system53)
	syscall
	addi $a0, $zero, 1000
	li $v0,32
	syscall
	
	subi $t3, $t3, 1
	beq $t3,$zero , FIM
	j TIMER




	FIM: 
	li $v0, 10
	syscall
	
	
	
