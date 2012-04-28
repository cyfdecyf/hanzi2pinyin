#include "hanzi.h"
#include "util.h"
#include "sqlite3.h"
#include <stdbool.h>
#include <stdio.h>

static sqlite3 *db;
static sqlite3_stmt *query;
/* The sqlite3 database is created by data/Unihan/create-sqlitedb.rb */
static const char *db_path =
    "/Users/alex/programming/hanzi2pinyin/data/codepoint2pinyin.db";
static const char *query_string =
    "SELECT pinyin FROM codepoint2pinyin WHERE codepoint = ?";

static int pinyin_db_init(void) {
    CALL_ONCE(0);

    int err = sqlite3_open_v2(db_path, &db, SQLITE_OPEN_READONLY, NULL);
    if (err != SQLITE_OK) {
        fprintf(stderr, "error opening database: %d\n", err);
        goto error;
    }
    
    err = sqlite3_prepare_v2(db, query_string, -1, &query, NULL);
    if (err != SQLITE_OK) {
        fprintf(stderr, "error preparing statement: %d\n", err);
        goto error;
    }

    return 0;

error:
    sqlite3_close(db);
    db = NULL;
    return -1;
}

static int check_sqlite_error(int err, const char *msg) {
    if (err == SQLITE_ERROR || err == SQLITE_MISUSE) {
        fprintf(stderr, "%s: %s\n", msg, sqlite3_errmsg(db));
        return 1;
    }
}

const char *hz2pinyin_codepoint(uint32_t cp) {
    int err;

    pinyin_db_init();
    if (!db)
        return NULL;

    /* Reset for use.
     * XXX This will release memory returned by previous call to column access
     * function. */
    sqlite3_reset(query);

    err = sqlite3_bind_int(query, 1, cp);
    if (check_sqlite_error(err, "bind_int"))
        return NULL;

    /* Does not handle other cases like SQLITE_BUSY now. May need to retry
     * on those errors. */
    err = sqlite3_step(query);
    if (check_sqlite_error(err, "step"))
        return NULL;

    if (err != SQLITE_ROW)
        return NULL;

    const char *py = sqlite3_column_text(query, 0);
    
    return py;
}

