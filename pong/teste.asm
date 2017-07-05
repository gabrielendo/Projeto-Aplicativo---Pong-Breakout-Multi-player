.data
BRANCO: .word 0xFFFFFFFF
PRETO: .word 0x00000000

.text
LOOP:
	li $v0,42		# Random int
	li $a1,3		# Limite superior do numero gerado
	li $a0,0		# $a0 contem numero gerado
	syscall
	
	li $a1,290
	li $a2,130
	li $a3,0XFF
	li $v0,101		# print int (do system53)
	syscall
	
	li $v0,32	
	li $a0,100		# Dorme por 10 ms
	syscall
	
	j LOOP
	
	
