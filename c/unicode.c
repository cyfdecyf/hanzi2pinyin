#include "unicode.h"
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <iconv.h>
#include <stdio.h>

static iconv_t utf8_cd;
/*static iconv_t utf16_cd;*/

static inline int open_cd(iconv_t *cd, const char *from) {
    /* XXX Note the endianness. On intel based Mac, use little endian. */
    *cd = iconv_open("UTF-32LE", from);
    if (*cd == (iconv_t)-1) {
        perror("iconv_open");
        return 1;
    }
    return 0;
}

static int init_cd() {
    CALL_ONCE(0);

    int err = 0;

    err += open_cd(&utf8_cd, "UTF-8");
    /*err += open_cd(&utf16_cd, "UTF-16LE");*/

    return (err == 0) ? 0 : -1;
}

static UTF32 *convert(iconv_t cd, const char *s, size_t inbytes, size_t *nchar) {
    if (cd == (iconv_t) -1)
        return NULL;

    /* The upper bound of output memory required */
    size_t outbytes = inbytes * sizeof(UTF32);
    char *outbuf = calloc(1, outbytes);
    char *outp = outbuf;

    /* In GNU libiconv, the second parameter is a const char ** */
    size_t n = iconv(cd, (char **)&s, &inbytes, &outp, &outbytes);
    if (n == (size_t) -1) {
        perror("convert");
        free(outbuf);
        return NULL;
    }
    if (nchar)
        *nchar = n;
    return (UTF32 *)outbuf;
}

UTF32 *hz_utf8_to_utf32(const char *s, size_t *nchar) {
    init_cd();
    return convert(utf8_cd, s, strlen(s), nchar);
}

/* How to detect the end of a UTF16 byte sequence?
 * This is C string, the last '\0' is just a single byte.
 * Working with UTF-16 in C is awful. */
/*
UTF32 *hz_utf16_to_utf32(const char *s, size_t *nchar) {
    init_cd();
    size_t n = 0;
    UTF16 *ss = (UTF16 *)s;
    while (*ss++ != 0) n++;
    return convert(utf16_cd, s, n, nchar);
}
*/
