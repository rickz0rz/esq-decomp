typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ShowtimeBucketEntry {
    LONG key;
    char *text;
} NEWGRID_ShowtimeBucketEntry;

extern LONG NEWGRID_ShowtimeBucketCount;
extern NEWGRID_ShowtimeBucketEntry *NEWGRID_ShowtimeBucketPtrTable[];
extern UBYTE NEWGRID_ShowtimeBucketSeparator;

extern void PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

void NEWGRID_AppendShowtimeBuckets(char *outText)
{
    LONG i;

    PARSEINI_JMPTBL_STRING_AppendAtNull(outText, NEWGRID_ShowtimeBucketPtrTable[0]->text);
    i = 1;
    while (i < NEWGRID_ShowtimeBucketCount) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(outText, &NEWGRID_ShowtimeBucketSeparator);
        PARSEINI_JMPTBL_STRING_AppendAtNull(outText, NEWGRID_ShowtimeBucketPtrTable[i]->text);
        ++i;
    }
}
