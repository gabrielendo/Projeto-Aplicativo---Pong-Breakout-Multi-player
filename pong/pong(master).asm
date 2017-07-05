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
#	Verificar condições de termino de jogo; OK
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
	NOTASI: 62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000,   62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000,  62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000
	NOTASF: 62,500,62,300,67,700,67,300,69,300,67,300,65,300,67,500,62,300,62,500,67,500,67,300,69,300,67,300,65,300,69,300,67,500,62,300,62,300,62,300,71,600,67,200,62,200,62,200,62,200,71,400,69,200,71,200,72,500,62,200,62,200,62,200,62,2000
	TELAINICIO: .asciiz "src/telainicio.bin"
	TELAVENCEDOR1: .asciiz "src/telavencedor1.bin"
	TELAVENCEDOR2: .asciiz "src/telavencedor2.bin"
	TELAEMPATE: .asciiz "src/telaempate.bin"
	hex: .word 0xff000000
	backgroundColor: .word 0x00000000
	BRANCO: .word 0xFFFFFFFF
	PRETO: .word 0x00000000
	cor1: .word 0xA3A3A3A3
	cor2: .word 0x2E2E2E2E
	BARRASGERAIS: .asciiz "src/barrasgerais.bin"
				
#inicial raquete vertical 1(esquerda): 0xFF0070A4
#inicial raquete vertical 2(direita): 0xFF00AD48 

.text
# $s0: tempo restante em segundos
# $s3: auxiliar do timer
# $s1: pontuacao do jogador 1
# $s2: pontuacao do jogador 2
# $s4: posicao da raquete de cima (P1)
# $s5: posicao da raquete da direita (P2)
# $s6: posicao da raquete de baixo (P2)
# $s7: posicao da raquete da esquerda (P1)
# $t9: posicao da bola 1
# $t8: angulo da trajetoria da bola 1 
# $t7: posicao da bola 2
# $t6: angulo da trajetoria da bola 2

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
	la $s0,NOTASI
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
	
# Cria nova bola
	li $a0,1	# cor branca
	jal CRIABOLA1
	jal CRIABOLA2
	
# Cria raquetes
	jal RAQUETEV1
	jal RAQUETEV2
	jal RAQUETEH1
	jal RAQUETEH2

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
	

## Apaga bolas, verifica colisoes, e ja atualiza bolas
	li $a0,0		# Imprime preto (apaga)
	jal DESENHABOLA1
	jal DESENHABOLA2

	li $a0,1		# Imprime branco (imprime)
	jal COLISAO1
	jal COLISAO2	
	
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
	
# Musica da tela de fim
	la $s0,NUM
	lw $s1,0($s0)
	la $s0,NOTASF
	li $t0,0
	li $a2,65	#Instrumento
	li $a3,50	#Volume
	
	addi $t3,$zero,33
MFIM:	beq $t3,$t0,AQUI
	lw $a0,0($s0)		#Nota
	lw $a1,4($s0)		#Duração
	li $v0,31		#31 (pausa mais curta)
	syscall
	move $a0,$a1		#sleep
	li $v0,32
	syscall
	addi $s0,$s0,8
	addi $t0,$t0,1
	j MFIM
	
# Fecha o arquivo
AQUI:	move $a0,$s1
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

### Define o que fazer com cada leitura do teclado
# $s4: posicao da raquete de cima (P1)
# $s5: posicao da raquete da direita (P2)
# $s6: posicao da raquete de baixo (P2)
# $s7: posicao da raquete da esquerda (P1)

# Jogador 1:
QLABEL: # Cima
	move $t4,$s7
	li $t3,1
	j CH1
	
ALABEL: # Baixo
	move $t4,$s7
	li $t3,1
	j DH1

SLABEL: # Esquerda
	li $t3,1

DLABEL:	# Direita
	li $t3,1

# Jogador 2:
PLABEL:	# Cima
	move $t4,$s5
	li $t3,2
	j CH1

LLABEL: # Baixo
	move $t4,$s5
	li $t3,2
	j DH1

JLABEL:	# Esquerda
	li $t3,2

KLABEL: # Direita
	li $t3,2
	

### Preenche a tela de preto
PREENCHEPRETO:
	li $t0,0xFF012C00
	li $t2,0xFF000000
	li $t1,0x00000000
LOOP: 	beq $t2,$t0,PARA
	sw $t1,0($t2)
	addi $t2,$t2,4
	j LOOP

PARA:	jr $ra


### Colisao
# $t0: 0: sem colisao; 1: colisao lateral; 2: colisao cima-baixo

## Bola 1
COLISAO1:
# se colisao raquete bola:
	j ATUALIZABOLA1
	
# Bola 2
COLISAO2:
# se colisao raquete bola:
	j ATUALIZABOLA2


### Atualiza bola
# $t9: posicao do canto superior esquerdo da bola 1 (NAO ALTERAR)
# $t8: angulo da bola 1
# $t7: posicao do canto superior esquerdo da bola 2 (NAO ALTERAR)
# $t6: angulo da bola 2 
# $t0: bola 1: 0: sem colisao; 1: colisao lateral; 2: colisao cima-baixo
# $t1: bola 2: 0: sem colisao; 1: colisao lateral; 2: colisao cima-baixo

## Bola 1
ATUALIZABOLA1:
	beq $t0,0,SEMCOL1

C1.ANG0:	
	bne $t8,-318,C1.ANG1
	li $t8,-322
	j C1.FIM

C1.ANG1:	
	bne $t8,-319,C1.ANG2
	li $t8,-321
	j C1.FIM

C1.ANG2:	
	bne $t8,-321,C1.ANG3
	li $t8,-319
	j C1.FIM
	
C1.ANG3:	
	bne $t8,-322,C1.ANG4
	li $t8,-318
	j C1.FIM
	
C1.ANG4:	
	bne $t8,318,C1.ANG5
	li $t8,322
	j C1.FIM
	
C1.ANG5:	
	bne $t8,319,C1.ANG6
	li $t8,321
	j C1.FIM
	
C1.ANG6:	
	bne $t8,321,C1.ANG7
	li $t8,319
	j C1.FIM
	
C1.ANG7:	
	li $t8,318
	
C1.FIM:
	beq $t0,1,COLLAT1
	li $t1,-1		# Se for uma colisao cima-baixo, troca o sinal
	mult $t8,$t1
	mflo $t8
	
COLLAT1:
SEMCOL1:			# Se nao houver colisao, nao altera angulo
	add $t9,$t9,$t8		# adiciona $t8 a posicao da bola 1 $t9
	
	j DESENHABOLA1


## Bola 2
ATUALIZABOLA2:
	beq $t1,0,SEMCOL2

C2.ANG0:	
	bne $t6,-318,C2.ANG1
	li $t6,-322
	j C2.FIM

C2.ANG1:	
	bne $t6,-319,C2.ANG2
	li $t6,-321
	j C2.FIM

C2.ANG2:	
	bne $t6,-321,C2.ANG3
	li $t6,-319
	j C2.FIM
	
C2.ANG3:	
	bne $t6,-322,C2.ANG4
	li $t6,-318
	j C2.FIM
	
C2.ANG4:	
	bne $t6,318,C2.ANG5
	li $t6,322
	j C2.FIM
	
C2.ANG5:	
	bne $t6,319,C2.ANG6
	li $t6,321
	j C2.FIM
	
C2.ANG6:	
	bne $t6,321,C2.ANG7
	li $t6,319
	j C2.FIM
	
C2.ANG7:	
	li $t6,318
	
C2.FIM:
	beq $t1,1,COLLAT2
	li $t1,-1		# Se for uma colisao cima-baixo, troca o sinal
	mult $t6,$t1
	mflo $t6
	
COLLAT2:
SEMCOL2:			# Se nao houver colisao, nao altera angulo
	add $t7,$t7,$t6		# adiciona $t6 a posicao da bola 2, $t7
	
	j DESENHABOLA2


### Desenha bola
# $t9: posicao do canto superior esquerdo da bola 1 (NAO ALTERAR)
# $t7: posicao do canto superior esquerdo da bola 2 (NAO ALTERAR)
# $t0: posicao do canto superior esquerdo da bola (copia)
# $t1: limite da direita a ser preenchido
# $t2: limite inferior a ser preenchido
# $t3: cor
# $a0: 0: limpar; 1: imprimir

## Bola 1
DESENHABOLA1:
	move $t0,$t9		# Copia conteudo de $t9 para $t1
	addi $t1,$t0,8		# Define largura (largura desejada em pixels(de 4 em 4)) 
	addi $t2,$t0,2248	# Define altura ((320 * (altura desejada em pixels - 1)) + 8)
	
	beq $a0,0,LIMPAR1	# Se $a0 = 0, imprime preto; se $a1 = 1, imprime branco
	
	lw $t3,BRANCO
	j LOOP1.1
	
LIMPAR1:lw $t3,PRETO		

LOOP1.1:beq $t0,$t1,LOOP1.2
	sw $t3,0($t0)
	addi $t0,$t0,4
	j LOOP1.1

LOOP1.2:beq $t0,$t2,VOLTA1
	addi $t1,$t1,320
	addi $t0,$t0,312
	j LOOP1.1
	
VOLTA1:	jr $ra

## Bola 2
DESENHABOLA2:
	move $t0,$t7		# Copia conteudo de $t7 para $t1
	addi $t1,$t0,8		# Define largura (largura desejada em pixels(de 4 em 4)) 
	addi $t2,$t0,2248	# Define altura ((320 * (altura desejada em pixels - 1)) + 8)
	
	beq $a0,0,LIMPAR2	# Se $a0 = 0, imprime preto; se $a1 = 1, imprime branco
	
	lw $t3,BRANCO
	j LOOP2.1
	
LIMPAR2:lw $t3,PRETO		

LOOP2.1:beq $t0,$t1,LOOP2.2
	sw $t3,0($t0)
	addi $t0,$t0,4
	j LOOP2.1

LOOP2.2:beq $t0,$t2,VOLTA2
	addi $t1,$t1,320
	addi $t0,$t0,312
	j LOOP2.1
	
VOLTA2:	jr $ra


### Cria nova bola
# $t9: posicao da bola 1
# $t8: angulo da trajetoria da bola 1 
# $t7: posicao da bola 2
# $t6: angulo da trajetoria da bola 2

## Bola 1
CRIABOLA1:
	li $v0,42		# Random int
	li $a1,8		# Limite superior do numero gerado
	li $a0,0		# $a0 contem numero aleatorio gerado
	syscall
	
ANG1.0:	bne $a0,0,ANG1.1
	li $t8,-640

ANG1.1:	bne $a0,1,ANG1.2
	li $t8,-640

ANG1.2:	bne $a0,2,ANG1.3
	li $t8,-640
	
ANG1.3:	bne $a0,3,ANG1.4
	li $t8,-640
	
ANG1.4:	bne $a0,4,ANG1.5
	li $t8,640
	
ANG1.5:	bne $a0,5,ANG1.6
	li $t8,640
	
ANG1.6:	bne $a0,6,ANG1.7
	li $t8,640
	
ANG1.7:	bne $a0,7,CRIABOLA1FIM
	li $t8,640
	
CRIABOLA1FIM:
	li $t9,0xFF009534	# Define a posicao inicial da bola 1, no centro
	
	j DESENHABOLA1
	
# Bola 2
CRIABOLA2:
	li $v0,42		# Random int
	li $a1,8		# Limite superior do numero gerado
	li $a0,0		# $a0 contem numero aleatorio gerado
	syscall
	
ANG2.0:	bne $a0,0,ANG2.1
	li $t6,-640

ANG2.1:	bne $a0,1,ANG2.2
	li $t6,-640

ANG2.2:	bne $a0,2,ANG2.3
	li $t6,-640
	
ANG2.3:	bne $a0,3,ANG2.4
	li $t6,-640
	
ANG2.4:	bne $a0,4,ANG2.5
	li $t6,640
	
ANG2.5:	bne $a0,5,ANG2.6
	li $t6,640
	
ANG2.6:	bne $a0,6,ANG2.7
	li $t6,640
	
ANG2.7:	bne $a0,7,CRIABOLA2FIM
	li $t6,640

CRIABOLA2FIM:
	li $t7,0xFF009534	# Define a posicao inicial da bola 2, no centro
	
	j DESENHABOLA2
	
	
### Imprime raquetes
# Posicao inicial da raquete vertical 1(esquerda): 0xFF0070A4
# Posicao inicial da raquete vertical 2(direita): 0xFF00AD48
# Posicao inicial da raquete horizontal superior: 0xFF002AF8
# Posicao inicial da raquete horizontal inferior: 0xFF00FF78

## Verticais
# Raquete 1
RAQUETEV1:
	li $t1,0xFF00ACA4	# Posicao y final
	li $t2,0xFF0070A4	# Posicao y inicial	
	lw $t0,BRANCO		# Cor da raquete
	
	li $s7,0xFF0070A4	# Iniciando posicao da raquete
	

LOOPR1:				# Loop da raquete 1
	beq $t2,$t1,RAQUETE1.FIM
	sw $t0,0($t2)
	addi $t2,$t2,320
	j LOOPR1
	
RAQUETE1.FIM:
	jr $ra
	
# Raquete 2
RAQUETEV2:
	li $t1,0xFF00AD48	# Posicao y final
	li $t2,0xFF007148 	# Posicao y inicial	
	lw $t0,BRANCO		# Cor da raquete
	
	li $s5,0xFF007148	# Iniciando posicao da raquete


LOOPSR1:			# Loop da raquete 2
	beq $t2,$t1,RAQUETE2.FIM
	sw $t0,0($t2)
	addi $t2,$t2,320
	j LOOPSR1

RAQUETE2.FIM:
	jr $ra
	
	
## Horizontais
	li $t5, 0 # utilizado como "contador"

# Raquete 1
RAQUETEH1:
	li $t2,0xFF002AF8	# Posicao x inicial
	li $t1,0xFF002B28	# Posicao x final	
	lw $t0,BRANCO		# cor da raquete
	
	li $s4,0xFF002AF8	# Iniciando posicao da raquete


LOOVPR1:			# Loop da raquete 1

	beq $t2,$t1,RAQUETEv1.2
	sw $t0,0($t2)
	addi $t2,$t2,4
	j LOOVPR1	
	
	RAQUETEv1.2:
	sub $t2, $t2, 48	# retorna o valor anterior do x inicial(Xf-48 pixels)
				# aumenta expessura
	
	addi $t2,$t2,0x140
	addi $t1,$t1,0x140	# soma 320(pula linha y)
	beq $t5,3,RAQUETEH1.FIM	# o segundo numero determina a quantidade de loops("EXPESSURA")
	addi $t5,$t5,1  
	j LOOVPR1
	
RAQUETEH1.FIM:
	jr $ra

# Raquete 2
RAQUETEH2:	
	li $t5, 0		# utilizado como "contador"
	
	li $t2,0xFF00FF78	# Posicao x inicial
	li $t1,0xFF00FFA8	# Posicao x final	
	lw $t0,BRANCO	  	# Cor da raquete
	
	li $s6,0xFF00FF78	# Iniciando posicao da raquete


LOOVPR2: 			# Loop da raquete 2

	beq $t2,$t1,RAQUETEv2.2
	sw $t0,0($t2)
	addi $t2,$t2,4
	j LOOVPR2	
	
	RAQUETEv2.2:
	sub $t2,$t2,48		# retorna o valor anterior do x inicial(Xf-48 pixels)
				# aumenta expessura
	
	addi $t2,$t2,0x140
	addi $t1,$t1,0x140	# soma 320(pula linha y)
	beq $t5,3,RAQUETEH2.FIM	# o segundo numero determina a quantidade de loops("EXPESSURA")
	addi $t5,$t5, 1  
	j LOOVPR2
	
	
RAQUETEH2.FIM:
	jr $ra
	
	
### Movimentacao das raquetes
#inicial raquete vertical 1(esquerda): 0xFF0070A4
#inicial raquete vertical 2(direita): 0xFF00AD48 

## Verticais
# carregar em $t4 a posição da raquete (se atualiza sozinho)
# para subir carregue em $t4 e jal CH1 (subida)
# para descer carregue $t4 e jal DH1 (descida)
# $t3 contem o jogador (1 ou 2)

# Subida
CH1: 	lw $t1,PRETO 		# apaga 
	lw $t2,BRANCO		# imprime
	li $t5,0
	
CH:	addi $t0,$t4,4

LOOPCH1: 			# LOOP SOBE
	beq $t4,$t0,PulaCH1
	sw $t2,0($t4)
	addi $t4,$t4,1
	j LOOPCH1
	
PulaCH1: 			# pula linha (expessura)
	subi $t4,$t4,4
	subi $t4,$t4,320
	beq $t5,4,apagaCH1
	addi $t5,$t5,1
	j CH 			# retorna loop
	
apagaCH1:
	addi $t4,$t4,15360
	li $t5,0
	
CH2:	addi $t0,$t4,4

LOOPCH2:beq $t4,$t0,PulaCH2
	sw $t1,0($t4)
	addi $t4,$t4,1
	j LOOPCH2
	
PulaCH2:subi $t4,$t4,4
	addi $t4,$t4,320
	beq $t5,4,NextvalueC
	addi $t5,$t5,1
	j CH2
	
NextvalueC:			# retorna para $t4, a posição inicial da raquete
	subi $t4,$t4,16640
	
	beq $t3,1,SUBIDA.JOG1
	move $s5,$t4
	j SUBIDA.FIM
	
SUBIDA.JOG1:
	move $s7, $t4
	
SUBIDA.FIM:	
	jr $ra
	 
	 
## Descida	 
DH1:
	lw $t1,PRETO		# apaga 
	lw $t2,BRANCO		# imprime
	li $t5,0
	
DH:	addi $t0,$t4,4

LOOPDH1:			# LOOP DESCE 1
	beq $t4,$t0,PulaDH1
	sw $t1,0($t4)
	addi $t4,$t4,1
	j LOOPDH1
	
PulaDH1:subi $t4,$t4,4		# pula linha (expessura)
	addi $t4,$t4,320
	beq $t5,4,apagaDH1
	addi $t5,$t5,1
	j DH			# retorna loop
	
apagaDH1:
	addi $t4,$t4,13760
	li $t5,0
	
DH2:	addi $t0,$t4,4

LOOPDH2:beq $t4,$t0,PulaDH2
	sw $t2,0($t4)
	addi $t4,$t4,1
	j LOOPDH2
	
PulaDH2:subi $t4,$t4,4
	addi $t4,$t4,320
	beq $t5,4,NextvalueD
	addi $t5,$t5,1
	j DH2
	
NextvalueD: 			# retorna para $t4, a posição inicial da raquete
	subi $t4,$t4,15360
	
	beq $t3,1,DESCIDA.JOG1
	move $s5,$t4
	j DESCIDA.FIM
	
DESCIDA.JOG1:
	move $s7,$t4
	
DESCIDA.FIM:
	jr $ra
	
## Fazer funcao chamada pela funcao de leitura do teclado, que apaga um lado da raquete e printa do outro
# (utilizar args para sentido e qual raquete)

## Fazer funcao que detecta colisoes da bolinha: com a raquete e com os blocos

## Fazer funcao que calcula nova posicao da bolinha
# (utilizar args para sentido da bolinha e angulo da trajetoria)

## Fazer funcao que imprime preto sobre um bloco
# (utilizar args para localizacao inicial do bloco e se e horizontal ou vertical)
