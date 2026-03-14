#include <exec/types.h>
typedef struct ESQIFF2_Entry {
    UBYTE pad0[34];
    UBYTE flags34To39[6];
} ESQIFF2_Entry;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern ESQIFF2_Entry *TEXTDISP_PrimaryEntryPtrTable[];

void ESQIFF2_ClearPrimaryEntryFlags34To39(void)
{
    UWORD d7 = 0;

    while (d7 < TEXTDISP_PrimaryGroupEntryCount) {
        ESQIFF2_Entry *entry = TEXTDISP_PrimaryEntryPtrTable[d7];
        UWORD d6 = 0;

        while (d6 < 6) {
            entry->flags34To39[d6] = 0;
            ++d6;
        }

        ++d7;
    }
}
