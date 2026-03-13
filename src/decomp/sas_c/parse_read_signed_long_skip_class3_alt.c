typedef signed long LONG;

extern char *STR_SkipClass3Chars(const char *s);
extern LONG PARSE_ReadSignedLong_NoBranch(const char *in, LONG *outValue);

LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *cursor)
{
    LONG parsedValue;

    if (!cursor) {
        return 0;
    }

    cursor = STR_SkipClass3Chars(cursor);
    PARSE_ReadSignedLong_NoBranch(cursor, &parsedValue);
    return parsedValue;
}
