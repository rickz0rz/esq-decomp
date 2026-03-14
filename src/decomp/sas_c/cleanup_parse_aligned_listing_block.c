#include <exec/types.h>
typedef struct CLEANUP_EntryTableEntry {
    UBYTE pad0[12];
    UBYTE titleText[1];
} CLEANUP_EntryTableEntry;

#define SLOT_MAP_COUNT 10
#define SLOT_MAP_MAX_TOKENS 9
#define RECORD_PREFIX_MARKER_1 49
#define RECORD_HEADER_DISK_ID_SIZE 1
#define DELIMITER_COUNT_ONE 1

extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE CTASKS_PendingSecondaryOiDiskId;
extern UBYTE CTASKS_SecondaryOiWritePendingFlag;
extern UBYTE CTASKS_PendingPrimaryOiDiskId;
extern UBYTE CTASKS_PrimaryOiWritePendingFlag;
extern UWORD ESQIFF_RecordLength;
extern CLEANUP_EntryTableEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern CLEANUP_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern char CLOCK_STR_MISSING_TITLE_TEMPLATE[];

LONG COI_CountEscape14BeforeNull(char *buf, LONG max_len);
LONG SCRIPT_BuildTokenIndexMap(char *inputBytes, WORD *outIndexByToken, WORD tokenCount, const char *tokenTable, WORD maxScanCount, char terminatorByte, WORD fillMissingFlag);
LONG ESQ_WildcardMatch(const char *a, const char *b);
void COI_ClearAnimObjectStrings(void *entry);
void COI_FreeSubEntryTableEntries(void *entry);
char *ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);
void CLEANUP_FormatEntryStringTokens(void **a, void **b, char *in);
LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
void COI_AllocSubEntryTable(void *entry);
LONG COI_WriteOiDataFile(UBYTE disk_id);

LONG CLEANUP_ParseAlignedListingBlock(char *record, char *listing)
{
    WORD slotMap[SLOT_MAP_COUNT];
    LONG recordOffset;
    LONG escapeCount;
    LONG tokenCount;
    LONG i;
    LONG entry_count;
    UBYTE disk_id;
    CLEANUP_EntryTableEntry *entry;

    if (record == (char *)0 || listing == (char *)0) {
        return 1;
    }

    for (i = 0; i < SLOT_MAP_COUNT; i += 1) {
        slotMap[i] = -1;
    }

    disk_id = record[0];
    recordOffset = RECORD_HEADER_DISK_ID_SIZE;

    if (disk_id == TEXTDISP_SecondaryGroupCode && (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        entry_count = (LONG)TEXTDISP_SecondaryGroupEntryCount;
        CTASKS_PendingSecondaryOiDiskId = disk_id;
        CTASKS_SecondaryOiWritePendingFlag = 1;
    } else if (disk_id == TEXTDISP_PrimaryGroupCode) {
        entry_count = (LONG)TEXTDISP_PrimaryGroupEntryCount;
        CTASKS_PendingPrimaryOiDiskId = disk_id;
        CTASKS_PrimaryOiWritePendingFlag = 1;
    } else {
        return 1;
    }

    if (record[recordOffset] == RECORD_PREFIX_MARKER_1) {
        recordOffset += 1;
    }

    escapeCount = COI_CountEscape14BeforeNull(record + recordOffset, (LONG)ESQIFF_RecordLength - recordOffset);
    tokenCount = SCRIPT_BuildTokenIndexMap(record + recordOffset,
                                           slotMap,
                                           (WORD)SLOT_MAP_MAX_TOKENS,
                                           record + recordOffset,
                                           (WORD)((LONG)ESQIFF_RecordLength - recordOffset),
                                           0,
                                           0);

    for (i = 0; i < entry_count && i < SLOT_MAP_COUNT; i += 1) {
        CLEANUP_EntryTableEntry *candidate;

        if (disk_id == TEXTDISP_SecondaryGroupCode && (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
            candidate = TEXTDISP_SecondaryEntryPtrTable[i];
        } else {
            candidate = TEXTDISP_PrimaryEntryPtrTable[i];
        }

        if (candidate != (void *)0) {
            (void)ESQ_WildcardMatch(candidate->titleText, record + recordOffset);
        }
    }

    entry = (disk_id == TEXTDISP_SecondaryGroupCode && (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0)
        ? TEXTDISP_SecondaryEntryPtrTable[0]
        : TEXTDISP_PrimaryEntryPtrTable[0];

    if (entry == (void *)0) {
        return 2;
    }

    COI_ClearAnimObjectStrings(entry);
    COI_FreeSubEntryTableEntries(entry);

    ESQPARS_ReplaceOwnedString((const char *)0, listing);
    ESQPARS_ReplaceOwnedString((const char *)0, CLOCK_STR_MISSING_TITLE_TEMPLATE);

    {
        void *a = (void *)0;
        void *b = (void *)0;
        CLEANUP_FormatEntryStringTokens(&a, &b, listing);
    }

    (void)PARSE_ReadSignedLongSkipClass3_Alt(listing);
    COI_AllocSubEntryTable(entry);

    (void)escapeCount;
    (void)tokenCount;

    return COI_WriteOiDataFile(disk_id);
}
