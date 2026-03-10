typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_SelectionEntry {
    char shortName[10];
    char longName[200];
    LONG mode;
    LONG groupIndex;
    WORD selectionIndex;
    char detailLine[524];
} TEXTDISP_SelectionEntry;

extern LONG TEXTDISP_GetGroupEntryCount(LONG mode);
extern void TEXTDISP_ResetSelectionState(TEXTDISP_SelectionEntry *state);

void TEXTDISP_SetSelectionFields(TEXTDISP_SelectionEntry *state, LONG mode, LONG displayIndex, LONG entryIndex)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG MODE_INVALID = 3;
    const LONG INDEX_INVALID = -1;
    const LONG ENTRY_FIRST = 1;
    const LONG ENTRY_LIMIT = 49;
    LONG groupCount;
    LONG outMode;
    LONG outDisplay;
    LONG outEntry;

    if (state == 0) {
        return;
    }

    if (mode == MODE_PRIMARY || mode == MODE_SECONDARY) {
        outMode = mode;
    } else {
        outMode = MODE_INVALID;
    }

    state->mode = outMode;

    groupCount = TEXTDISP_GetGroupEntryCount(outMode);
    if (displayIndex < groupCount) {
        outDisplay = displayIndex;
    } else {
        outDisplay = INDEX_INVALID;
    }
    state->groupIndex = outDisplay;

    if (entryIndex > ENTRY_FIRST - 1 && entryIndex < ENTRY_LIMIT) {
        outEntry = entryIndex;
    } else {
        outEntry = INDEX_INVALID;
    }
    state->selectionIndex = (WORD)outEntry;
    state->detailLine[0] = 0;

    if (state->mode == MODE_INVALID ||
        state->groupIndex == INDEX_INVALID ||
        state->selectionIndex == INDEX_INVALID) {
        TEXTDISP_ResetSelectionState(state);
    }
}
