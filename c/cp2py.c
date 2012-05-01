#include "hanzi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s <Chiniese string>\n", argv[0]);
        exit(1);
    }

    char *pinyin = hz2pinyin(argv[1], " ", ENCODING_UTF8);
    printf("%s\n", pinyin);
    free(pinyin);

    return 0;
}

