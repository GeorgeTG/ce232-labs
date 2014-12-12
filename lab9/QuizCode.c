#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* Used for quicksort */
int cmpfunc (const void *a, const void *b) {
    return (* (int *) a - (* (int *) b));
}
int main(void) {

    const unsigned N = 32768;
    const unsigned M = 8;
    int data[N];
    long long sum[M];
    clock_t start, end;

    for (int i = 0; i < N; i++)
        data[i] = rand() % 256;
    for (int k = 0; k < M; k++)
        sum[k] = 0L;

#ifdef SORTING
    qsort(data, N, sizeof(int), cmpfunc);
#endif

    start = clock();
    for (unsigned i = 0; i < 100000; i++) {
        for (unsigned j = 0; j < N; j++) {
            if (data[j] < 128) {
                for (unsigned k = 0; k < M; k++)
                    sum[k] += data[j];
            }
        }
    }


    end = clock();
    for (int k = 0; k < M; k++)
        printf("Sum[%d] = %lld\n",k, sum[k]);

    printf("Elapsed time in secs : %f\n", ((double) (end-start)/CLOCKS_PER_SEC));

    return 0;
}
