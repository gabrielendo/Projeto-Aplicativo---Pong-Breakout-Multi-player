.data
BRANCO: .word 0xFFFFFFFF
PRETO: .word 0x00000000

.text
# j verifica colisão

## atualiza/imprime bolinha
#anterior FF009420
#centro 0xFF009560 

	li $t9,0xFF009420	# Define posição inicial da bola

## Cria nova bola
	li $v0,42		# Random int
	li $a1,3		# Limite superior do numero gerado
	li $a0,0
	syscall
	
	move $t8,$a0		# Salva em $t8 o angulo da bola
	
	li $t9,0xFF008F1C	# Define a posicao inicial da bola, no centro
	
	jr $ra


## Se teve colisao, vem para ca
#	bne $t8,0,L1
#	li $t0,332
#	j ATUALIZABOLA
	
#L1:	bne $t8,1,L2
#	li $t0,328
#	j ATUALIZABOLA
#
#L2:	bne $t8,2,L3
#	li $t0,324
#	j ATUALIZABOLA
#
#L3:	bne $t8,3
#	li $t0,320
#	j ATUALIZABOLA
	
#	sub $t9,$t9,$t0 #--> if para sub e add
#	add

#ATUALIZABOLA:

## Desenha bola
# $t9: posicao do canto superior esquerdo da bola (NAO ALTERAR)
# $t0: posicao do canto superior esquerdo da bola
# $t1: limite da direita a ser preenchido
# $t2: limite inferior a ser preenchido
# $t3: cor
# $a0: 0: limpar; 1: imprimir
DESENHABOLA:
	move $t0,$t9		# Copia conteudo de $t9 para $t1
	addi $t1,$t0,8		# Define largura (largura desejada em pixels(de 4 em 4)) 
	addi $t2,$t0,2248	# Define altura ((320 * (altura desejada em pixels - 1)) + 8)
	
	beq $a0,0,LIMPAR	# Se $a0 = 0, imprime preto; se $a1 = 1, imprime branco
	
	lw $t3,BRANCO
	j LOOP1
	
LIMPAR:	lw $t3,PRETO		

LOOP1:	beq $t0,$t1,LOOP2
	sw $t3,0($t0)
	addi $t0,$t0,4
	j LOOP1

LOOP2:	beq $t0,$t2,VOLTA
	addi $t1,$t1,320
	addi $t0,$t0,312
	j LOOP1
	
VOLTA:	jr $ra
	





