typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

typedef struct LADFUNC_EntryRecord {
    UWORD value0;
    UWORD value1;
    UBYTE reserved[2];
    UBYTE *textPtr;
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
extern UBYTE LADFUNC_SetPackedPenHighNibble(LONG packed, LONG hi);
extern UBYTE LADFUNC_SetPackedPenLowNibble(LONG packed, LONG lo);
extern LONG ESQIFF2_ValidateAsciiNumericByte(LONG ch);
extern UBYTE *ESQPARS_ReplaceOwnedString(UBYTE *newText, UBYTE *oldText);
extern void LADFUNC_UpdateHighlightState(void);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

LONG LADFUNC_ParseBannerEntryData(UBYTE mode, const UBYTE *in)
{
    UBYTE entryByte;
    UBYTE packedPens;
    UBYTE *tempAttr;
    UBYTE textScratch[402];
    UWORD textLen;
    LADFUNC_EntryRecord *entry;

    packedPens = LADFUNC_ComposePackedPenByte(2, 1);
    entryByte = *in++;

    if ((LONG)entryByte == (73L * 2L)) {
        if ((mode == 'L' || mode == 't') &&
            (UWORD)(ESQIFF_StatusPacketReadyFlag - 1) == 0 &&
            GROUP_AS_JMPTBL_STR_FindCharPtr(LADFUNC_TAG_RS_ResetTriggerSet, (LONG)ED_DiagTextModeChar) != 0) {
            LADFUNC_ResetEntryTextBuffers();
        }
        return 0;
    }

    if ((mode != 'L' && mode != 't') ||
        GROUP_AS_JMPTBL_STR_FindCharPtr(LADFUNC_TAG_RS_ParseAllowedSet, (LONG)ED_DiagTextModeChar) == 0 ||
        entryByte >= 46) {
        return 0;
    }

    LADFUNC_ParsedEntryCount = (UWORD)(LADFUNC_ParsedEntryCount + 1);
    if (LADFUNC_ParsedEntryCount >= 46) {
        return 0;
    }

    entryByte = (UBYTE)(entryByte - 1);
    entry = LADFUNC_EntryPtrTable[(LONG)entryByte];
    entry->value0 = 1;
    entry->value1 = 0x30;

    textLen = 0;
    tempAttr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_5,
        367,
        304,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );
    if (tempAttr == (UBYTE *)0) {
        return 0;
    }

    for (;;) {
        UBYTE c = *in++;

        if (c == 0 || textLen >= 0x190) {
            break;
        }

        if (c == 3) {
            LONG hi = LADFUNC_ParseHexDigit((LONG)(*in++));
            if ((UBYTE)hi <= 7) {
                packedPens = LADFUNC_SetPackedPenHighNibble((LONG)packedPens, hi);
            }

            {
                LONG lo = LADFUNC_ParseHexDigit((LONG)(*in++));
                if ((UBYTE)lo <= 7) {
                    packedPens = LADFUNC_SetPackedPenLowNibble((LONG)packedPens, lo);
                }
            }
            continue;
        }

        if (c == 20) {
            entry->value0 = (UWORD)(*in++);
            entry->value1 = (UWORD)(*in++);
            entry->value0 = (UWORD)(UBYTE)ESQIFF2_ValidateAsciiNumericByte((LONG)entry->value0);
            entry->value1 = (UWORD)(UBYTE)ESQIFF2_ValidateAsciiNumericByte((LONG)entry->value1);
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
            412,
            entry->attrPtr,
            304
        );
    }

    entry->attrPtr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_7,
        413,
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
        416,
        tempAttr,
        304
    );

    LADFUNC_UpdateHighlightState();
    return 1;
}
