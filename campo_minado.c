#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define XMAX 9
#define YMAX 9

void insere_bombas(int *campo[][9], int dim){	//insere 9s(bombas) aleatoriamente na matriz

	for(int i=0;i<dim;i++){
		for(int j=0;j<dim;j++){
			if(((rand()%10) % 4) == 0){         //pode alterar a quantidade de bombas aqui, coloque um modulo maior para menos bombas e menor para mais bombas, aqui uso 4
				campo[i][j] = 9;
			}
		}
	}
	return;
}

int valida_campo(int x, int y){                         //essa função calcula se uma determinada posição esta dentro da matriz ou fora
	if(x >= 0 && x < XMAX && y >= 0 && y < YMAX){
		return 1;
	}else{
		return 0;
	}
}

void calcula_bombas(int *campo[][9], int dim){   //essa função calcula todas as bombas adjacentes das casas da matriz
	for(int i=0;i<dim;i++){
		for(int j=0;j<dim;j++){
			int contador = 0;
			if(campo[i][j] != 9){
				i--;
				if(valida_campo(i,j) == 1)			//os campos adjacentes são acessasdos manualmente um por um
					if(campo[i][j] == 9)
						contador++;

				j++;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				i++;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				i++;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				j--;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				j--;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				i--;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;

				i--;
				if(valida_campo(i,j) == 1)
					if(campo[i][j] == 9)
						contador++;
				i++;
				j++;	
				campo[i][j] = contador;				//aqui i e j voltam para a posição de origem, e o campo de origem recebe a quantidade de bombas adjacentes
			}
		}
	}
	return;
}


int main(){

	srand(time(NULL));

	int x,y,dimx,dimy;

	int matriz[XMAX][YMAX];      //matriz de tamanho fixo (máximo)
	int gabarito[XMAX][YMAX];    //matriz que terá as posições ja escolhidas

	printf("Digite as dimesões da matriz: (5x5 - 7x7 - 9x9)\nDimensão X:\n");    //usuário escolhe o tamanho da matriz
	scanf("%d",&dimx);
	printf("Dimensão Y:\n");
	scanf("%d",&dimy);

	for(int i=0;i<XMAX;i++){      //preenche matriz com 0s
		for(int j=0;j<YMAX;j++){
			matriz[i][j] = 0;
		}
	}

	for(int i=0;i<XMAX;i++){		//preenche gabarito com 0s
		for(int j=0;j<YMAX;j++){
			gabarito[i][j] = 0;
		}
	}

    insere_bombas(matriz, XMAX);		//chama função para inserir bombas

    calcula_bombas(matriz, XMAX);		//chama função para calcular bombas adjacentes


	//imprime matriz
	for(int i=0;i<XMAX;i++){
		for(int j=0;j<YMAX;j++){
			printf("%d ",matriz[i][j]);
		}
		printf("\n");
	}

	printf("ESTA É A MATRIZ POPULADA COM BOMBAS E COM ADJACENCIA CALCULADA!");
    getchar();
    getchar();


	while(1){
		system("cls");   		// para windows
		//system("clear"); 		//linux 
		for(int i=0;i<XMAX;i++){
			for(int j=0;j<YMAX;j++){
				if(gabarito[i][j] == 10){
					printf("%d ",matriz[i][j]);        //aqui o programa mostrará para o usuario somente os campos ja escolhidos
				}else{
					printf("X ");
				}
			}
		printf("\n");
		}

		printf("Escolha a posição que deseja jogar:\nPosição X:\n");
		scanf("%d", &x);
		printf("Posição Y:\n");
		scanf("%d",&y);


		if(matriz[x][y] == 9){
			printf("###############VOCÊ PERDEU!!!!##############");    //se o usuário selecionar uma bomba, GAME OVER!
			return 0;
		}else{
			gabarito[x][y] = 10;
		}
	}

	return 0;
}
