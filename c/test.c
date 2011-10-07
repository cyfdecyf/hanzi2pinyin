#include "hanzi.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

void test_onechar(const char *s, const char *expected_pinyin, Encoding enc) {
    size_t n;
    UTF32 *cp;

    if (enc == ENCODING_UTF8)
        cp = hz_utf8_to_utf32(s, &n);
    else {
        printf("Not supported encoding\n");
        return;
    }

    /*
     *int i;
     *for (i = 0; i < n; i++)
     *    printf("%x ", s[i]);
     *puts("");
     */
    if (!cp) {
        printf("conversion failed\n");
        return;
    }

    const char *pinyin = hz_pinyin_codepoint(cp[0]);
    if (!pinyin) {
        printf("No pinyin found for: %s cp: %x\n", s, cp[0]);
        return;
    }

    printf("%s %x %s\n", s, cp[0], pinyin);
    if (strcmp(pinyin, expected_pinyin) != 0) {
        printf("ERROR, expected_pinyin is: %s\n", expected_pinyin);
    }
    free(cp);
}

void dump_char(const char *s) {
    int i;
    for (i = 0; s[i]; ++i) {
        printf("%hhx ", s[i]);
    }
    puts("");
}

void test_file(const char *path, Encoding enc) {
    FILE *fp = fopen(path, "r");
    if (!fp) {
        fprintf(stderr, "error opening file\n");
        return;
    }

    while (1) {
        char c[255];
        char pinyin[255];

        fgets(c, 10, fp);
        if (feof(fp))
            break;
        fgets(pinyin, 10, fp);

        dump_char(c);

        /* Remove trailing "\n"
         * XXX strlen does not work with UTF-16 encoded byte sequence */
        c[strlen(c) - 1] = '\0';
        pinyin[strlen(pinyin) - 1] = '\0';

        test_onechar(c, pinyin, enc);
    }
}

int main(int argc, char* argv[])
{
    test_file("./utf8-test.txt", ENCODING_UTF8);

    /* 0x4E06 has no pinyin */
    const char *pinyin = hz_pinyin_codepoint(0x4E06);
    assert(!pinyin);
    return 0;
}

