#ifndef _HANZI_H
#define _HANZI_H

#include <stdint.h>

/* XXX In the implementation of hanzi_sqlite.c, the memory returned is managed
 * by sqlite3. Calling this function again will destroy previously returned
 * data.
 * The implementation in hanzi_bindata.c does not have this problem. */
const char *hz_pinyin_codepoint(uint32_t cp);

/* XXX Not good to put here. */
#define CALL_ONCE(retcode) \
    static bool __called = false; \
    if (__called) \
        return 0; \
    else \
        __called = true; \

#endif /* _HANZI_H */
