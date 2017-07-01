# Imprimir tela de início; OK
# Loop pra iniciar o jogo se ler enter; OK

# Loop principal:
#	Resetar tela;
#	Verificar teclas pressionadas; OK
#	Imprimir/atualizar blocos;
#	Imprimir/atualizar raquetes;
#	Imprimir/atualizar bola;
#	Verificar colisões bola-raquete e bola-bloco;
#	Atualizar pontuação;
#	Atualizar timer; OK
#	Verificar condições de término de jogo; OK
#	Sleep; OK

# Verificar jogador com maior pontuação;
# Tela indicando jogador vencedor;
# Fim; OK

# Adicionar musica;
# Adicionar efeitos sonoros;


.data
	PLAYER1: .asciiz "PLAYER 1"
	PLAYER2: .asciiz "PLAYER 2"
	TIME: .asciiz "TIME"
	LEFT: .asciiz "LEFT:"
	ESPACOPRETO: .asciiz "  "	# Reseta o contador de segundos
	TELADEFIM: .asciiz "PRESS ENTER TO CONTINUE"
	NUM: .word 
	NOTAS: 62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000,   62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000,  62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000
	TELAINICIO: .asciiz "src/telainicio.bin"
	TELAVENCEDOR1: .asciiz "src/telavencedor1.bin"
	TELAVENCEDOR2: .asciiz "src/telavencedor2.bin"
	TELAEMPATE: .asciiz "src/telaempate.bin"
		
.text
# $s0: tempo restante em segundos
# $s3: auxiliar do timer
# $s1: pontuacao do jogador 1
# $s2: pontuacao do jogador 2


##### TELA DE INICIO #####
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
	
# Controle da musica
CONT:	la $s0,NUM
	lw $s1,0($s0)
	la $s0,NOTAS
	li $t0,0
	li $a2,65	#Instrumento
	li $a3,50	#Volume

# Verifica se enter for pressionado --> Ver pq n funciona no final da musica
ENTER:	la $t1,0xFF100000
  	lw $t2,4($t1)		# Tecla lida
  	beq $t2, 10, INICIO	# Se enter for pressionado, vai para jogo (enter e 10 na ascii)
	j MUSICA		# Continua no loop se enter nao for pressionado
	
# Notas da musica
MUSICA:	beq $t0,$s1, CONT
	lw $a0,0($s0)		#Nota
	lw $a1,4($s0)		#Duração
	li $v0,31		#31 (pausa mais curta)
	syscall
	move $a0,$a1		#sleep
	li $v0,32
	syscall
	addi $s0,$s0,8
	addi $t0,$t0,1
	j ENTER

# Fecha o arquivo
INICIO:	move $a0,$s1
	li $v0,16
	syscall
	

INICIO1:
##### INICIO DO JOGO #####
	li $s3, 0	# Inicia $s3 em 0 (auxiliar do timer)
	li $s0, 15	# Valor de $s3 = 90, tempo do jogo em segundos

# Preenche a tela de preto --> Mudar para carregar imagem de fundo do jogo
	jal PREENCHEPRETO

## Placares
# Inicia registradores do placar em 0	
PLACAR:	addi $s1,$zero,0	# Valor de $s1 = 0
	addi $s2,$zero,0	# Valor de $s2 = 0

# Placar do jogador 1
	la $a0,PLAYER1	# Endereco da P1
	li $a1,240	# Coluna
	li $a2,50	# Linha
	li $a3,0x00A3	# Cores da letra (A3) e fundo(00)
	li $v0,104	# print string	(do system53)
	syscall
	
# Placar do jogador 2
	la $a0,PLAYER2  # Endereco da P2
	li $a1,240	# Coluna
	li $a2,80	# Linha
	li $a3,0x002E	# Cores da letra (2E) e fundo(00)
	li $v0,104	# print string  (do system53)
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
	
# Imprime o tempo inicial
	la $a0,($s0)		# Imprime o tempo
	li $a1,290
	li $a2,130
	li $a3,0XFF
	li $v0,101		# print int (do system53)
	syscall


##### JOGO #####
JOGO:

# Pontuação do jogador 1
	la $a0,($s1)
	li $a1,240
	li $a2,60
	li $a3,0x00FF
	li $v0,101	# print int (do system53)
	syscall
	
# Pontuação do jogador 2 --> Fazer funcao pra atualizar a pontuacao do jogador apenas se houver colisao
	la $a0,($s2)
	li $a1,240
	li $a2,90
	li $a3,0X00FF
	li $v0,101	# print int (do system53)
	syscall
	
	
# Loop da contagem de segundos
	bne $s3, 100, ELSE	# So decrementa o tempo se passou 1s (estrutura if)
	
	la $a0, ESPACOPRETO	# Reseta o contador
	li $a1,290
	li $a2,130
	li $a3,0X00
	li $v0,104
	syscall
	
	subi $s0, $s0, 1	# Decrementa o tempo em 1
	beq $s0,-1,TELAFINAL	# Se tempo igual -1, vai pra tela final
	
	la $a0,($s0)		# Imprime o tempo
	li $a1,290
	li $a2,130
	li $a3,0XFF
	li $v0,101		# print int (do system53)
	syscall
	
	li $s3, 0
	j DONE

ELSE:	addi $s3, $s3, 1
	
DONE:

## Verifica teclas pressionadas
	la $t1,0xFF100000
  	lw $t2,4($t1)		# Tecla lida
 
# Jogador 1
Q: 	bne $t2,113,A		# Verifica se "q" (113) foi pressionado
	jal QLABEL

A:	bne $t2,97,S		# Verifica se "a" (97) foi pressionado
  	jal ALABEL
  	
S:	bne $t2,115,D		# Verifica se "s" (115) foi pressionado
	jal SLABEL
	
D:	bne $t2,100,P		# Verifica se "d" (100) foi pressionado
	jal DLABEL
	
# Jogador 2
P:	bne $t2,112,L		# Verifica se "p" (112) foi pressionado
	jal PLABEL
	
L:	bne $t2,108,J		# Verifica se "l" (108) foi pressionado
	jal LLABEL
	
J:	bne $t2,106,K		# Verifica se "j" (106) foi pressionado
	jal JLABEL

K:	beq $t2,107,KLABEL	# Verifica se "k" (107) foi pressionado
				# Se nao for igual "k" (107), continua
	
	
## Sleep pro main loop do jogo
	li $v0,32	
	li $a0,10		# Dorme por 10 ms
	syscall
	j JOGO	
	


##### TELA FINAL #####
TELAFINAL:

# Preenche a tela de preto --> Necessario? (ja imprimiremos a tela do vencedor logo apos)
	jal PREENCHEPRETO
	
TELA:
# Compara pontuacoes dos jogadores
	beq $s1, $s2, EMPATE	# Se $s1 = $s2, vai pra tela de empate
	
	slt $t0, $s1, $s2
	beq $t0, 1, VENCEDOR2	# Se $s1 < $s2, vai pra tela de vencedor 2
	
	 			# Se $s1 < $s2, vai pra tela de vencedor 1 

##  Tela de vitoria Player 1
# Abre o arquivo
VENCEDOR1:
	la $a0,TELAVENCEDOR1
	li $a1,0
	li $a2,0
	li $v0,13
	syscall
	j IMPRIMETELA
	
## Tela de vitoria Player 2
# Abre o arquivo
VENCEDOR2:
	la $a0,TELAVENCEDOR2
	li $a1,0
	li $a2,0
	li $v0,13
	syscall
	j IMPRIMETELA
	
## Tela de empate
# Abre o arquivo
EMPATE:	la $a0,TELAEMPATE
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
IMPRIMETELA:
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	
# Sleep por 5 segundos
	addi $a0, $zero, 5000
	li $v0,32
	syscall
	
# Fecha o arquivo
	move $a0,$s1
	li $v0,16
	syscall


## Continuar?
	la $a0,TELADEFIM
	li $a1,70
	li $a2,115
	li $a3,0x00FF
	li $v0,104
	syscall
		
# Tempo do fim
	li $s3,10	# Valor de $s3 = 10, valor dos segundos

TIMER2:	la $a0, ESPACOPRETO	# Reseta o contador
	li $a1,155
	li $a2,130
	li $a3,0X00
	li $v0,104
	syscall
	
	la $a0,($s3)		# Imprime o tempo
	li $a1,155
	li $a2,130
	li $a3,0XFF
	li $v0,101		# print int (do system53)
	syscall
	
	subi $s3, $s3, 1	# Decrementa o tempo em 1
	beq $s3,-1,FIM
	
	li $a0,1000	# Sleep por 1s
	li $v0,32
	syscall

# Verifica se enter for pressionado
	la $t1,0xFF100000
	lw $t2,4($t1)
  	beq $t2,10,INICIO1	# Se enter for pressionado, vai para a inicializacao do jogo
	j TIMER2		# Volta pro loop se enter nao foi pressionado


##### FIM #####
# Preenche tela de preto
FIM:	jal PREENCHEPRETO

 	li $v0, 10
	syscall


##### FUNCOES #####

## Define o que fazer com cada leitura do teclado
# Jogador 1:
QLABEL: # Cima
	j PARA1
	
ALABEL: # Baixo
	j PARA1

SLABEL: # Esquerda
	j PARA1

DLABEL:	# Direita
	j PARA1

# Jogador 2:
PLABEL:	# Cima
	j PARA1

LLABEL: # Baixo
	j PARA1

JLABEL:	# Esquerda
	j PARA1

KLABEL: # Direita
	j PARA1

PARA1:	jr $ra
	

## Preenche a tela de preto
PREENCHEPRETO:
	li $t0,0xFF012C00
	li $t2,0xFF000000
	li $t1,0x00000000
LOOP: 	beq $t2,$t0,PARA
	sw $t1,0($t2)
	addi $t2,$t2,4
	j LOOP

PARA:	jr $ra
