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
extern const char Global_STR_LADFUNC_C_2[];
extern const char Global_STR_LADFUNC_C_3[];

extern UBYTE *ESQPARS_ReplaceOwnedString(UBYTE *oldString, const UBYTE *newString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void LADFUNC_FreeBannerRectEntries(void)
{
    LONG i;

    for (i = 0; i <= 46; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        LONG len = 0;
        UBYTE *p;

        if (entry == (LadfuncEntry *)0) {
            continue;
        }

        if (entry->textPtr != (UBYTE *)0) {
            p = entry->textPtr;
            while (*p != 0) {
                ++p;
            }
            len = (LONG)(p - entry->textPtr);
            (void)ESQPARS_ReplaceOwnedString(entry->textPtr, (const UBYTE *)0);
        }

        if (len > 0 && entry->attrPtr != (UBYTE *)0) {
            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_2, 147, entry->attrPtr, len);
        }

        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_3, 150, entry, 14);
        LADFUNC_EntryPtrTable[i] = (LadfuncEntry *)0;
    }
}
