#include <exec/types.h>
typedef struct NEWGRID_ShowtimeBucketEntry {
    LONG key;
    char *text;
} NEWGRID_ShowtimeBucketEntry;

extern LONG NEWGRID_ShowtimeBucketCount;
extern NEWGRID_ShowtimeBucketEntry *NEWGRID_ShowtimeBucketPtrTable[];
extern const char NEWGRID_ShowtimeBucketSeparator[];

extern char *STRING_AppendAtNull(char *dst, const char *src);

void NEWGRID_AppendShowtimeBuckets(char *outText)
{
    LONG i;

    STRING_AppendAtNull(outText, NEWGRID_ShowtimeBucketPtrTable[0]->text);
    i = 1;
    while (i < NEWGRID_ShowtimeBucketCount) {
        STRING_AppendAtNull(outText, NEWGRID_ShowtimeBucketSeparator);
        STRING_AppendAtNull(outText, NEWGRID_ShowtimeBucketPtrTable[i]->text);
        ++i;
    }
}
