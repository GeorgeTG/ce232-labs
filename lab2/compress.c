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

void decompress(char* source, char* dest) {
    int i,j;
    int char_count;
    char curr_char;

    for(i=0; source[i] != '\0'; i++) {
        if (source[i] != 0x1B)
            *(dest++) = source[i];
        else {
            i++; //skip esc char
            char_count = source[i];
            i++;
            curr_char = source[i];

            for (j=0; j < char_count; j++){
                *(dest++) = curr_char;
            }
        }
    }
    *dest = '\0';
}

int main(int argc, char *argv[]) {
    char dest[20];
    char decompr[20];
    compress("abbccccfgggh",dest);
    printf("Dest : %s\n", dest);
    decompress(dest, decompr);
    printf("Decr : %s\n", decompr);
    return 0;

}
