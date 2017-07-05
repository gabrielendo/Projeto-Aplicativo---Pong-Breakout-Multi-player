 .data
	NUM: .word 
	NOTAS: 62,500,62,400,67,700,67,400,69,400,67,400,65,400,67,700,62,400,62,300,67,700,67,400,69,400,67,400,65,400,69,400,67,700,62,400,62,400,62,400,71,800,67,300,62,300,62,300,62,300,71,600,69,300,71,400,72,700,62,300,62,300,62,300,62,2000

.text
	la $s0,NUM
	lw $s1,0($s0)
	la $s0,NOTAS
	li $t0,0
	li $a2,47	#Instrumento
	li $a3,50	#Volume
	
LOOP:	beq $t0,$s1, FIM
	lw $a0,0($s0)		#Nota
	lw $a1,4($s0)		#Duraçãoo
	li $v0,31		#31 (pausa mais curta)
	syscall
	move $a0,$a1		#sleep
	li $v0,32
	syscall
	addi $s0,$s0,8
	addi $t0,$t0,1
	j LOOP
	
FIM:	li $v0,10
	syscall