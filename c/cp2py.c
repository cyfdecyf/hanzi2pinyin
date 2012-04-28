#include "hanzi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s <cp1> [cp2, cp3]\n", argv[0]);
        exit(1);
    }

    int i = 1;
    uint32_t cp;
    const char *pinyin;

    for (; i < argc; i++) {
        cp = (uint32_t)strtol(argv[i], NULL, 0);
        pinyin = hz2pinyin_codepoint(cp);

        if (i > 1)
            printf(" ");
        if (pinyin)
            printf("%s", pinyin);
        else if ((char)cp == cp) /* If it's ascii, print the letter. */
            printf("%c", (char)cp);
    }

    return 0;
}

