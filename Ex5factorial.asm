# Autor: Renan Luiz Babinski - Academico Ciência da Computação UFFS
#Programa em Assembly para calcular o fatorial de um número recursivamente
.data
	msg:		.asciiz		"Digite um numero para encontrar o fatorial:"
	msgResultado:	.asciiz		"O fatorial do número é "
	numero:		.word	0
	resposta:	.word	0
.text
	.globl main
	main:
	
	li $v0, 4
	la $a0, msg					#Imprime mensagem pedindo para o usuario digitar um numero
	syscall
	
	li $v0, 5					#Lendo o número do usuário
	syscall
	
	sw $v0, numero					#guarda valor informado pelo usuario em "numero"
	
	lw $a0, numero					#carrega o valor de "numero" para $a0
	jal Fatorial					#Chamar a função fatorial
	sw $v0, resposta				#Depois da recursão o resultado será armazenado em $v0
	
	li $v0, 4 
	la $a0, msgResultado				# Imprime mensagem de resultado
	syscall
	
	li $v0, 1
	lw $a0, resposta				#Imprime resultado
	syscall
	
	li $v0, 10					# Dizer para o SO que aqui é o fim do programa
	syscall
	
#####---------------------------------------------PROCEDIMENTO-----------------------------------------------------#####
#Função para encontrar o fatorial
.globl Fatorial
Fatorial:						#Função que calcula o fatorial de um numero recursivamente
	subu $sp, $sp, 8				#aloca 2 espaços de 4 bytes na pilha (PUSH)
	sw $ra, ($sp)					#guarda o endereço de retorno na pilha
	sw $s0, 4($sp)					#guarda o valor retornado pela função na pilha
	
	li $v0, 1
	beq $a0, 0, FatorialPronto			#criterio de parada, o numero irá decrescer até 0, quando isso acontecer, pare
		
	move $s0, $a0					#move o argumento da função para $s0 para que seja adicionado na pilha
	sub $a0, $a0, 1					#subtrai 1 do valor $a0 e chama a função novamente com o valor atualizado
	jal Fatorial					#chama a função Fatorial e guarda o endereço de retorno
	
	mul $v0, $s0, $v0				#multiplica $v0 com o próximo valor da pilha
	
	FatorialPronto:					
		lw $ra, ($sp)				#atualiza o valor de $ra para que a função saiba para qual endereço deve voltar
		lw $s0, 4($sp)				#atualiza $s0 para o proximo valor da pilha
		addu $sp, $sp, 8			#desaloca 2 espaços de bytes na pilha(POP)
		
			jr $ra				#retorna para o endereço que chamou a função
	