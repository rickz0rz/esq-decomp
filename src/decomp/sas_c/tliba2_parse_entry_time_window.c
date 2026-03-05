typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *STR_FindCharPtr(char *s, LONG ch);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(char *s);

LONG TLIBA2_ParseEntryTimeWindow(void *entryContext, LONG entryIndex, LONG *outPair)
{
    char *entryText;
    char *openParen;
    char *colon;
    char *closeParen;
    char *greaterThan;
    LONG ok;

    ok = 0;
    if (entryContext == (void *)0) {
        entryText = (char *)0;
    } else {
        entryText = *((char **)((UBYTE *)entryContext + 56 + (entryIndex * 4)));
    }
    if (entryText == (char *)0) {
        return 0;
    }

    openParen = STR_FindCharPtr(entryText, 40);
    if (openParen == (char *)0) {
        return 0;
    }
    greaterThan = STR_FindCharPtr(openParen, 58);
    if (greaterThan == (char *)0) {
        return 0;
    }
    closeParen = STR_FindCharPtr(greaterThan, 41);
    if (closeParen == (char *)0) {
        return 0;
    }
    colon = STR_FindCharPtr(entryText, 34);
    if (colon != (char *)0 && closeParen <= colon) {
        return 0;
    }

    *greaterThan = 0;
    if (openParen[1] == ' ') {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + 2);
    } else {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + 1);
    }
    *greaterThan = ':';

    *closeParen = 0;
    outPair[1] = PARSE_ReadSignedLongSkipClass3_Alt(greaterThan + 1);
    *closeParen = ')';
    ok = 1;

    return ok;
}
