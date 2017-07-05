.data
BRANCO: .word 0xFFFFFFFF
PRETO: .word 0x00000000

.text
	li $t9,0xFF009420	# Define posição inicial da bola
	
	li $a0,0

# Desenha bola
# $t9: posicao do canto superior esquerdo da bola (NAO ALTERAR)
# $t0: posicao do canto superior esquerdo da bola
# $t1: limite da direita a ser preenchido
# $t2: limite inferior a ser preenchido
# $t3: cor
# $a0: 0: limpar; 1: imprimir

LOOP:
	li $a0,0
	
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
	
VOLTA:	addi $t9,$t9,321	# Alterar esse valor de acordo com o angulo
	#subi $t9,$t9,319
	
	li $v0,32	
	li $a0,100		# Dorme por 10 ms
	syscall
	
	j LOOP
	
