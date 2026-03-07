typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *NEWGRID_ShowtimeBucketPtrTable[];
extern UBYTE NEWGRID_ShowtimeBucketEntryTable[];

void NEWGRID_InitShowtimeBuckets(void)
{
    LONG i;

    for (i = 0; i < 10; ++i) {
        NEWGRID_ShowtimeBucketPtrTable[i] = NEWGRID_ShowtimeBucketEntryTable + (i << 3);
        *(LONG *)(NEWGRID_ShowtimeBucketEntryTable + (i << 3) + 4) = 0;
    }
}
