#ifndef _UNICODE_H
#define _UNICODE_H

#include <stdint.h>
#include <stddef.h>

/* I'm not going to support UTF16. It's awful to handle UTF16 strings using
   native C string function. */

typedef uint8_t UTF8;
typedef uint32_t UTF32;

/* Convert UTF-8 string UTF-32. nchar will be set to the number of characters.
 * Caller should free memory. */
UTF32 *hz_utf8_to_utf32(const char *s, size_t *nchar);

#endif /* _UNICODE_H */
