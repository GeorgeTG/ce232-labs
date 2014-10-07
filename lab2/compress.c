#include <stdio.h>

void compress(char* source, char* dest){
    int i, j = 0, k;
    char curr_char;

    for (i=0; source[i] != '\0'; i += j) {
        curr_char = source[i];

        for(j=1; source[j + i] == curr_char; j++){}

        if (j <= 3) {
            for(k=0; k < j; k++){
                *(dest++) = curr_char;
            }
        } else {
            *(dest++) = 0x1B;
            *(dest++) = j;
            *(dest++) = curr_char;
        }
    }
    *dest = '\0';
}

int main(int argc, char *argv[]) {
    char dest[20];
    compress("abbccccfgggh",dest);
    printf("Dest : %s\n", dest);

    return 0;

}
