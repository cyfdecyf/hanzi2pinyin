#include "hanzi.h"
// #define DEBUG
#include "util.h"
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

static const int PINYIN_BUF_SIZE = 128;

static inline bool need_separater(uint32_t prevcp, uint32_t curcp) {
    bool r = false;
    if (hz_is_hanzi(curcp)) {
        r = isspace(prevcp) ? false : true;
    } else if (isspace(curcp)) {
        r = false;
    } else {
        r = hz_is_hanzi(prevcp) ? true : false;
    }
    return r;
}

char *hz2pinyin(const char *hanzi, const char *sep) {
    /* This function is too large. */
    size_t n;
    UTF32 *cp;

    int bufsize = PINYIN_BUF_SIZE;
    char *out = (char *)calloc(1, bufsize);
    char *out_ptr = out;
    int out_nleft = bufsize; /* How many bytes left in the out buffer. */

    /* First convert the string to unicode codepoint */
    cp = hz_utf8_to_utf32(hanzi, &n);
    if (!cp) {
        DPRINTF("conversion to codepoint failed\n");
        return NULL;
    }

    int ret = 0;
    /* The first character needs no separator, so initiate prevcp as a space. */
    uint32_t prevcp = ' ';

    /* Convert codepoint to pinyin one by one */
    for (int i = 0; i < n; i++) {
redo:
        /* For ASCII, just include it in the the final string. */
        if (cp[i] < 256) {
            /* Add sperator between Chinese and English */
            if (need_separater(prevcp, cp[i]))
                ret = snprintf(out_ptr, out_nleft, "%s%c", sep, cp[i]);
            else
                ret = snprintf(out_ptr, out_nleft, "%c", cp[i]);
        } else {
            const char *py = hz2pinyin_codepoint(cp[i]);
            if (!py) {
                DPRINTF("codepoint %#x doesn't have pinyin", cp[i]);
                goto error;
            }

            DPRINTF("%x %s ", cp[i], py);

            /* When previous character is chinese, add seperator. */
            if (need_separater(prevcp, cp[i])) {
                ret = snprintf(out_ptr, out_nleft, "%s%s", sep, py);
            } else {
                ret = snprintf(out_ptr, out_nleft, "%s", py);
            }
        }
        /* Not enough space left in the buffer. Remeber snprinf need 1 byte to
           store \0, so if ret == out_nleft, out buffer has 1 less byte. */
        if (ret >= out_nleft) {
            DPRINTF("not enough space in outbuffer, str: %s", out);
            bufsize += PINYIN_BUF_SIZE;
            char *newbuf = (char *)realloc(out, bufsize);

            if (!newbuf) {
                DPRINTF("Out of memory");
                goto error;
            }

            int bytes_written = out_ptr - out;
            out = newbuf;
            out_ptr = out + bytes_written;
            out_nleft += PINYIN_BUF_SIZE;
            DPRINTF("new bufsize %d, bytes written %d, str: %s", bufsize,
                bytes_written, out);
            goto redo;
        }

        prevcp = cp[i];
        out_ptr += ret;
        DPRINTF("bytes written %ld, str: %s", out_ptr - out, out);
        out_nleft -= ret;
    }
    free(cp);
    return out;

error:
    free(cp);
    free(out);
    return NULL;
}
