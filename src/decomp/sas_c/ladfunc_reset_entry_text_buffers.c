typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    UBYTE *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LadfuncEntry *LADFUNC_EntryPtrTable[];
extern const char Global_STR_LADFUNC_C_4[];

extern UBYTE *ESQPARS_ReplaceOwnedString(UBYTE *oldString, const UBYTE *newString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void LADFUNC_ClearBannerRectEntries(void);

void LADFUNC_ResetEntryTextBuffers(void)
{
    LONG i;

    for (i = 0; i <= 46; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        LONG len = 0;
        UBYTE *p;

        if (entry == (LadfuncEntry *)0) {
            continue;
        }
        if (entry->textPtr == (UBYTE *)0) {
            continue;
        }

        p = entry->textPtr;
        while (*p != 0) {
            ++p;
        }
        len = (LONG)(p - entry->textPtr);

        if (len > 0 && entry->attrPtr != (UBYTE *)0) {
            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_4, 212, entry->attrPtr, len);
        }

        entry->textPtr = ESQPARS_ReplaceOwnedString(entry->textPtr, (const UBYTE *)0);
    }

    LADFUNC_ClearBannerRectEntries();
}
