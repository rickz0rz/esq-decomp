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

extern const char KYBD_PATH_DF0_LOCAL_ADS[];

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;
extern LadfuncEntry *LADFUNC_EntryPtrTable[];

extern LONG LADFUNC_ComposePackedPenByte(UBYTE highNibble, UBYTE lowNibble);
extern LONG GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern LONG GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void);
extern UBYTE *GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG LADFUNC_ParseHexDigit(LONG ch);
extern LONG LADFUNC_SetPackedPenHighNibble(UBYTE packed, UBYTE nibble);
extern LONG LADFUNC_SetPackedPenLowNibble(UBYTE packed, UBYTE nibble);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void LADFUNC_ResetEntryTextBuffers(void);

extern const char Global_STR_LADFUNC_C_9[];
extern const char Global_STR_LADFUNC_C_10[];
extern const char Global_STR_LADFUNC_C_11[];
extern const char Global_STR_LADFUNC_C_12[];
extern const char Global_STR_LADFUNC_C_13[];

LONG LADFUNC_LoadTextAdsFromFile(void)
{
    UBYTE currentAttr;
    LONG entryIndex;
    LONG fileLen;
    UBYTE *fileBuf;

    currentAttr = (UBYTE)LADFUNC_ComposePackedPenByte(2, 1);

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(KYBD_PATH_DF0_LOCAL_ADS) == -1) {
        return -1;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    fileBuf = Global_PTR_WORK_BUFFER;

    LADFUNC_ResetEntryTextBuffers();

    for (entryIndex = 0; entryIndex <= 46; ++entryIndex) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[entryIndex];
        UBYTE *encoded;
        LONG encodedLen = 0;
        LONG textLen = 0;
        LONG i;

        entry->startSlot = (UWORD)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
        entry->endSlot = (UWORD)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
        encoded = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();

        while (encoded[encodedLen] != 0) {
            ++encodedLen;
        }

        for (i = 0; i < encodedLen; ++i) {
            if (encoded[i] == 3 && (i + 2) < encodedLen) {
                i += 2;
            } else {
                ++textLen;
            }
        }

        if (textLen > 0) {
            entry->textPtr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_LADFUNC_C_9, 591, textLen + 1, 0x10001
            );
            if (entry->textPtr == (UBYTE *)0) {
                return -1;
            }

            entry->attrPtr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_LADFUNC_C_10, 600, textLen, 0x10001
            );
            if (entry->attrPtr == (UBYTE *)0) {
                return -1;
            }

            {
                LONG out = 0;
                for (i = 0; i < encodedLen; ++i) {
                    UBYTE ch = encoded[i];
                    if (ch == 3 && (i + 2) < encodedLen) {
                        UBYTE hi = (UBYTE)LADFUNC_ParseHexDigit((LONG)encoded[++i]);
                        currentAttr = (UBYTE)LADFUNC_SetPackedPenHighNibble(currentAttr, hi);
                        {
                            UBYTE lo = (UBYTE)LADFUNC_ParseHexDigit((LONG)encoded[++i]);
                            currentAttr = (UBYTE)LADFUNC_SetPackedPenLowNibble(currentAttr, lo);
                        }
                    } else {
                        entry->textPtr[out] = ch;
                        entry->attrPtr[out] = currentAttr;
                        ++out;
                    }
                }
                entry->textPtr[out] = 0;
            }
        } else {
            if (entry->textPtr != (UBYTE *)0) {
                UBYTE *p = entry->textPtr;
                LONG oldLen = 0;
                while (*p++ != 0) {
                    ++oldLen;
                }
                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_11, 638, entry->textPtr, oldLen + 1);
                entry->textPtr = (UBYTE *)0;
                if (entry->attrPtr != (UBYTE *)0) {
                    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_12, 642, entry->attrPtr, oldLen);
                    entry->attrPtr = (UBYTE *)0;
                }
            }
        }
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_13, 653, fileBuf, fileLen + 1);
    return 0;
}
