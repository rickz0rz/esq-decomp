typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    char *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LadfuncEntry *LADFUNC_EntryPtrTable[];
extern LONG ED_TextLimit;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG LADFUNC_ComposePackedPenByte(UBYTE highNibble, UBYTE lowNibble);
extern void LADFUNC_ReflowEntryBuffers(char *textBuf, UBYTE *attrBuf);

void LADFUNC_BuildEntryBuffersOrDefault(LONG entryIndex, char *outText, UBYTE *outAttr)
{
    const LONG LINE_WIDTH = 40;
    const UBYTE DEFAULT_PEN_HIGH_NIBBLE = 2;
    const UBYTE DEFAULT_PEN_LOW_NIBBLE = 1;
    const UBYTE SPACE_CHAR = 32;
    const UBYTE CH_NUL = 0;
    const LONG PTR_NULL = 0;
    LONG count;
    LadfuncEntry *entry;
    LONG packedLong;
    LONG i;

    entry = LADFUNC_EntryPtrTable[entryIndex];
    if (entry->textPtr == (char *)PTR_NULL) {
        count = NEWGRID_JMPTBL_MATH_Mulu32(ED_TextLimit, LINE_WIDTH);
        for (i = 0; i < count; ++i) {
            outText[i] = SPACE_CHAR;
        }
        outText[count] = CH_NUL;

        packedLong = LADFUNC_ComposePackedPenByte(DEFAULT_PEN_HIGH_NIBBLE, DEFAULT_PEN_LOW_NIBBLE);
        count = NEWGRID_JMPTBL_MATH_Mulu32(ED_TextLimit, LINE_WIDTH);
        {
            UBYTE *dst = outAttr;
            for (i = count; i > 0; --i) {
                *dst++ = (UBYTE)packedLong;
            }
        }
        return;
    }

    {
        char *src = entry->textPtr;
        char *dst = outText;
        while ((*dst++ = *src++) != CH_NUL) {
        }
    }

    {
        char *p = outText;
        while (*p != CH_NUL) {
            ++p;
        }
        count = (LONG)(p - outText);
    }

    {
        UBYTE *src = entry->attrPtr;
        UBYTE *dst = outAttr;
        for (i = 0; i < count; ++i) {
            *dst++ = *src++;
        }
    }

    LADFUNC_ReflowEntryBuffers(outText, outAttr);
}
