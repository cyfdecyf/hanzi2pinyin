#include "hanzi.h"
// #define DEBUG
#include "util.h"
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

static const int PINYIN_BUF_SIZE = 128;

char *hz2pinyin(const char *hanzi, const char *sep, Encoding enc) {
	/* This function is too large. */
	size_t n;
	UTF32 *cp;

	int bufsize = PINYIN_BUF_SIZE;
	char *out = calloc(1, bufsize);
	char *out_ptr = out;
	int out_nleft = bufsize; /* How many bytes left in the out buffer. */

	/* First convert the string to unicode codepoint */
	switch (enc) {
	case ENCODING_UTF8:
		cp = hz_utf8_to_utf32(hanzi, &n);
		break;
	default:
        DPRINTF("Not supported encoding\n");
        return NULL;
	}

    if (!cp) {
        DPRINTF("conversion to codepoint failed\n");
        return NULL;
    }

    int ret = 0;
    /* Separator handling is ugly. Can I do it in a clean way? */
	bool prev_is_chinese = false;
	bool cur_is_chinese;
	bool prev_is_space = true;
	bool cur_is_space;
	/* Convert codepoint to pinyin one by one */
	for (int i = 0; i < n; i++) {
redo:
		/* For ASCII, just include it in the the final string. */
		if (cp[i] < 256) {
			cur_is_chinese = false;
			cur_is_space = isspace(cp[i]);
			/* Add sperator between Chinese and English */
			if (prev_is_chinese && !cur_is_space)
				ret = snprintf(out_ptr, out_nleft, "%s%c", sep, cp[i]);
			else
				ret = snprintf(out_ptr, out_nleft, "%c", cp[i]);
		} else {
			cur_is_chinese = true;
			cur_is_space = false;
			const char *py = hz2pinyin_codepoint(cp[i]);
			if (!py) {
				DPRINTF("codepoint %#x doesn't have pinyin", cp[i]);
				goto error;
			}

			DPRINTF("%x %s ", cp[i], py);

			/* When previous character is chinese, add seperator. */
			if (prev_is_chinese || !prev_is_space) {
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
			char *newbuf = realloc(out, bufsize);

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

		prev_is_chinese = cur_is_chinese;
		prev_is_space = cur_is_space;
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
