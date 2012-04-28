#ifndef _UNICODE_H
#define _UNICODE_H

#include <stdint.h>
#include <stddef.h>

typedef uint8_t UTF8;
typedef uint16_t UTF16;
typedef uint32_t UTF32;

typedef enum {
    ENCODING_UTF8,
    ENCODING_UTF16
} Encoding;

/* Convert UTF-8 string UTF-32. nchar will be set to the number of characters.
 * Caller should free memory. */
UTF32 *hz_utf8_to_utf32(const char *s, size_t *nchar);

#endif /* _UNICODE_H */
