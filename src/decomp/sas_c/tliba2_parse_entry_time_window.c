#include <exec/types.h>
typedef struct TLIBA2_EntryAux {
    UBYTE pad0[56];
    char *titleTable[49];
} TLIBA2_EntryAux;

extern char *STR_FindCharPtr(const char *s, LONG ch);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);

LONG TLIBA2_ParseEntryTimeWindow(TLIBA2_EntryAux *entryContext, LONG entryIndex, LONG *outPair)
{
    register LONG ok;
    char *entryText;
    char *openParen;
    char *quote;
    char *closeParen;
    char *colon;

    ok = 0;
    if (entryContext == 0) {
        entryText = 0;
    } else {
        entryText = entryContext->titleTable[entryIndex];
    }

    if (entryText == 0) {
        return ok;
    }

    openParen = STR_FindCharPtr(entryText, 40);
    if (openParen == 0) {
        return ok;
    }

    colon = STR_FindCharPtr(openParen, 58);
    if (colon == 0) {
        return ok;
    }

    closeParen = STR_FindCharPtr(colon, 41);
    if (closeParen == 0) {
        return ok;
    }

    quote = STR_FindCharPtr(entryText, 34);
    if (quote != 0 && closeParen <= quote) {
        return ok;
    }

    *colon = 0;
    if (openParen[1] == ' ') {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + 2);
    } else {
        outPair[0] = PARSE_ReadSignedLongSkipClass3_Alt(openParen + 1);
    }
    *colon = ':';

    *closeParen = 0;
    outPair[1] = PARSE_ReadSignedLongSkipClass3_Alt(colon + 1);
    *closeParen = ')';
    ok = 1;

    return ok;
}
