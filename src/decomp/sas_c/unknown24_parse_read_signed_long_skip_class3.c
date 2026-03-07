typedef signed long LONG;

extern char *STR_SkipClass3Chars(char *s);
extern void PARSE_ReadSignedLong(char *s, LONG *outValue);
extern void PARSE_ReadSignedLong_NoBranch(char *s, LONG *outValue);

LONG PARSE_ReadSignedLongSkipClass3(char *input)
{
    LONG parsedValue;

    if (!input) {
        return 0;
    }

    input = STR_SkipClass3Chars(input);
    PARSE_ReadSignedLong(input, &parsedValue);
    return parsedValue;
}

LONG PARSE_ReadSignedLongSkipClass3_Alt(char *input)
{
    LONG parsedValue;

    if (!input) {
        return 0;
    }

    input = STR_SkipClass3Chars(input);
    PARSE_ReadSignedLong_NoBranch(input, &parsedValue);
    return parsedValue;
}
