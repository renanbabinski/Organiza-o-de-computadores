#include <stdio.h>
#include <stdlib.h>

void bubble_sort (int vetor[], int n) {
    int k, j, aux;

    for (k = 1; k < n; k++) {
        for (j = 0; j < n - 1; j++) {
         	if (vetor[j] > vetor[j + 1]) {
                aux          = vetor[j];
                vetor[j]     = vetor[j + 1];
                vetor[j + 1] = aux;
            }
        }
    }
}

int main(){

int tamanho, qtd, aux;

	printf("Digite o tamanho do vetor:\n");
	scanf("%d",&tamanho);

	int vetor[tamanho];

	printf("Digite valores até preencher o vetor!\n");

	for(int i=0;i<tamanho;i++){
		scanf("%d",&vetor[i]);
	}

	bubble_sort(vetor, tamanho);



	printf("#######################################\n");



	for(int i=0;i<tamanho;i++){
		printf("%d\n",vetor[i]);
	}










return 0;
}
