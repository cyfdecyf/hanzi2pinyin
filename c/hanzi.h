#ifndef _HANZI_H
#define _HANZI_H

#include "unicode.h"
#include <stdint.h>
/* XXX In the implementation of hanzi_sqlite.c, the memory returned is managed
 * by sqlite3. Calling this function again will destroy previously returned
 * data.
 * The implementation in hanzi_bindata.c does not have this problem. */
const char *hz2pinyin_codepoint(uint32_t cp);

/* Return pinyin of the give hanzi string. Pinyin for each character is
   separated by the given sep. Memory is allocated as needed.

   Note you can only mix 8bit ASCII character and Chinese character in the
   hanzi string. One separator will be inserted between ASCII and pinyin unless
   the ASCII character is space.

   On error, return NULL.

   Caller should free the memory. */
char *hz2pinyin(const char *hanzi, const char *sep, Encoding enc);

#endif /* _HANZI_H */
