typedef signed long LONG;
typedef signed short WORD;

extern WORD TEXTDISP_ActiveGroupId;
extern LONG CONFIG_TimeWindowMinutes;

extern const char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern const char *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(const void *entry, LONG modeIndex, LONG fieldId);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(const void *entry, const void *aux, LONG modeIndex, LONG dayMinutes, LONG windowMinutes);
extern void TLIBA1_FormatClockFormatEntry(char *dst, const char *f0, const char *f1, const char *f2, const char *f3, const char *f4, LONG style);

WORD TLIBA1_BuildClockFormatEntryIfVisible(WORD groupIndex, WORD modeIndex, char *outText, WORD style)
{
    const LONG GROUP_PRIMARY = 1;
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG MODE_ANY = -1;
    const LONG FIELD_ID_0 = 5;
    const LONG FIELD_ID_1 = 3;
    const LONG FIELD_ID_2 = 2;
    const LONG FIELD_ID_3 = 4;
    const LONG FIELD_ID_4 = 1;
    const LONG DAY_MINUTES = 1440;
    const WORD FLAG_TRUE = 1;
    const WORD FLAG_FALSE = 0;
    const char CH_NUL = 0;
    LONG displayMode;
    const char *entry;
    const char *aux;
    const char *f0;
    const char *f1;
    const char *f2;
    const char *f3;
    const char *f4;
    LONG visible;

    displayMode = (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) ? MODE_PRIMARY : MODE_SECONDARY;
    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)groupIndex, displayMode);
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode((LONG)groupIndex, displayMode);

    f0 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, FIELD_ID_0);
    f1 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, FIELD_ID_1);
    f2 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, FIELD_ID_2);
    f3 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, FIELD_ID_3);
    f4 = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)modeIndex, FIELD_ID_4);

    visible = FLAG_TRUE;
    if (modeIndex != MODE_ANY) {
        visible = TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(
            entry, aux, (LONG)modeIndex, DAY_MINUTES, CONFIG_TimeWindowMinutes);
    }

    if ((modeIndex == MODE_ANY || visible != FLAG_FALSE) &&
        (f0 != (const char *)0 || f1 != (const char *)0 || f2 != (const char *)0 || f3 != (const char *)0 || f4 != (const char *)0)) {
        if (outText != (char *)0) {
            TLIBA1_FormatClockFormatEntry(outText, f0, f1, f2, f3, f4, (LONG)style);
        }
        return FLAG_TRUE;
    }

    if (outText != (char *)0) {
        outText[0] = CH_NUL;
    }
    return FLAG_FALSE;
}
