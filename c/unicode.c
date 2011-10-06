#include "unicode.h"
#include <stdbool.h>

static inline bool hz_is_high_surrogate(UTF16 uc)
{
    return (0xD800 <= uc && uc <= 0xDBFF);
}

static inline bool hz_is_low_surrogate(UTF16 uc)
{
    return (0xDC00 <= uc && uc <= 0xDFFF);
}

static UTF32 hz_utf16_surrogate_to_utf32(UTF16 hi, UTF16 lo) {
    // The following code is copied from
    // http://www.unicode.org/faq//utf_bom.html#utf16-3
    UTF32 X = (hi & ((1 << 6) -1)) << 10 | lo & ((1 << 10) -1);
    UTF32 W = (hi >> 6) & ((1 << 5) - 1);
    UTF32 U = W + 1;
    UTF32 C = U << 16 | X;
    return C;
}

// Is there an easy and faster way to find the 1st 0?
// Return -1 means all 1, left most id is 7
static inline int left_first_0(UTF8 u) {
    int i;
    for (i = 7; i > 0; i--) {
        if (((u >> i) & 1) == 0)
            break;
    }
    return i;
}

static inline int utf8_char_nbyte(const UTF8 *s) {
    int first0id = left_first_0(s[0]);
    int nbyte = 7 - first0id;

    // Illegal character start
    if ((first0id == -1) || (nbyte == 1))
        nbyte = -1;

    return nbyte;
}

UTF32 hz_utf8_to_utf32(const UTF8 *s, int *nbyte) {
    UTF32 cp = 0;
    int n = utf8_char_nbyte(s);

    if (n == -1) {
        cp = -1;
    } else if (n == 1) {
        cp = s[0];
    } else {
        int i;
        // Get the 1st byte's bits
        cp = (s[0] & ((1 << (7 - n)) - 1)) << (n - 1) * 6;
        for (i = 1; i < n; i++)
            cp |= (s[i] & 0x3F) << ((n - 1 - i) * 6);
    }

    if (nbyte)
        *nbyte = n;
    return cp;
}

UTF32 hz_utf16_to_utf32(const UTF16 *s, int *nbyte) {
    // TODO not finished
    return -1;
}

