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
extern const char Global_STR_LADFUNC_C_4[];

extern char *ESQPARS_ReplaceOwnedString(char *oldString, const char *newString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void LADFUNC_ClearBannerRectEntries(void);

void LADFUNC_ResetEntryTextBuffers(void)
{
    const LONG ENTRY_LAST_INDEX = 46;
    const LONG ATTR_FREE_LINE = 212;
    const UBYTE CH_NUL = 0;
    const LONG LEN_EMPTY = 0;
    LONG i;

    for (i = 0; i <= ENTRY_LAST_INDEX; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        LONG len = LEN_EMPTY;
        char *p;

        if (entry == (LadfuncEntry *)0) {
            continue;
        }
        if (entry->textPtr == (char *)0) {
            continue;
        }

        p = entry->textPtr;
        while (*p != CH_NUL) {
            ++p;
        }
        len = (LONG)(p - entry->textPtr);

        if (len > LEN_EMPTY && entry->attrPtr != (UBYTE *)0) {
            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_4, ATTR_FREE_LINE, entry->attrPtr, len);
        }

        entry->textPtr = ESQPARS_ReplaceOwnedString(entry->textPtr, (const char *)0);
    }

    LADFUNC_ClearBannerRectEntries();
}
