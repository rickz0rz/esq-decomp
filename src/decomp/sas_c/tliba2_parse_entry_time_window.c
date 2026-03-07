typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *STR_FindCharPtr(char *s, LONG ch);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(char *s);

LONG TLIBA2_ParseEntryTimeWindow(void *entryContext, LONG entryIndex, LONG *outPair)
{
    const LONG PTR_NULL = 0;
    const LONG TITLE_TABLE_OFFSET = 56;
    const LONG TITLE_PTR_SHIFT = 4;
    const LONG TITLE_PTR_STRIDE = 4;
    const LONG ASCII_LPAREN = 40;
    const LONG ASCII_COLON = 58;
    const LONG ASCII_RPAREN = 41;
    const LONG ASCII_QUOTE = 34;
    const char CH_NUL = 0;
    const char CH_SPACE = ' ';
    const LONG ONE = 1;
    const LONG TWO = 2;
    const LONG RESULT_OK = 1;
    const LONG RESULT_FAIL = 0;
    char *entryText;
    char *openParen;
    char *colon;
    char *closeParen;
    char *greaterThan;
    LONG ok;

    ok = RESULT_FAIL;
    if (entryContext == (void *)PTR_NULL) {
        entryText = (char *)PTR_NULL;
    } else {
        entryText = *((char **)((UBYTE *)entryContext + TITLE_TABLE_OFFSET + (entryIndex * TITLE_PTR_STRIDE)));
    }
    if (entryText == (char *)PTR_NULL) {
        return RESULT_FAIL;
    }

    openParen = STR_FindCharPtr(entryText, ASCII_LPAREN);
    if (openParen == (char *)PTR_NULL) {
        return RESULT_FAIL;
    }
    greaterThan = STR_FindCharPtr(openParen, ASCII_COLON);
    if (greaterThan == (char *)PTR_NULL) {
        return RESULT_FAIL;
    }
    closeParen = STR_FindCharPtr(greaterThan, ASCII_RPAREN);
    if (closeParen == (char *)PTR_NULL) {
        return RESULT_FAIL;
    }
    colon = STR_FindCharPtr(entryText, ASCII_QUOTE);
    if (colon != (char *)PTR_NULL && closeParen <= colon) {
        return RESULT_FAIL;
    }

    *greaterThan = CH_NUL;
    if (openParen[ONE] == CH_SPACE) {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + TWO);
    } else {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + ONE);
    }
    *greaterThan = ':';

    *closeParen = CH_NUL;
    outPair[1] = PARSE_ReadSignedLongSkipClass3_Alt(greaterThan + ONE);
    *closeParen = ')';
    ok = RESULT_OK;

    return ok;
}
