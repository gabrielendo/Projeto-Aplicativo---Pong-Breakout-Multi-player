.data
	PLAYER1: .asciiz "Player 1"
	PLAYER2: .asciiz "Player 2"
	TIME: .asciiz "Time"
	LEFT: .asciiz "Left:"
	ESPAÇOPRETO: .asciiz "  "	# Reseta do contador de segunds
	TELAINICIO: .asciiz "telainicio.bin"
		
.text
### TELA DE INICIO ###
# Abre o arquivo
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

# Verifica se enter for pressionado
ENTER:	la $t1,0xFF100000
	lw $t0,0($t1)
	andi $t0,$t0,0x0001	# Le bit de Controle Teclado
  	lw $t2,4($t1)		# Tecla lida
  	addi $t3, $zero, 10	# Coloca 10 (ascii de enter) em $t3 para a comparacao seguinte
  	beq $t2, $t3, JOGO	# Se enter for pressionado, vai para jogo
	j ENTER			# Continua no loop se enter nao for pressionado

# Fecha o arquivo
JOGO:	move $a0,$s1
	li $v0,16
	syscall
	
	
### INICIO DO JOGO ###
# Preenche o fundo de preto
	li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x00000000
LOOP: 	beq $s2,$t1,PLACAR
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOP
	
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

addi $s3,$zero,15	# Valor de $s3 = 90, valor dos segundos

TIMER:	la $a0, ESPAÇOPRETO	# Reseta de contador
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
	