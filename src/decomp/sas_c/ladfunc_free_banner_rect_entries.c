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
extern const char Global_STR_LADFUNC_C_2[];
extern const char Global_STR_LADFUNC_C_3[];

extern UBYTE *ESQPARS_ReplaceOwnedString(UBYTE *oldString, const UBYTE *newString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void LADFUNC_FreeBannerRectEntries(void)
{
    const LONG ENTRY_LAST_INDEX = 46;
    const LONG ENTRY_FREE_LINE_ATTR = 147;
    const LONG ENTRY_FREE_LINE_NODE = 150;
    const LONG ENTRY_NODE_SIZE = 14;
    const UBYTE CH_NUL = 0;
    const LONG LEN_EMPTY = 0;
    LONG i;

    for (i = 0; i <= ENTRY_LAST_INDEX; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        LONG len = LEN_EMPTY;
        UBYTE *p;

        if (entry == (LadfuncEntry *)0) {
            continue;
        }

        if (entry->textPtr != (UBYTE *)0) {
            p = entry->textPtr;
            while (*p != CH_NUL) {
                ++p;
            }
            len = (LONG)(p - entry->textPtr);
            (void)ESQPARS_ReplaceOwnedString(entry->textPtr, (const UBYTE *)0);
        }

        if (len > LEN_EMPTY && entry->attrPtr != (UBYTE *)0) {
            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_2, ENTRY_FREE_LINE_ATTR, entry->attrPtr, len);
        }

        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_3, ENTRY_FREE_LINE_NODE, entry, ENTRY_NODE_SIZE);
        LADFUNC_EntryPtrTable[i] = (LadfuncEntry *)0;
    }
}
