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
extern const char Global_STR_LADFUNC_C_1[];
extern LadfuncEntry *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);

void LADFUNC_AllocBannerRectEntries(void)
{
    LONG i;

    for (i = 0; i <= 46; ++i) {
        LADFUNC_EntryPtrTable[i] = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_LADFUNC_C_1,
            116,
            14,
            0x10001
        );
    }
}
