typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_AliasCount;
extern void *TEXTDISP_AliasPtrTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

LONG TEXTDISP_FindAliasIndexByName(UBYTE *entryPtr)
{
    UBYTE nameBuf[22];
    UBYTE *src;
    UBYTE *dst;
    LONG idx;

    src = entryPtr + 12;
    dst = nameBuf;
    do {
        *dst = *src;
        dst += 1;
        src += 1;
    } while (dst[-1] != 0);

    idx = 0;
    while ((WORD)idx < TEXTDISP_AliasCount) {
        UBYTE **aliasNode;
        UBYTE *alias;
        LONG len;

        aliasNode = (UBYTE **)TEXTDISP_AliasPtrTable[idx];
        alias = aliasNode[0];
        len = 0;
        while (alias[len] != 0) {
            len += 1;
        }

        if (STRING_CompareNoCaseN((const char *)nameBuf, (const char *)alias, len) == 0) {
            return idx;
        }
        idx += 1;
    }

    return -1;
}
