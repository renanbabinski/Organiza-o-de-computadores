# Autor: Renan Luiz Babinski - Academico Ciência da Computação UFFS
#Disciplina: Organização de Computadores
#Professor: Luciano Lores Caimi
#Simulador: MARS 4.5
#Programa em Assembly implementado para o jogo Campo Minado
#As bombas na matriz são representadas pelo número 9 que devem ser inseridos manualmente ou por uma função
#Como requisitado no trabalho, as bombas serão inseridas na matriz "campo" no local marcado no código abaixo ####INSERE BOMBAS AQUI######
#pela função insere_bombas que será implementada pelo professor
#Se desejar inserir as bombas manualmente, pode coloca-las na matriz "campo" abaixo

.data
	bemVindo:		.asciiz 	"Selecione a dificuldade do jogo:\n"
	newLine:		.asciiz 	"\n" 
	space:			.asciiz		" "
	facil:			.asciiz		"1 - facil (5x5) \n"
	medio:			.asciiz		"2 - medio (7x7) \n"
	dificil:		.asciiz		"3 - dificil (9x9) \n"
	jogue:			.asciiz 	"Escolha uma posição para fazer uma jogada:\n"
	jogueX:			.asciiz 	"Posição X: "
	jogueY:			.asciiz 	"Posição Y: "
	X:			.asciiz 	"X"
	loser:			.asciiz		"###########---VOCÊ PERDEU!---#############\n"
	winner:			.asciiz         "###########---PARABÉNS! VOCÊ VENCEU!---###########\n"
	
	campo: 			.word 		0, 0, 0, 0, 0, 0, 0, 0, 0,			#Fique a vontade para inserir bombas manualmente na matriz à esquerda
						0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 9, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 9, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0, 0
						
	gabarito:		.word 		0:81
	
.text
	
main: 	
	li $v0, 4
	la $a0, bemVindo								#mensagem inicio do jogo
	syscall
	
	li $v0, 4
	la $a0, facil									#mensagem opção facil
	syscall
	
	li $v0, 4
	la $a0, medio									#mensagem opção medio
	syscall
	
	li $v0, 4
	la $a0, dificil									#mensagem opção dificil
	syscall
	
	li $v0, 5									#lê a dificuldade selecionada
	syscall
	move $t0, $v0									#move o valor de entrada do usuário para $t0
	
	bne $t0, 1, branchMedio								#se a dificuldade selecionada é 1, a dimensão da matriz será 5
		addi $t0, $zero, 5							#coloca $t0 como valor 5
		j EndDificult
	branchMedio:
	bne $t0, 2, branchDificil							#se a dificuldade selecionada é 2, a dimensão da matriz será 7
		addi $t0, $zero, 7							#coloca $t0 como valor 7
		j EndDificult
	branchDificil:
	bne $t0, 3, EndDificult								#se a dificuldade selecionada é 3, a dimensão da matriz será 9
		addi $t0, $zero, 9							#coloca $t0 como valor 9
		j EndDificult
	EndDificult:
	
	###############INSERE BOMBAS AQUI##############								
	
	move $a1, $t0									#move $t0 para $a1 que será utilizado por funções posteriormente
	#jal imprimeMatriz								#função que imprime a matriz e as bombas inseridas - Pode ser oculta para jogar (para teste)
	jal calculaBombas								#chamada da função que calcula as posições adjacentes de cada bomba
	
	li $v0, 4
	la $a0, newLine									#Nova linha
	syscall
	
	#jal imprimeMatriz								#função que imprime a matriz com as bombas e adjacencia calculada - Pode ser oculta para jogar
											# (função de teste apenas)
	li $v0, 4
	la $a0, newLine									#Nova linha
	syscall

	addi $t1, $zero, 0								#seta $t1 como zero. Esse registrador será o controlador do fim de jogo
	jal imprimeMatrizJogo								#função que imprime a matriz com todas as posições não jogadas ocultas
	loopJogador:
	beq $t1, 1, fimJogo								#enquanto $t1 for diferente de 1, execute esse loop
		
		li $v0, 4
		la $a0, newLine								#Nova linha
		syscall
		
	 	li $v0, 4
		la $a0, jogue								#mensagem para o jogador escolher uma posição
		syscall
		
		li $v0, 4
		la $a0, jogueX								#mensagem para o jogador escolher a posição X
		syscall
		
	  	li $v0, 5								#lê posição escolhida pelo jogador
	  	syscall									
	   	move $t2, $v0								#coloca valor lido em $t2
	   	
	   	li $v0, 4
		la $a0, jogueY								#mensagem para o jogador escolher a posição Y
		syscall
		
		li $v0, 5								#lê posição escolhida pelo jogador
	  	syscall	
	   	move $t3, $v0								#coloca valor lido em $t3
	   	
	   	li $v0, 4
		la $a0, newLine								#Nova linha
		syscall
		
	    										#Como a matriz começa na posição 0 e o jogador escolhe a partir de 1
	    										#as 2 linhas seguintes subtraem 1 dos valores X e Y
	    	addi $t2, $t2, -1							#decrementa 1 de X
	     	addi $t3, $t3, -1							#decrementa 1 de Y
	     	
	     	move $a2, $t2								#Move a posição X para $a2 que será passado como argumento de função posteriormente
	     	move $a3, $t3								#Move a posição Y para $a3 que será passado como argumento de função posteriormente
	     	
	     	jal calculaIndice							#chamada de função que calcula a posição absoluta no vetor "campo" de acordo com o indice
	     	move $t4, $v1								#a função calculaIndice retorna em $v1. Copia $v1 para $t4.
	     								
	     	lw $t6, campo($t4)							#acessa a posição do vetor "campo" de acordo com o indice calculado anteriormente
	     	bne $t6, 9, branchBomba							#se a posição escolhida for uma bomba, execute abaixo
	     		
	     		li $v0, 4
	     		la $a0, loser							#imprime mensagem que o jogador perdeu pois selecionou uma bomba
	     		syscall
	     		
	     		addi $t1, $zero, 1						#seta o registrador de controle para 1, isso quebrará o loop
	     	branchBomba:
	     		addi $t5, $zero, 10						#se a posição escolhida não tiver bomba, insira o numero 10 no vetor "gabarito" (controle)
			sw $t5, gabarito($t4)						#insere 10 em "gabarito"
		branchBombaFim:
		jal verificaJogadas							#função que verifica se ainda há campos disponiveis para jogadas no vetor "gabarito"
		move $t7, $v1								#coloca o retorno da função acima em $t7
		bne $t7, 0, naoGanhou							#se não houver mais campos válidos o jogador venceu
			
			li $v0, 4							#imprime mensagem que o jogador venceu
	     		la $a0, winner
	     		syscall
	     		
	     		addi $t1, $zero, 1						#seta o registrador de controle para 1, isso quebrará o loop
		naoGanhou:	
		jal imprimeMatrizJogo							#função que imprime a matriz com os campos não jogados com X	
	 	j loopJogador								#retorna para o inicio do loop
	fimJogo: 		
						
	li $v0, 10									#fim do programa main
	syscall 

########----------- Funções -----------#########################################################################################################################

imprimeMatriz:										#função que imprime matriz, recebe a dimensão da matriz em $a1
	addi $t2, $zero, 0 								#contador de linha
	addi $t4, $zero, 0								#contador de indice
	imprimeLoop:								
	beq $a1, $t2, EndPrint								#enquanto $t2 for menor que a dimensão da matriz execute
		addi $t3, $zero, 0							#$zera registrador $t3
		imprimeLoopCol:
		beq $a1, $t3, endCol							#enquanto $t3 for menor que a dimensão da matriz execute
			lw $t5, campo($t4)						#carrega a posição do vetor de indice $t4
			
			li $v0, 1			
			move $a0, $t5							#imprime um inteiro
			syscall	
			
			li $v0, 4
			la $a0, space							#Espaço
			syscall
			
			addi $t3, $t3, 1						#add 1 em $t3
			addi $t4, $t4, 4						#incrementa indice do vetor
			j imprimeLoopCol						#retorna ao inicio do loop
		endCol:
		addi $t2, $t2, 1							#add 1 em $t3
		mul $t4, $t2, 36							#coloca em $t4 o indice da próxima linha da matriz
		
		li $v0, 4	
		la $a0, newLine								#Nova linha
		syscall
		
		j imprimeLoop								#retorna ao inicio da função

	EndPrint:
	jr $ra										#retorna para a função que chamou

calculaBombas:										#função que calcula as bombas adjacentes em todas as posições, recebe a dimensão da matriz em $a1
	addi $t2, $zero, 0
	loopLinha:
	beq $a1, $t2, endLinha								#enquanto $t2 for menor que a dimensão, execute
		addi $t3, $zero, 0							#zera o valor de $t3
		loopColuna:
		beq $a1, $t3, endColuna							#enquanto $t3 for menor que a dimensão
			addi $t4, $zero, 0 						#contador de bombas
			move $a2, $t2							#move valor de X(linha) para $a2
			move $a3, $t3							#move valor de Y(coluna) para $a3
			
			addi $sp, $sp, -4						
			sw $ra, 0($sp)
			jal calculaIndice						#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			move $t5, $v1							#coloca o retorno da função em $t5
			
			lw $t6, campo($t5)						#carrega em $t6 o valor do vetor campo de indice $t5
			beq $t6, 9, endIf						#se a posição no vetor não for uma bomba, faça o que está abaixo
				addi $t2, $t2, -1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4					
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest1					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End1				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End1:	
				endTest1:
				addi $t3, $t3, 1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest2					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
						
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End2				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End2:	
				endTest2:
				addi $t2, $t2, 1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest3					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End3				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End3:	
				endTest3:
				addi $t2, $t2, 1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest4					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End4				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End4:	
				endTest4:
				addi $t3, $t3, -1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest5					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End5				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End5:	
				endTest5:
				addi $t3, $t3, -1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest6					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End6				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End6:	
				endTest6:
				addi $t2, $t2, -1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest7					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
						
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End7				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End7:	
				endTest7:
				addi $t2, $t2, -1					#acessa uma posição adjacente de um campo da matriz
				move $a2, $t2						#passagem de parametros para a função valida Campo
				move $a3, $t3						#passagem de parametros para a função valida Campo
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal validaCampo						#guarda endereço de retorno para a main, chama a função validaCampo, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				beq $t7, 0, endTest8					#se a função validaCampo retornar 0, quer dizer que a posição que o programa esta tentando acessar é inválida
					move $a2, $t2					#move valor de X(linha) para $a2
					move $a3, $t3					#move valor de Y(coluna) para $a3
					
					addi $sp, $sp, -4
					sw $ra, 0($sp)
					jal calculaIndice				#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
					lw $ra, 0($sp)
					addi $sp, $sp, 4
					move $t5, $v1					#coloca o retorno da função em $t5
					
					lw $t6, campo($t5)				#carrega em $t6 o valor que está no vetor "campo" de indice $t5
					bne $t6, 9, End8				#se a posição for uma bomba, incremente o contador de bombas
						addi $t4, $t4, 1
					End8:	
				endTest8:
				addi $t2, $t2, 1					#retorna a posição de inicio
				addi $t3, $t3, 1					#retorna a posição de inicio
				move $a2, $t2						#passagem de parametros para a função calculaIndice
				move $a3, $t3						#passagem de parametros para a função calculaIndice
				
				addi $sp, $sp, -4
				sw $ra, 0($sp)
				jal calculaIndice					#guarda endereço de retorno para a main, chama a função calculaIndice, e resgata o valor de retorno da main
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				move $t7, $v1						#coloca o retorno da função em $t7
				
				sw $t4, campo($t7)					#guarda na matriz a quantidades de bombas adjacentes encontradas
			endIf:
			addi $t3, $t3, 1						#incrementa o contador $t3
			addi $s0, $zero, 9						#coloca o número 9 na matriz gabarito para identificar que nao é uma jogada válida
			sw $s0, gabarito($t5)						#guarda 9 na matriz gabarito
			j loopColuna							#volta ao inicio do loop
		endColuna:
		addi $t2, $t2, 1							#incrementa o contador $t2
		j loopLinha	
	endLinha:
	jr $ra										#retorno para a função main
		
calculaIndice:										#função que calcula o valor do indice, recebe $a2 e $a3 e retorna o resultado em $v1
	addi $v1, $zero, 0								#zera $v1
	mul $v1, $a2, 9									#multiplica a posição X por 9
	add $v1, $v1, $a3								#o resultado acima e somado com a posição Y
	mul $v1, $v1, 4									#multiplica o resultado por 4
	jr $ra										#retorna para quem chamou

validaCampo:										#função que testa se um campo da matriz é valido, se for retorna 1, se inválido retorna 0
	addi $v1, $zero, 1								#seta $v1 como 1
	bge $a2, 0, teste1								#testa se a Posição X é maior que 0
		addi $v1, $v1, -1
		j fim
	teste1:
	blt $a2, $a1, teste2								#testa se a Posição X é menor que a dimesão da matriz
		addi $v1, $v1, -1
		j fim
	teste2:
	bge $a3, 0, teste3								#testa se a Posição Y é maior que 0
		addi $v1, $v1, -1
		j fim
	teste3:
	blt $a3, $a1, fim								#testa se a Posição Y é menor que a dimensão da matriz
		addi $v1, $v1, -1
		j fim
	fim:
	jr $ra										#retorna para main
	
imprimeMatrizJogo:									#função que imprime matriz, recebe a dimensão da matriz em $a1
	addi $t2, $zero, 0 								#contador de linha
	addi $t4, $zero, 0								#contador indice
	addi $t7, $zero, 1								#coloca 1 em $t7 para uma impressão futura
	
	li $v0, 4
	la $a0, space									#Espaço
	syscall								
	
	li $v0, 4
	la $a0, space									#Espaço
	syscall
	
	li $v0, 4
	la $a0, space									#Espaço
	syscall
	
	loopIndice:
	bgt $t7, $a1, branchIndice							#loop para imprimir o indice para a matriz do jogador
		
		li $v0, 1
		move $a0, $t7								#imprime inteiro do indice
		syscall	
		
		li $v0, 4
		la $a0, space								#Espaço
		syscall
		
		addi $t7, $t7, 1							#adiciona 1 no loop
		j loopIndice
	branchIndice:
	
	li $v0, 4		
	la $a0, newLine									#Nova Linha
	syscall
	
	li $v0, 4
	la $a0, newLine									#Nova Linha
	syscall
	
	addi $t7, $zero, 1								#coloca 1 em $t7
	
	li $v0, 1
	move $a0, $t7									#imprime $t7
	syscall
	
	li $v0, 4
	la $a0, space									#Espaço
	syscall
	
	li $v0, 4
	la $a0, space									#Espaço
	syscall
	
	imprimeLoop2:								
	beq $a1, $t2, EndPrint2								#Enquanto $t2 for menor que a dimensão, execute
		addi $t3, $zero, 0							#seta $t3 com 0
		imprimeLoopCol2:
		beq $a1, $t3, endCol2							#Enquanto $t3 for menor que a dimensão , execute
			lw $t5, gabarito($t4)						#Carrega em $t5 o valor do vetor "gabarito" com indice $t4
			lw $t6, campo($t4)						#Carrega em $t6 o valor do vetor "campo" com indice $t4
			bne $t5, 10, branch						#se no vetor gabarito a posição tiver 10, essa posição deve ser mosrada para o jogador
				
				li $v0, 1	
				move $a0, $t6						#Imprime a posição que ja foi jogada para que o jogador veja
				syscall
				
				li $v0, 4
				la $a0, space						#Espaço
				syscall
				
				j finalIf
			branch:
				li $v0, 4
				la $a0, X						#Imprime um "X" onde o jogador ainda não fez jogadas
				syscall
				
				li $v0, 4
				la $a0, space						#Espaço
				syscall
				
			finalIf:
			addi $t3, $t3, 1						#incrementa 1 em $t3
			addi $t4, $t4, 4						#incrementa 4 no indice $t4
			j imprimeLoopCol2
		endCol2:
		addi $t2, $t2, 1							#incrementa $t2
		mul $t4, $t2, 36							#coloca em $t4 o indice da próxima linha da matriz
		
		li $v0, 4
		la $a0, newLine								#Nova Linha
		syscall
		
		beq $t2, $a1, pulaIndice						#loop que imprime os indices da matriz visiveis para o jogador
			addi $t2, $t2, 1						#incrementa $t2 para não mostrar o indice 0
			
			li $v0, 1		
			move $a0, $t2							#imprime indice
			syscall
			
			li $v0, 4
			la $a0, space							#Espaço	
			syscall
			
			li $v0, 4
			la $a0, space							#Espaço
			syscall
			
			addi $t2, $t2, -1						#decrementa $t2 para voltar ao indice original
		pulaIndice:
		j imprimeLoop2
	EndPrint2:
	jr $ra										#retorna para a main
	
verificaJogadas:									#função que verifica se ainda há jogadas válidas disponiveis
	addi $t2, $zero, 0 								#zera $t2
	addi $t4, $zero, 0								#zera $t4
	addi $v1, $zero, 0								#zera $v1
	verificaLoop:								
	beq $a1, $t2, EndVerifica							#enquanto $t2 for menor que a dimensão, execute	
		addi $t3, $zero, 0							#zera $t3
		verificaLoopCol:
		beq $a1, $t3, endCol3							#enquanto $t3 for menor que a dimensão, execute
			lw $t5, gabarito($t4)						#carrega em $t5 o valor do vetor "gabarito" de indice $t4
			bne $t5, 0, branchVerifica					#se a posição for 0 ela é uma posição válida, então incremente 1 ao contador
				addi $v1, $v1, 1
			branchVerifica:
			addi $t3, $t3, 1						#incrementa $t3
			addi $t4, $t4, 4						#incrementa $t4
			j verificaLoopCol
		endCol3:
		addi $t2, $t2, 1							#ncrementa $t2
		mul $t4, $t2, 36							#coloca em $t4 o indice da próxima linha da matriz
		j verificaLoop

	EndVerifica:
	jr $ra										#retorna para a main
