#include <stdio.h>

void compress(char* source, char* dest){
    int i,j,k, dest_pos = 0;
    char curr_char;

    for (i=0; source[i] != '\0'; i += j) {
        curr_char = source[i];

        for(j=1; source[j + i] == curr_char; j++){}

        if (j <= 3) {
            for(k=0; k < j; k++){
                dest[dest_pos++] = curr_char;
            }
        } else {
            dest[dest_pos++] = 0x1B;
            dest[dest_pos++] = j;
            dest[dest_pos++] = curr_char;
        }
    }

    dest[++dest_pos] = '\0';
}

int main(int argc, char *argv[]) {
    char dest[20];
    compress("abbccccfgggh",dest);
    printf("Dest : %s\n", dest);

    return 0;

}
