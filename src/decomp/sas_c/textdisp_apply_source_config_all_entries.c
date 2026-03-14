#include <exec/types.h>
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

extern const char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_ApplySourceConfigToEntry(char *entry);

void TEXTDISP_ApplySourceConfigAllEntries(void)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    LONG i;

    for (i = 0; i < (LONG)TEXTDISP_PrimaryGroupEntryCount; ++i) {
        const char *entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
        TEXTDISP_ApplySourceConfigToEntry((char *)entry);
    }

    for (i = 0; i < (LONG)TEXTDISP_SecondaryGroupEntryCount; ++i) {
        const char *entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        TEXTDISP_ApplySourceConfigToEntry((char *)entry);
    }
}
