typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

typedef struct LADFUNC_EntryRecord {
    UWORD startSlot;
    UWORD endSlot;
    UBYTE align_pad[2];
    char *textPtr;
    UBYTE *attrPtr;
} LADFUNC_EntryRecord;

extern LADFUNC_EntryRecord *LADFUNC_EntryPtrTable[];

extern void LADFUNC_RepackEntryTextAndAttrBuffers(char *textBuf, UBYTE *attrBuf);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern char *ESQPARS_ReplaceOwnedString(char *newText, char *oldText);

extern const char Global_STR_LADFUNC_C_28[];
extern const char Global_STR_LADFUNC_C_29[];
extern const char Global_STR_LADFUNC_C_30[];

void LADFUNC_UpdateEntryFromTextAndAttrBuffers(LONG entryIndex, char *textBuf, UBYTE *attrBuf)
{
    const LONG ENTRY_RECORD_SIZE = 14;
    const LONG MEMF_PUBLIC_CLEAR = (MEMF_PUBLIC + MEMF_CLEAR);
    LADFUNC_EntryRecord *entry;
    LONG oldTextLen;
    LONG newTextLen;

    LADFUNC_RepackEntryTextAndAttrBuffers(textBuf, attrBuf);

    entry = LADFUNC_EntryPtrTable[entryIndex];
    if (entry == (LADFUNC_EntryRecord *)0) {
        entry = (LADFUNC_EntryRecord *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_LADFUNC_C_28,
            1362,
            ENTRY_RECORD_SIZE,
            MEMF_PUBLIC_CLEAR
        );
        LADFUNC_EntryPtrTable[entryIndex] = entry;
        if (entry != (LADFUNC_EntryRecord *)0) {
            entry->startSlot = 0;
            entry->endSlot = 0;
        }
    }

    if (entry == (LADFUNC_EntryRecord *)0) {
        return;
    }

    oldTextLen = 0;
    if (entry->textPtr != (char *)0) {
        char *p = entry->textPtr;
        while (*p != 0) {
            ++p;
        }
        oldTextLen = (LONG)(p - entry->textPtr);
    }

    entry->textPtr = ESQPARS_ReplaceOwnedString(textBuf, entry->textPtr);

    if (oldTextLen != 0 && entry->attrPtr != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_LADFUNC_C_29,
            1386,
            entry->attrPtr,
            oldTextLen
        );
    }

    newTextLen = 0;
    if (entry->textPtr != (char *)0) {
        char *p = entry->textPtr;
        while (*p != 0) {
            ++p;
        }
        newTextLen = (LONG)(p - entry->textPtr);
    }

    entry->attrPtr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_30,
        1389,
        newTextLen,
        MEMF_PUBLIC_CLEAR
    );
    if (entry->attrPtr == (UBYTE *)0) {
        return;
    }

    {
        LONG i;
        for (i = 0; i < newTextLen; ++i) {
            entry->attrPtr[i] = attrBuf[i];
        }
    }
}
