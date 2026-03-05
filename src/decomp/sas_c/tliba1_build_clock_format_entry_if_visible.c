typedef signed long LONG;
typedef signed short WORD;

extern WORD TEXTDISP_ActiveGroupId;
extern LONG CONFIG_TimeWindowMinutes;

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(void *entry, LONG modeIndex, LONG fieldId);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void *entry, void *aux, LONG modeIndex, LONG dayMinutes, LONG windowMinutes);
extern void TLIBA1_FormatClockFormatEntry(char *dst, void *f0, void *f1, void *f2, void *f3, void *f4, LONG style);

WORD TLIBA1_BuildClockFormatEntryIfVisible(WORD groupIndex, WORD modeIndex, char *outText, WORD style)
{
    LONG displayMode;
    void *entry;
    void *aux;
    void *f0;
    void *f1;
    void *f2;
    void *f3;
    void *f4;
    LONG visible;

    displayMode = (TEXTDISP_ActiveGroupId == 1) ? 1 : 2;
    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)groupIndex, displayMode);
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode((LONG)groupIndex, displayMode);

    f0 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, 5);
    f1 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, 3);
    f2 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, 2);
    f3 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, 4);
    f4 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, 1);

    visible = 1;
    if (modeIndex != -1) {
        visible = TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(entry, aux, (LONG)modeIndex, 1440, CONFIG_TimeWindowMinutes);
    }

    if ((modeIndex == -1 || visible != 0) && (f0 != (void *)0 || f1 != (void *)0 || f2 != (void *)0 || f3 != (void *)0 || f4 != (void *)0)) {
        if (outText != (char *)0) {
            TLIBA1_FormatClockFormatEntry(outText, f0, f1, f2, f3, f4, (LONG)style);
        }
        return 1;
    }

    if (outText != (char *)0) {
        outText[0] = 0;
    }
    return 0;
}
