#include <exec/types.h>
typedef struct TEXTDISP_CandidateEntry {
    char shortName[10];
    char longName[2];
    char tagText[15];
} TEXTDISP_CandidateEntry;

typedef struct TEXTDISP_AliasEntry {
    const char *aliasText;
} TEXTDISP_AliasEntry;

extern WORD TEXTDISP_AliasCount;
extern TEXTDISP_AliasEntry *TEXTDISP_AliasPtrTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

LONG TEXTDISP_FindAliasIndexByName(const char *entryPtr)
{
    const LONG INDEX_NOT_FOUND = -1;
    const UBYTE CH_NUL = 0;
    char nameBuf[22];
    const char *src;
    char *dst;
    LONG idx;

    src = ((const TEXTDISP_CandidateEntry *)entryPtr)->tagText;
    dst = nameBuf;
    do {
        *dst = *src;
        dst += 1;
        src += 1;
    } while (dst[-1] != CH_NUL);

    idx = 0;
    while ((WORD)idx < TEXTDISP_AliasCount) {
        const TEXTDISP_AliasEntry *aliasEntry;
        const char *alias;
        const char *scan;

        aliasEntry = TEXTDISP_AliasPtrTable[idx];
        alias = aliasEntry->aliasText;
        scan = alias;
        while (*scan != CH_NUL) {
            ++scan;
        }

        if (STRING_CompareNoCaseN(nameBuf, alias, (LONG)(scan - alias)) == 0) {
            return idx;
        }
        idx += 1;
    }

    return INDEX_NOT_FOUND;
}
