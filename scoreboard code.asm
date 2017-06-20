.data
	PLAYER1: .asciiz "P1"
	PLAYER2: .asciiz "P2"
.text
#Pinta o fundo de preto
	li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x00000000
LOOP: 	beq $s2,$t1,PLACAR1
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOP
	
	addi $t0,$zero,98 #Valor de $t0 = 0
	addi $t1,$zero,83 #Valor de $t1 = 0
	
#Placar do jogador 1
PLACAR1:la $a0,PLAYER1   #Endereco da P1
	li $a1,270	#Coluna
	li $a2,50	#Linha
	li $a3,0x00A3	#Cores da letra (A3) e fundo(00)
	li $v0,104	# print string	(do system53)
	syscall
#Pontuação do jogador 1
VALOR1:	la $a0,($t0)
	li $a1,270
	li $a2,60
	li $a3,0x00FF
	li $v0,101	#print int (do system53)
	syscall
	
#Placar do jogador 2
PLACAR2:la $a0,PLAYER2  #Endereco da P2
	li $a1,270	#Coluna
	li $a2,150	#Linha
	li $a3,0x002E	#Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
	syscall
#Pontuação do jogador 2
VALOR2: la $a0,($t1)
	li $a1,270
	li $a2,160
	li $a3,0X00FF
	li $v0,101	#print int (do system53)
	syscall
	