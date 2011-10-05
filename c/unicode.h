#ifndef _UNICODE_H
#define _UNICODE_H

#include <stdint.h>
#include <stdbool.h>

typedef uint8_t UTF8;
typedef uint16_t UTF16;
typedef uint32_t UTF32;

// s is a UTF-8 bytes sequence, nbytes will be set to #bytes of the first
// character. Very little error handling.
UTF32 hz_utf8_to_utf32(const UTF8 *s, int *nbytes);

// Similar to hz_utf8_to_utf32
UTF32 hz_utf16_to_utf32(const UTF16 *s, int *nbytes);

#endif /* _UNICODE_H */
