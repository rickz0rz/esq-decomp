typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG CONFIG_TimeWindowMinutes;
extern const char SCRIPT_AlignedPrefixEmptyD[];
extern const char SCRIPT_AlignedPrefixEmptyE[];
extern const char SCRIPT_SpacerTripleC[];

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void *entry, void *aux, LONG index, LONG window, LONG minutes);
extern const char *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(void *entry, LONG index, LONG fieldId);
extern void STRING_AppendAtNull(char *dst, const char *src);
extern void TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(char *line, LONG mode, LONG groupIndex, LONG entryIndex, LONG a, LONG b);
extern void SCRIPT_SetupHighlightEffect(char *line);

void TEXTDISP_BuildEntryPairStatusLine(UWORD modeFlag, UWORD groupIndex, UWORD entryIndex)
{
    void *aux;
    void *entry;
    LONG idx;
    const char *partA;
    const char *partB;
    char line[137];

    idx = (LONG)groupIndex;
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, modeFlag ? 1 : 2);
    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, modeFlag ? 1 : 2);

    if (entry == (void *)0 || aux == (void *)0) {
        return;
    }

    if (TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(entry, aux, (LONG)entryIndex, 30, CONFIG_TimeWindowMinutes) == 0) {
        return;
    }

    if (entryIndex < 1 || entryIndex > 48) {
        entryIndex = (UWORD)-1;
    }

    partA = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)entryIndex, 2);
    partB = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)entryIndex, 3);

    line[0] = 0;
    if (partA != (const char *)0) {
        STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyD);
        STRING_AppendAtNull(line, partA);
    }

    if (partB != (const char *)0) {
        if (line[0] != 0) {
            STRING_AppendAtNull(line, SCRIPT_SpacerTripleC);
        }
        STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyE);
        STRING_AppendAtNull(line, partB);
    }

    TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(
        line,
        (LONG)modeFlag,
        (LONG)groupIndex,
        (LONG)entryIndex,
        0,
        0
    );

    if (line[0] != 0) {
        SCRIPT_SetupHighlightEffect(line);
    }
}
