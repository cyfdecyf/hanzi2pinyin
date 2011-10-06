#ifndef _HANZI_H
#define _HANZI_H

#include "unicode.h"

/* XXX In the implementation of hanzi_sqlite.c, the memory returned is managed
 * by sqlite3. Calling this function again will destroy previously returned
 * data.
 * The implementation in hanzi_bindata.c does not have this problem. */
const char *hz_pinyin_codepoint(UTF32 cp);

/* Convert all Hanzi in a string s to their pinyin representation.
 * Space will be added before and after pinyin.
 * Characters which has none pinyin found will be simplied copied.
 * Memory returned should be freed by caller. */
char *hz_pinyin_str(const char *s, Encoding enc);

#endif /* _HANZI_H */
