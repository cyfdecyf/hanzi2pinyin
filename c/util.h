#ifndef _UTIL_H
#define _UTIL_H

#define CALL_ONCE(retcode) \
    static bool __called = false; \
    if (__called) \
        return 0; \
    else \
        __called = true; \

#ifdef DEBUG
# define DPRINTF(fmt, ...) \
    fprintf(stderr, "%s:%d: %s: " fmt "\n", __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)
#else
# define DPRINTF(fmt, ...)
#endif

#endif