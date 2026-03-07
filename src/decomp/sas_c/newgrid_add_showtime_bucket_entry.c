typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ShowtimeBucketEntry {
    LONG key;
    UBYTE *text;
} NEWGRID_ShowtimeBucketEntry;

extern LONG NEWGRID_ShowtimeBucketCount;
extern NEWGRID_ShowtimeBucketEntry NEWGRID_ShowtimeBucketEntryTable[];
extern NEWGRID_ShowtimeBucketEntry *NEWGRID_ShowtimeBucketPtrTable[];

extern UBYTE *PARSEINI_JMPTBL_STR_FindCharPtr(UBYTE *text, LONG ch);
extern LONG SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(UBYTE *text);
extern UBYTE *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(UBYTE *newValue, UBYTE *oldValue);

LONG NEWGRID_AddShowtimeBucketEntry(UBYTE *entryText, LONG bucketGroup, LONG unused)
{
    const LONG ASCII_COLON = 58;
    const LONG GROUP_SHIFT = 8;
    const LONG BUCKET_MAX = 10;
    const LONG RESULT_FAIL = 0;
    const LONG RESULT_OK = 1;
    const LONG INDEX_ZERO = 0;
    LONG key;
    LONG insertPos;
    LONG shiftIdx;
    LONG inserted = 0;
    UBYTE *cursor;
    NEWGRID_ShowtimeBucketEntry *entry;

    (void)unused;

    cursor = PARSEINI_JMPTBL_STR_FindCharPtr(entryText, ASCII_COLON);
    cursor = cursor + 1;
    key = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(cursor);
    key += (bucketGroup << GROUP_SHIFT);

    if (NEWGRID_ShowtimeBucketCount >= BUCKET_MAX) {
        return RESULT_FAIL;
    }

    entry = &NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount];
    entry->key = key;
    entry->text = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(entryText, entry->text);

    insertPos = NEWGRID_ShowtimeBucketCount;
    while (insertPos > INDEX_ZERO) {
        if (NEWGRID_ShowtimeBucketPtrTable[insertPos]->key <= key) {
            break;
        }
        --insertPos;
    }

    if (insertPos != INDEX_ZERO && NEWGRID_ShowtimeBucketPtrTable[insertPos]->key == key) {
        return RESULT_FAIL;
    }

    shiftIdx = NEWGRID_ShowtimeBucketCount;
    while (shiftIdx > insertPos) {
        NEWGRID_ShowtimeBucketPtrTable[shiftIdx] = NEWGRID_ShowtimeBucketPtrTable[shiftIdx - 1];
        --shiftIdx;
    }

    NEWGRID_ShowtimeBucketPtrTable[insertPos] = &NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount];
    ++NEWGRID_ShowtimeBucketCount;
    inserted = RESULT_OK;
    return inserted;
}
