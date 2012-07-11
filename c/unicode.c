#include "unicode.h"
#include "util.h"
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <iconv.h>
#include <stdio.h>

static iconv_t utf8_cd;

static int init_cd() {
    CALL_ONCE(0);

    /* XXX Note the endianness. On intel based Mac, use little endian. */
    utf8_cd = iconv_open("UTF-32LE", "UTF-8");
    if (utf8_cd == (iconv_t)-1) {
        perror("iconv_open");
        return 1;
    }
    return 0;
}

static UTF32 *convert(iconv_t cd, const char *s, size_t inbytes, size_t *nchar) {
    if (cd == (iconv_t) -1)
        return NULL;

    /* The upper bound of output memory required */
    size_t outbytes = inbytes * sizeof(UTF32);
    char *outbuf = calloc(1, outbytes);
    char *outp = outbuf;

    /* Note iconv's return value is "number of characters converted in a non-reversible way".
       If we convert UTF-8 encoded string "abc汉字" to ASCII, as the last 2 characters can't
       be represented in ASCII, we may convert them to '?', this means we can't convert the
       resulting ASCII string back to the original UTF-8 string. So this conversion is
       non-reversible. */
    size_t n = iconv(cd, (char **)&s, &inbytes, &outp, &outbytes);
    if (n == (size_t) -1) {
        perror("convert");
        free(outbuf);
        return NULL;
    }
    if (nchar)
        *nchar = (outp - outbuf) / sizeof(UTF32);
    return (UTF32 *)outbuf;
}

UTF32 *hz_utf8_to_utf32(const char *s, size_t *nchar) {
    init_cd();
    return convert(utf8_cd, s, strlen(s), nchar);
}
