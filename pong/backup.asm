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













## Bola 1
CRIABOLA1:
	li $v0,42		# Random int
	li $a1,8		# Limite superior do numero gerado
	li $a0,0		# $a0 contem numero aleatorio gerado
	syscall
	
ANG1.0:	bne $a0,0,ANG1.1
	li $t8,-318

ANG1.1:	bne $a0,1,ANG1.2
	li $t8,-319

ANG1.2:	bne $a0,2,ANG1.3
	li $t8,-321
	
ANG1.3:	bne $a0,3,ANG1.4
	li $t8,-322
	
ANG1.4:	bne $a0,4,ANG1.5
	li $t8,318
	
ANG1.5:	bne $a0,5,ANG1.6
	li $t8,319
	
ANG1.6:	bne $a0,6,ANG1.7
	li $t8,321
	
ANG1.7:	bne $a0,7,CRIABOLA1FIM
	li $t8,322
	
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
	li $t6,-318

ANG2.1:	bne $a0,1,ANG2.2
	li $t6,-319

ANG2.2:	bne $a0,2,ANG2.3
	li $t6,-321
	
ANG2.3:	bne $a0,3,ANG2.4
	li $t6,-322
	
ANG2.4:	bne $a0,4,ANG2.5
	li $t6,318
	
ANG2.5:	bne $a0,5,ANG2.6
	li $t6,319
	
ANG2.6:	bne $a0,6,ANG2.7
	li $t6,321
	
ANG2.7:	bne $a0,7,CRIABOLA2FIM
	li $t6,322

CRIABOLA2FIM:
	li $t7,0xFF009534	# Define a posicao inicial da bola 2, no centro
	
	j DESENHABOLA2