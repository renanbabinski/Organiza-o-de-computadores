#for(x = 0; x < 10; x++)
#    A[x] = B[x] + x;
		
		.data
	
vector_A:	.space    40
#vector_B:	.space    40
vector_B:	.word	  31, 5, -2, 5, -10, 11, 30, 7, 0, -6

	.text
main:
	la $s0, vector_A   		# S0 armazena A[0]
	la $s1, vector_B		# S1 armazena B[0]
	add  $s2, $zero, $zero		# S2 armazena x
teste:  slti $t0, $s2, 10		# testa condição de fimnal de laço
	beq  $t0, $zero, fim		
#prepara acesso a B[x]
	sll  $t1, $s2, 2		# multilica x por 4
#	add  $t1, $s2, $s2		# multiplica x por 2	
#	add  $t1, $t1, $t1		# multiplica x por 4	
	add  $t3, $s1, $t1		# calcula posição B[x]
#Acessa B[x]
	lw   $t2, 0($t3)		# le B[x]
#Soma	
	add  $t2, $t2, $s2		# faz B[x] + x
	
#prepara acesso a A[x]	
#	sll  $t1, $s2, 2		# multilica x por 4
#	add  $t1, $s2, $s2		# multiplica x por 2	
#	add  $t1, $t1, $t1		# multiplica x por 4	
	add  $t3, $s0, $t1		# calcula posição A[x]

#escreve em A[x]
	sw   $t2, 0($t3)		#escreve em A[x] 

#atualiza variavel de controle do laco	
	addi $s2, $s2, 1		# x = x + 1
	
	j    teste			# desvia para o teste
	
fim:  	


