typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *STR_SkipClass3Chars(UBYTE *s);
extern LONG PARSE_ReadSignedLong(const UBYTE *in, LONG *outValue);
extern LONG PARSE_ReadSignedLong_NoBranch(const UBYTE *in, LONG *outValue);

LONG PARSE_ReadSignedLongSkipClass3(UBYTE *input)
{
    LONG parsedValue;

    if (!input) {
        return 0;
    }

    input = STR_SkipClass3Chars(input);
    PARSE_ReadSignedLong(input, &parsedValue);
    return parsedValue;
}

LONG PARSE_ReadSignedLongSkipClass3_Alt(UBYTE *input)
{
    LONG parsedValue;

    if (!input) {
        return 0;
    }

    input = STR_SkipClass3Chars(input);
    PARSE_ReadSignedLong_NoBranch(input, &parsedValue);
    return parsedValue;
}
