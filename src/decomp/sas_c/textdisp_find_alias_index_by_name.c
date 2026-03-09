typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_CandidateEntry {
    UBYTE shortName[10];
    UBYTE longName[2];
    UBYTE tagText[15];
} TEXTDISP_CandidateEntry;

extern WORD TEXTDISP_AliasCount;
extern void *TEXTDISP_AliasPtrTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

LONG TEXTDISP_FindAliasIndexByName(UBYTE *entryPtr)
{
    const LONG INDEX_NOT_FOUND = -1;
    const UBYTE CH_NUL = 0;
    UBYTE nameBuf[22];
    UBYTE *src;
    UBYTE *dst;
    LONG idx;

    src = ((TEXTDISP_CandidateEntry *)entryPtr)->tagText;
    dst = nameBuf;
    do {
        *dst = *src;
        dst += 1;
        src += 1;
    } while (dst[-1] != CH_NUL);

    idx = 0;
    while ((WORD)idx < TEXTDISP_AliasCount) {
        UBYTE **aliasNode;
        UBYTE *alias;
        UBYTE *scan;

        aliasNode = (UBYTE **)TEXTDISP_AliasPtrTable[idx];
        alias = aliasNode[0];
        scan = alias;
        while (*scan != CH_NUL) {
            ++scan;
        }

        if (STRING_CompareNoCaseN((const char *)nameBuf, (const char *)alias, (LONG)(scan - alias)) == 0) {
            return idx;
        }
        idx += 1;
    }

    return INDEX_NOT_FOUND;
}
