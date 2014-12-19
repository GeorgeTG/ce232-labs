#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N (1<<13)
#define BLOCKSIZE 16

typedef long long ll;

int** alloc_matrix(ll m, ll n){
    ll i;
    int **matrix = (int**)malloc(n * sizeof(int*));
    if (matrix == NULL) {
        return NULL;
    }

    for (i=0; i < n; i++) {
        if ((matrix[i] = (int*)malloc(m * sizeof(int))) == NULL){
            return NULL;
        }
    }

    return matrix;
}

void init_matrix(int** matrix, ll m, ll n) {
    ll i,j;
    for (i = 0; i < n; i++){
        for (j=0; j < m; j++) {
            matrix[i][j] = rand() % 256;
        }
    }
}

void free_matrix(int** matrix, ll m, ll n) {
    ll i;
    for (i = 0; i < n; i++){
        free(matrix[i]);
    }
    free(matrix);
}

void get_transposed(int** transposed, int** matrix, ll m, ll n){
    ll i,j,k,l;
    for (i = 0; i < n; i += BLOCKSIZE) {
        for (j = 0; j < m; j += BLOCKSIZE) {
            //transpose the block beginning at [i,j]
            for (k = i; (k < i + BLOCKSIZE) && (k < n); ++k) {
                for (l = j; (l < j + BLOCKSIZE) && (l < m); ++l) {
                    transposed[k][l] = matrix[l][k];
                }
            }
            //----------------------------------------
        }
    }
}

int main(void){
    srand(time(NULL));
    int **matrix = alloc_matrix(N, N);
    int **transposed = alloc_matrix(N, N);
    clock_t start, end;

#ifdef INIT_M
    start = clock();
    init_matrix(matrix, N, N);
    end = clock();

    printf("Matrix initiallized in : %lf\n", ((double) (end-start)/CLOCKS_PER_SEC));
#endif

    start = clock();
    get_transposed(transposed, matrix, N, N);
    end = clock();

    printf("transposed calculated in : %lf\n", ((double) (end-start)/CLOCKS_PER_SEC));

    free_matrix(matrix, N, N);
    free_matrix(transposed, N, N);
    return 0;
}

