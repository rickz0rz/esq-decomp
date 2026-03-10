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

extern UWORD ESQIFF_StatusPacketReadyFlag;
extern UBYTE ED_DiagTextModeChar;
extern UWORD LADFUNC_ParsedEntryCount;
extern LADFUNC_EntryRecord *LADFUNC_EntryPtrTable[];

extern const char Global_STR_LADFUNC_C_5[];
extern const char Global_STR_LADFUNC_C_6[];
extern const char Global_STR_LADFUNC_C_7[];
extern const char Global_STR_LADFUNC_C_8[];
extern const char LADFUNC_TAG_RS_ResetTriggerSet[];
extern const char LADFUNC_TAG_RS_ParseAllowedSet[];

extern LONG GROUP_AS_JMPTBL_STR_FindCharPtr(const char *s, LONG ch);
extern UBYTE LADFUNC_ComposePackedPenByte(LONG hi, LONG lo);
extern void LADFUNC_ResetEntryTextBuffers(void);
extern LONG LADFUNC_ParseHexDigit(LONG ch);
extern LONG LADFUNC_SetPackedPenHighNibble(LONG packed, LONG hi);
extern LONG LADFUNC_SetPackedPenLowNibble(LONG packed, LONG lo);
extern LONG ESQIFF2_ValidateAsciiNumericByte(LONG ch);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern void LADFUNC_UpdateHighlightState(void);
extern UBYTE *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

LONG LADFUNC_ParseBannerEntryData(UBYTE mode, const char *in)
{
    const UBYTE DEFAULT_PEN_HIGH = 2;
    const UBYTE DEFAULT_PEN_LOW = 1;
    const LONG RESET_SENTINEL_CODE = (73L * 2L);
    const UBYTE ENTRY_INDEX_MAX_EXCLUSIVE = 46;
    const UBYTE ENTRY_START_SLOT_DEFAULT = 1;
    const UWORD ENTRY_END_SLOT_DEFAULT = 0x30;
    const UWORD ATTR_TEMP_ALLOC_SIZE = 304;
    const UWORD TEXT_SCRATCH_MAX = 0x190;
    const UBYTE CTRL_SET_PENS = 3;
    const UBYTE CTRL_SET_TIME_WINDOW = 20;
    const UBYTE PEN_NIBBLE_MAX = 7;
    const LONG ATTR_FREE_LINE = 412;
    const LONG ATTR_ALLOC_LINE = 413;
    const LONG ATTR_TMP_FREE_LINE = 416;
    UBYTE entryByte;
    UBYTE packedPens;
    UBYTE *tempAttr;
    char textScratch[402];
    UWORD textLen;
    LADFUNC_EntryRecord *entry;

    packedPens = LADFUNC_ComposePackedPenByte(DEFAULT_PEN_HIGH, DEFAULT_PEN_LOW);
    entryByte = *in++;

    if ((LONG)entryByte == RESET_SENTINEL_CODE) {
        if ((mode == 'L' || mode == 't') &&
            (UWORD)(ESQIFF_StatusPacketReadyFlag - 1) == 0 &&
            GROUP_AS_JMPTBL_STR_FindCharPtr(LADFUNC_TAG_RS_ResetTriggerSet, (LONG)ED_DiagTextModeChar) != 0) {
            LADFUNC_ResetEntryTextBuffers();
        }
        return 0;
    }

    if ((mode != 'L' && mode != 't') ||
        GROUP_AS_JMPTBL_STR_FindCharPtr(LADFUNC_TAG_RS_ParseAllowedSet, (LONG)ED_DiagTextModeChar) == 0 ||
        entryByte >= ENTRY_INDEX_MAX_EXCLUSIVE) {
        return 0;
    }

    LADFUNC_ParsedEntryCount = (UWORD)(LADFUNC_ParsedEntryCount + 1);
    if (LADFUNC_ParsedEntryCount >= ENTRY_INDEX_MAX_EXCLUSIVE) {
        return 0;
    }

    entryByte = (UBYTE)(entryByte - 1);
    entry = LADFUNC_EntryPtrTable[(LONG)entryByte];
    entry->startSlot = ENTRY_START_SLOT_DEFAULT;
    entry->endSlot = ENTRY_END_SLOT_DEFAULT;

    textLen = 0;
    tempAttr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_5,
        367,
        ATTR_TEMP_ALLOC_SIZE,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );
    if (tempAttr == (UBYTE *)0) {
        return 0;
    }

    for (;;) {
        UBYTE c = (UBYTE)*in++;

        if (c == 0 || textLen >= TEXT_SCRATCH_MAX) {
            break;
        }

        if (c == CTRL_SET_PENS) {
            LONG hi = LADFUNC_ParseHexDigit((LONG)(*in++));
            if ((UBYTE)hi <= PEN_NIBBLE_MAX) {
                packedPens = LADFUNC_SetPackedPenHighNibble((LONG)packedPens, hi);
            }

            {
                LONG lo = LADFUNC_ParseHexDigit((LONG)(*in++));
                if ((UBYTE)lo <= PEN_NIBBLE_MAX) {
                    packedPens = LADFUNC_SetPackedPenLowNibble((LONG)packedPens, lo);
                }
            }
            continue;
        }

        if (c == CTRL_SET_TIME_WINDOW) {
            entry->startSlot = (UWORD)(*in++);
            entry->endSlot = (UWORD)(*in++);
            entry->startSlot = (UWORD)(UBYTE)ESQIFF2_ValidateAsciiNumericByte((LONG)entry->startSlot);
            entry->endSlot = (UWORD)(UBYTE)ESQIFF2_ValidateAsciiNumericByte((LONG)entry->endSlot);
            continue;
        }

        tempAttr[textLen] = packedPens;
        textScratch[textLen] = c;
        ++textLen;
    }

    textScratch[textLen] = 0;
    entry->textPtr = ESQPARS_ReplaceOwnedString(textScratch, entry->textPtr);

    if (entry->attrPtr != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_LADFUNC_C_6,
            ATTR_FREE_LINE,
            entry->attrPtr,
            ATTR_TEMP_ALLOC_SIZE
        );
    }

    entry->attrPtr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_7,
        ATTR_ALLOC_LINE,
        (LONG)textLen,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );

    if (entry->attrPtr != (UBYTE *)0) {
        LONG i;
        for (i = 0; i < (LONG)textLen; ++i) {
            entry->attrPtr[i] = tempAttr[i];
        }
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_LADFUNC_C_8,
        ATTR_TMP_FREE_LINE,
        tempAttr,
        ATTR_TEMP_ALLOC_SIZE
    );

    LADFUNC_UpdateHighlightState();
    return 1;
}
