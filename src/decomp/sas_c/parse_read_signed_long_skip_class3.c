#include <exec/types.h>
extern char *STR_SkipClass3Chars(const char *s);
extern LONG PARSE_ReadSignedLong(const char *in, LONG *outValue);

LONG PARSE_ReadSignedLongSkipClass3(const char *cursor)
{
    LONG parsedValue;

    if (!cursor) {
        return 0;
    }

    cursor = STR_SkipClass3Chars(cursor);
    PARSE_ReadSignedLong(cursor, &parsedValue);
    return parsedValue;
}
