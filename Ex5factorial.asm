# Autor: Renan Luiz Babinski - Academico Ci�ncia da Computa��o UFFS
#Programa em Assembly para calcular o fatorial de um n�mero recursivamente
.data
	msg:		.asciiz		"Digite um numero para encontrar o fatorial:"
	msgResultado:	.asciiz		"O fatorial do n�mero � "
	numero:		.word	0
	resposta:	.word	0
.text
	.globl main
	main:
	
	li $v0, 4
	la $a0, msg					#Imprime mensagem pedindo para o usuario digitar um numero
	syscall
	
	li $v0, 5					#Lendo o n�mero do usu�rio
	syscall
	
	sw $v0, numero					#guarda valor informado pelo usuario em "numero"
	
	lw $a0, numero					#carrega o valor de "numero" para $a0
	jal Fatorial					#Chamar a fun��o fatorial
	sw $v0, resposta				#Depois da recurs�o o resultado ser� armazenado em $v0
	
	li $v0, 4 
	la $a0, msgResultado				# Imprime mensagem de resultado
	syscall
	
	li $v0, 1
	lw $a0, resposta				#Imprime resultado
	syscall
	
	li $v0, 10					# Dizer para o SO que aqui � o fim do programa
	syscall
	
#####---------------------------------------------PROCEDIMENTO-----------------------------------------------------#####
#Fun��o para encontrar o fatorial
.globl Fatorial
Fatorial:						#Fun��o que calcula o fatorial de um numero recursivamente
	subu $sp, $sp, 8				#aloca 2 espa�os de 4 bytes na pilha (PUSH)
	sw $ra, ($sp)					#guarda o endere�o de retorno na pilha
	sw $s0, 4($sp)					#guarda o valor retornado pela fun��o na pilha
	
	li $v0, 1
	beq $a0, 0, FatorialPronto			#criterio de parada, o numero ir� decrescer at� 0, quando isso acontecer, pare
		
	move $s0, $a0					#move o argumento da fun��o para $s0 para que seja adicionado na pilha
	sub $a0, $a0, 1					#subtrai 1 do valor $a0 e chama a fun��o novamente com o valor atualizado
	jal Fatorial					#chama a fun��o Fatorial e guarda o endere�o de retorno
	
	mul $v0, $s0, $v0				#multiplica $v0 com o pr�ximo valor da pilha
	
	FatorialPronto:					
		lw $ra, ($sp)				#atualiza o valor de $ra para que a fun��o saiba para qual endere�o deve voltar
		lw $s0, 4($sp)				#atualiza $s0 para o proximo valor da pilha
		addu $sp, $sp, 8			#desaloca 2 espa�os de bytes na pilha(POP)
		
			jr $ra				#retorna para o endere�o que chamou a fun��o
	