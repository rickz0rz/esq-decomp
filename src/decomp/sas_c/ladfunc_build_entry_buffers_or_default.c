typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    short startSlot;
    short endSlot;
    short isHighlighted;
    UBYTE *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LadfuncEntry *LADFUNC_EntryPtrTable[];
extern LONG ED_TextLimit;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG LADFUNC_ComposePackedPenByte(UBYTE highNibble, UBYTE lowNibble);
extern void LADFUNC_ReflowEntryBuffers(UBYTE *textBuf, UBYTE *attrBuf);

void LADFUNC_BuildEntryBuffersOrDefault(LONG entryIndex, UBYTE *outText, UBYTE *outAttr)
{
    LONG count;
    LadfuncEntry *entry;
    UBYTE packed;
    LONG i;

    entry = LADFUNC_EntryPtrTable[entryIndex];
    if (entry->textPtr == (UBYTE *)0) {
        count = NEWGRID_JMPTBL_MATH_Mulu32(ED_TextLimit, 40);
        for (i = 0; i < count; ++i) {
            outText[i] = 32;
        }
        outText[count] = 0;

        packed = (UBYTE)LADFUNC_ComposePackedPenByte(2, 1);
        count = NEWGRID_JMPTBL_MATH_Mulu32(ED_TextLimit, 40);
        for (i = 0; i < count; ++i) {
            outAttr[i] = packed;
        }
        return;
    }

    {
        UBYTE *src = entry->textPtr;
        UBYTE *dst = outText;
        while ((*dst++ = *src++) != 0) {
        }
    }

    {
        UBYTE *p = outText;
        while (*p != 0) {
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
