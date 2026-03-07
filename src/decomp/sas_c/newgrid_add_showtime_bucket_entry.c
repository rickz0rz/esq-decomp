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
    LONG key;
    LONG insertPos;
    LONG shiftIdx;
    LONG inserted = 0;
    UBYTE *cursor;
    NEWGRID_ShowtimeBucketEntry *entry;

    (void)unused;

    cursor = PARSEINI_JMPTBL_STR_FindCharPtr(entryText, 58);
    cursor = cursor + 1;
    key = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(cursor);
    key += (bucketGroup << 8);

    if (NEWGRID_ShowtimeBucketCount >= 10) {
        return 0;
    }

    entry = &NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount];
    entry->key = key;
    entry->text = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(entryText, entry->text);

    insertPos = NEWGRID_ShowtimeBucketCount;
    while (insertPos > 0) {
        if (NEWGRID_ShowtimeBucketPtrTable[insertPos]->key <= key) {
            break;
        }
        --insertPos;
    }

    if (insertPos != 0 && NEWGRID_ShowtimeBucketPtrTable[insertPos]->key == key) {
        return 0;
    }

    shiftIdx = NEWGRID_ShowtimeBucketCount;
    while (shiftIdx > insertPos) {
        NEWGRID_ShowtimeBucketPtrTable[shiftIdx] = NEWGRID_ShowtimeBucketPtrTable[shiftIdx - 1];
        --shiftIdx;
    }

    NEWGRID_ShowtimeBucketPtrTable[insertPos] = &NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount];
    ++NEWGRID_ShowtimeBucketCount;
    inserted = 1;
    return inserted;
}
