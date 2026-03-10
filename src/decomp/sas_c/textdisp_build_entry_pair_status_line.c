typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG CONFIG_TimeWindowMinutes;
extern const char SCRIPT_AlignedPrefixEmptyD[];
extern const char SCRIPT_AlignedPrefixEmptyE[];
extern const char SCRIPT_SpacerTripleC[];

extern char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(char *entry, char *aux, LONG index, LONG window, LONG minutes);
extern const char *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(char *entry, LONG index, LONG fieldId);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern void TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(char *line, LONG mode, LONG groupIndex, LONG entryIndex, LONG a, LONG b);
extern void SCRIPT_SetupHighlightEffect(char *line);

void TEXTDISP_BuildEntryPairStatusLine(UWORD modeFlag, UWORD groupIndex, UWORD entryIndex)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG WINDOW_HALF_HOUR = 30;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_LAST = 48;
    const UWORD SLOT_INVALID = (UWORD)-1;
    const LONG FIELD_PART_A = 2;
    const LONG FIELD_PART_B = 3;
    const LONG ZERO = 0;
    const UBYTE CH_NUL = 0;
    char *aux;
    char *entry;
    LONG idx;
    const char *partA;
    const char *partB;
    char line[137];

    idx = (LONG)groupIndex;
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, modeFlag ? MODE_PRIMARY : MODE_SECONDARY);
    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, modeFlag ? MODE_PRIMARY : MODE_SECONDARY);

    if (entry == (char *)0 || aux == (char *)0) {
        return;
    }

    if (TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(
            entry, aux, (LONG)entryIndex, WINDOW_HALF_HOUR, CONFIG_TimeWindowMinutes) == 0) {
        return;
    }

    if (entryIndex < SLOT_FIRST || entryIndex > SLOT_LAST) {
        entryIndex = SLOT_INVALID;
    }

    partA = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)entryIndex, FIELD_PART_A);
    partB = TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(entry, (LONG)entryIndex, FIELD_PART_B);

    line[0] = CH_NUL;
    if (partA != (const char *)0) {
        STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyD);
        STRING_AppendAtNull(line, partA);
    }

    if (partB != (const char *)0) {
        if (line[0] != CH_NUL) {
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
        ZERO,
        ZERO
    );

    if (line[0] != CH_NUL) {
        SCRIPT_SetupHighlightEffect(line);
    }
}
