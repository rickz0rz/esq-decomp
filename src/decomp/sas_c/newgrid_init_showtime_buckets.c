typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ShowtimeBucketEntry {
    LONG key;
    UBYTE *text;
} NEWGRID_ShowtimeBucketEntry;

extern NEWGRID_ShowtimeBucketEntry *NEWGRID_ShowtimeBucketPtrTable[];
extern NEWGRID_ShowtimeBucketEntry NEWGRID_ShowtimeBucketEntryTable[];

void NEWGRID_InitShowtimeBuckets(void)
{
    LONG i;

    for (i = 0; i < 10; ++i) {
        NEWGRID_ShowtimeBucketPtrTable[i] = &NEWGRID_ShowtimeBucketEntryTable[i];
        NEWGRID_ShowtimeBucketEntryTable[i].text = 0;
    }
}
