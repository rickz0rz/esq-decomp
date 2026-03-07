typedef signed long LONG;
typedef signed short WORD;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_ApplySourceConfigToEntry(void *entry);

void TEXTDISP_ApplySourceConfigAllEntries(void)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    LONG i;

    for (i = 0; i < (LONG)TEXTDISP_PrimaryGroupEntryCount; ++i) {
        void *entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
        TEXTDISP_ApplySourceConfigToEntry(entry);
    }

    for (i = 0; i < (LONG)TEXTDISP_SecondaryGroupEntryCount; ++i) {
        void *entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        TEXTDISP_ApplySourceConfigToEntry(entry);
    }
}
