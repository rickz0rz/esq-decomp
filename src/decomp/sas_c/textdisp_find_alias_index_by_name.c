typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_AliasCount;
extern void *TEXTDISP_AliasPtrTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

LONG TEXTDISP_FindAliasIndexByName(UBYTE *entryPtr)
{
    const LONG ENTRY_NAME_OFFSET = 12;
    const LONG INDEX_NOT_FOUND = -1;
    const UBYTE CH_NUL = 0;
    UBYTE nameBuf[22];
    UBYTE *src;
    UBYTE *dst;
    LONG idx;

    src = entryPtr + ENTRY_NAME_OFFSET;
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
