typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ShowtimeBucketEntry {
    LONG key;
    UBYTE *text;
} NEWGRID_ShowtimeBucketEntry;

extern LONG NEWGRID_ShowtimeBucketCount;
extern NEWGRID_ShowtimeBucketEntry NEWGRID_ShowtimeBucketEntryTable[];

extern UBYTE *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(UBYTE *newStr, UBYTE *oldStr);

void NEWGRID_ResetShowtimeBuckets(void)
{
    LONG i;

    NEWGRID_ShowtimeBucketCount = 0;

    for (i = 0; i < 10; ++i) {
        NEWGRID_ShowtimeBucketEntryTable[i].key = 0x3100;
        NEWGRID_ShowtimeBucketEntryTable[i].text =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(0, NEWGRID_ShowtimeBucketEntryTable[i].text);
    }
}
