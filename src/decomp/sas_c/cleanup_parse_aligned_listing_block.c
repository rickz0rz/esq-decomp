#include <exec/types.h>

enum {
    CLEANUP_SLOT_MAP_COUNT = 10,
    CLEANUP_RECORD_TOKEN_COUNT = 9,
    CLEANUP_SUBENTRY_TOKEN_COUNT = 7,
    CLEANUP_RECORD_PREFIX_MARKER_1 = 49,
    CLEANUP_RECORD_HEADER_DISK_ID_SIZE = 1
};

typedef struct COI_SubEntry {
    WORD key0;
    char *field2;
    char *field6;
    char *field10;
    char *field14;
    char *field18;
    char *field22;
    LONG field26;
} COI_SubEntry;

typedef struct COI_AnimObject {
    UBYTE mode0;
    UBYTE mode1;
    UBYTE mode2;
    UBYTE mode3;
    char *field4;
    char *field8;
    char *field12;
    char *field16;
    char *field20;
    char *field24;
    char *field28;
    LONG field32;
    WORD subEntryCount;
    COI_SubEntry **subEntryTable;
} COI_AnimObject;

typedef struct COI_EntryTableEntry {
    UBYTE pad0[12];
    char titleText[36];
    COI_AnimObject *anim;
} COI_EntryTableEntry;

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
extern COI_EntryTableEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern COI_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
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

static void CLEANUP_InitRecordTokenTable(char *tokenTable)
{
    tokenTable[0] = 22;
    tokenTable[1] = 23;
    tokenTable[2] = 3;
    tokenTable[3] = 4;
    tokenTable[4] = 16;
    tokenTable[5] = 5;
    tokenTable[6] = 15;
    tokenTable[7] = 6;
    tokenTable[8] = 20;
}

static void CLEANUP_InitSubEntryTokenTable(char *tokenTable)
{
    tokenTable[0] = 22;
    tokenTable[1] = 23;
    tokenTable[2] = 16;
    tokenTable[3] = 5;
    tokenTable[4] = 15;
    tokenTable[5] = 6;
    tokenTable[6] = 20;
}

static COI_EntryTableEntry *CLEANUP_SelectEntry(UBYTE disk_id, LONG index)
{
    if (disk_id == TEXTDISP_SecondaryGroupCode &&
        (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        return TEXTDISP_SecondaryEntryPtrTable[index];
    }

    return TEXTDISP_PrimaryEntryPtrTable[index];
}

static LONG CLEANUP_StringLength(const char *text)
{
    const char *scan;

    scan = text;
    while (*scan != 0) {
        scan += 1;
    }

    return (LONG)(scan - text);
}

static char *CLEANUP_SelectAnimString(char *recordBase, LONG recordOffset, WORD tokenOffset, char *fallback)
{
    if ((WORD)(tokenOffset + 1) == 0) {
        return fallback;
    }

    return recordBase + recordOffset + (LONG)tokenOffset;
}

static void CLEANUP_CopyAnimObject(COI_EntryTableEntry *dstEntry, COI_AnimObject *srcAnim)
{
    COI_AnimObject *dstAnim;
    WORD i;

    dstAnim = dstEntry->anim;
    dstAnim->mode0 = srcAnim->mode0;
    dstAnim->mode1 = srcAnim->mode1;
    dstAnim->mode2 = srcAnim->mode2;
    dstAnim->mode3 = srcAnim->mode3;
    dstAnim->field4 = ESQPARS_ReplaceOwnedString(srcAnim->field4, dstAnim->field4);
    dstAnim->field12 = ESQPARS_ReplaceOwnedString(srcAnim->field12, dstAnim->field12);
    dstAnim->field20 = ESQPARS_ReplaceOwnedString(srcAnim->field20, dstAnim->field20);
    dstAnim->field8 = ESQPARS_ReplaceOwnedString(srcAnim->field8, dstAnim->field8);
    dstAnim->field16 = ESQPARS_ReplaceOwnedString(srcAnim->field16, dstAnim->field16);
    dstAnim->subEntryCount = srcAnim->subEntryCount;
    dstAnim->field24 = ESQPARS_ReplaceOwnedString(srcAnim->field24, dstAnim->field24);
    dstAnim->field28 = ESQPARS_ReplaceOwnedString(srcAnim->field28, dstAnim->field28);
    dstAnim->field32 = srcAnim->field32;

    COI_AllocSubEntryTable((void *)dstEntry);

    i = 0;
    while (i < srcAnim->subEntryCount) {
        COI_SubEntry *srcSub;
        COI_SubEntry *dstSub;

        srcSub = srcAnim->subEntryTable[i];
        dstSub = dstAnim->subEntryTable[i];

        dstSub->key0 = srcSub->key0;
        dstSub->field6 = ESQPARS_ReplaceOwnedString(srcSub->field6, dstSub->field6);
        dstSub->field14 = ESQPARS_ReplaceOwnedString(srcSub->field14, dstSub->field14);
        dstSub->field2 = ESQPARS_ReplaceOwnedString(srcSub->field2, dstSub->field2);
        dstSub->field10 = ESQPARS_ReplaceOwnedString(srcSub->field10, dstSub->field10);
        dstSub->field18 = ESQPARS_ReplaceOwnedString(srcSub->field18, dstSub->field18);
        dstSub->field22 = ESQPARS_ReplaceOwnedString(srcSub->field22, dstSub->field22);
        dstSub->field26 = srcSub->field26;
        i += 1;
    }
}

LONG CLEANUP_ParseAlignedListingBlock(char *record)
{
    WORD slotMap[CLEANUP_SLOT_MAP_COUNT];
    WORD recordTokenOffsets[CLEANUP_RECORD_TOKEN_COUNT];
    WORD subEntryTokenOffsets[CLEANUP_SUBENTRY_TOKEN_COUNT];
    char recordTokenTable[CLEANUP_RECORD_TOKEN_COUNT];
    char subEntryTokenTable[CLEANUP_SUBENTRY_TOKEN_COUNT];
    LONG recordOffset;
    LONG escapeCount;
    LONG tokenCount;
    LONG entryCount;
    LONG i;
    LONG matchCount;
    UBYTE diskId;
    COI_EntryTableEntry *entry;
    COI_AnimObject *anim;

    CLEANUP_InitRecordTokenTable(recordTokenTable);
    CLEANUP_InitSubEntryTokenTable(subEntryTokenTable);

    for (i = 0; i < CLEANUP_SLOT_MAP_COUNT; i += 1) {
        slotMap[i] = -1;
    }

    diskId = (UBYTE)record[0];
    recordOffset = CLEANUP_RECORD_HEADER_DISK_ID_SIZE;

    if (diskId == TEXTDISP_SecondaryGroupCode &&
        (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        entryCount = (LONG)TEXTDISP_SecondaryGroupEntryCount;
        CTASKS_PendingSecondaryOiDiskId = diskId;
        CTASKS_SecondaryOiWritePendingFlag = 1;
    } else if (diskId == TEXTDISP_PrimaryGroupCode) {
        entryCount = (LONG)TEXTDISP_PrimaryGroupEntryCount;
        CTASKS_PendingPrimaryOiDiskId = diskId;
        CTASKS_PrimaryOiWritePendingFlag = 1;
    } else {
        return 1;
    }

    if ((UBYTE)record[recordOffset] == CLEANUP_RECORD_PREFIX_MARKER_1) {
        recordOffset += 1;
    }

    escapeCount = COI_CountEscape14BeforeNull(
        record + recordOffset,
        (LONG)ESQIFF_RecordLength - recordOffset);

    tokenCount = SCRIPT_BuildTokenIndexMap(
        record + recordOffset,
        recordTokenOffsets,
        CLEANUP_RECORD_TOKEN_COUNT,
        recordTokenTable,
        (WORD)((LONG)ESQIFF_RecordLength - recordOffset),
        0,
        1);

    matchCount = 0;
    i = 0;
    while (i < entryCount && matchCount < CLEANUP_SLOT_MAP_COUNT) {
        COI_EntryTableEntry *candidate;

        candidate = CLEANUP_SelectEntry(diskId, i);
        if (ESQ_WildcardMatch(candidate->titleText, record + recordOffset) == 0) {
            slotMap[matchCount] = (WORD)i;
            matchCount += 1;
        }
        i += 1;
    }

    if ((WORD)(slotMap[0] + 1) == 0) {
        return 2;
    }

    entry = CLEANUP_SelectEntry(diskId, (LONG)slotMap[0]);
    COI_ClearAnimObjectStrings((void *)entry);
    COI_FreeSubEntryTableEntries((void *)entry);

    anim = entry->anim;
    anim->field4 = ESQPARS_ReplaceOwnedString(
        record + recordOffset + (LONG)recordTokenOffsets[2],
        anim->field4);

    anim->mode0 = (UBYTE)record[recordOffset + (LONG)recordTokenOffsets[3] + 0];
    anim->mode1 = (UBYTE)record[recordOffset + (LONG)recordTokenOffsets[3] + 1];
    anim->mode2 = (UBYTE)record[recordOffset + (LONG)recordTokenOffsets[3] + 2];
    anim->mode3 = 0;

    anim->field12 = ESQPARS_ReplaceOwnedString(
        record + recordOffset + (LONG)recordTokenOffsets[4],
        anim->field12);
    anim->field20 = ESQPARS_ReplaceOwnedString(
        record + recordOffset + (LONG)recordTokenOffsets[5],
        anim->field20);
    anim->field8 = ESQPARS_ReplaceOwnedString(
        record + recordOffset + (LONG)recordTokenOffsets[6],
        anim->field8);
    anim->field16 = ESQPARS_ReplaceOwnedString(
        record + recordOffset + (LONG)recordTokenOffsets[7],
        anim->field16);
    anim->subEntryCount = (WORD)escapeCount;

    if (record[recordOffset + (LONG)recordTokenOffsets[0]] != 0) {
        CLEANUP_FormatEntryStringTokens(
            (void **)&anim->field24,
            (void **)&anim->field28,
            record + recordOffset + (LONG)recordTokenOffsets[0]);
    } else {
        anim->field24 = ESQPARS_ReplaceOwnedString((const char *)0, anim->field24);
        anim->field28 = ESQPARS_ReplaceOwnedString(
            CLOCK_STR_MISSING_TITLE_TEMPLATE,
            anim->field28);
    }

    if (record[recordOffset + (LONG)recordTokenOffsets[1]] != 0) {
        anim->field32 = PARSE_ReadSignedLongSkipClass3_Alt(
            record + recordOffset + (LONG)recordTokenOffsets[1]);
    } else {
        anim->field32 = -1;
    }

    recordOffset += (LONG)recordTokenOffsets[7];
    if (anim->field16 != (char *)0) {
        recordOffset += CLEANUP_StringLength(anim->field16);
    }
    recordOffset += 1;

    COI_AllocSubEntryTable((void *)entry);

    i = 0;
    while (i < (LONG)anim->subEntryCount) {
        COI_SubEntry *subEntry;
        char *fieldValue;

        subEntry = anim->subEntryTable[i];
        subEntry->key0 = (WORD)(UBYTE)record[recordOffset];
        recordOffset += 1;

        tokenCount = SCRIPT_BuildTokenIndexMap(
            record + recordOffset,
            subEntryTokenOffsets,
            CLEANUP_SUBENTRY_TOKEN_COUNT,
            subEntryTokenTable,
            (WORD)((LONG)ESQIFF_RecordLength - recordOffset),
            0,
            0);

        fieldValue = CLEANUP_SelectAnimString(record, recordOffset, subEntryTokenOffsets[2], anim->field12);
        subEntry->field6 = ESQPARS_ReplaceOwnedString(fieldValue, subEntry->field6);

        fieldValue = CLEANUP_SelectAnimString(record, recordOffset, subEntryTokenOffsets[3], anim->field20);
        subEntry->field14 = ESQPARS_ReplaceOwnedString(fieldValue, subEntry->field14);

        fieldValue = CLEANUP_SelectAnimString(record, recordOffset, subEntryTokenOffsets[4], anim->field8);
        subEntry->field2 = ESQPARS_ReplaceOwnedString(fieldValue, subEntry->field2);

        fieldValue = CLEANUP_SelectAnimString(record, recordOffset, subEntryTokenOffsets[5], anim->field16);
        subEntry->field10 = ESQPARS_ReplaceOwnedString(fieldValue, subEntry->field10);

        if ((WORD)(subEntryTokenOffsets[0] + 1) == 0) {
            subEntry->field18 = ESQPARS_ReplaceOwnedString(anim->field24, subEntry->field18);
            subEntry->field22 = ESQPARS_ReplaceOwnedString(anim->field28, subEntry->field22);
        } else {
            CLEANUP_FormatEntryStringTokens(
                (void **)&subEntry->field18,
                (void **)&subEntry->field22,
                record + recordOffset + (LONG)subEntryTokenOffsets[0]);
        }

        if ((WORD)(subEntryTokenOffsets[1] + 1) == 0) {
            subEntry->field26 = anim->field32;
        } else {
            subEntry->field26 = PARSE_ReadSignedLongSkipClass3_Alt(
                record + recordOffset + (LONG)subEntryTokenOffsets[1]);
        }

        recordOffset += (LONG)subEntryTokenOffsets[6];
        i += 1;
    }

    i = 1;
    while (i < CLEANUP_SLOT_MAP_COUNT && slotMap[i] != -1) {
        COI_EntryTableEntry *matchEntry;

        matchEntry = CLEANUP_SelectEntry(diskId, (LONG)slotMap[i]);

        COI_ClearAnimObjectStrings((void *)matchEntry);
        COI_FreeSubEntryTableEntries((void *)matchEntry);
        CLEANUP_CopyAnimObject(matchEntry, anim);
        i += 1;
    }

    (void)tokenCount;
    return COI_WriteOiDataFile(diskId);
}
