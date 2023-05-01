#include <stdio.h>

char w[] = "Hello, alex!\r\n";

void main() {
    printf("Hello, world!\r\n%s\nPTR is: %x\r\n", w, w);
    
    char c = getchar();
    printf("Char code: %x\r\n", c);
}