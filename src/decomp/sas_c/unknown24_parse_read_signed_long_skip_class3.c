typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *STR_SkipClass3Chars(UBYTE *s);
extern LONG PARSE_ReadSignedLong(const UBYTE *in, LONG *outValue);
extern LONG PARSE_ReadSignedLong_NoBranch(const UBYTE *in, LONG *outValue);

LONG PARSE_ReadSignedLongSkipClass3(UBYTE *cursor)
{
    LONG parsedValue;

    if (!cursor) {
        return 0;
    }

    cursor = STR_SkipClass3Chars(cursor);
    PARSE_ReadSignedLong(cursor, &parsedValue);
    return parsedValue;
}

LONG PARSE_ReadSignedLongSkipClass3_Alt(UBYTE *cursor)
{
    LONG parsedValue;

    if (!cursor) {
        return 0;
    }

    cursor = STR_SkipClass3Chars(cursor);
    PARSE_ReadSignedLong_NoBranch(cursor, &parsedValue);
    return parsedValue;
}
