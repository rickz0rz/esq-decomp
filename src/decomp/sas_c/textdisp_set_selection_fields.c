typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_State {
    UBYTE pad0[210];
    LONG selectionMode;
    LONG displayIndex;
    WORD entryIndex;
    UBYTE flags;
} TEXTDISP_State;

extern LONG TEXTDISP_GetGroupEntryCount(LONG mode);
extern void TEXTDISP_ResetSelectionState(TEXTDISP_State *state);

void TEXTDISP_SetSelectionFields(TEXTDISP_State *state, LONG mode, LONG displayIndex, LONG entryIndex)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG MODE_INVALID = 3;
    const LONG INDEX_INVALID = -1;
    const LONG ENTRY_FIRST = 1;
    const LONG ENTRY_LIMIT = 49;
    const UBYTE FLAG_CLEAR = 0;
    LONG groupCount;
    LONG outMode;
    LONG outDisplay;
    LONG outEntry;

    if (state == (TEXTDISP_State *)0) {
        return;
    }

    if (mode == MODE_PRIMARY || mode == MODE_SECONDARY) {
        outMode = mode;
    } else {
        outMode = MODE_INVALID;
    }

    state->selectionMode = outMode;

    groupCount = TEXTDISP_GetGroupEntryCount(outMode);
    if (displayIndex < groupCount) {
        outDisplay = displayIndex;
    } else {
        outDisplay = INDEX_INVALID;
    }
    state->displayIndex = outDisplay;

    if (entryIndex > ENTRY_FIRST - 1 && entryIndex < ENTRY_LIMIT) {
        outEntry = entryIndex;
    } else {
        outEntry = INDEX_INVALID;
    }
    state->entryIndex = (WORD)outEntry;
    state->flags = FLAG_CLEAR;

    if (state->selectionMode == MODE_INVALID ||
        state->displayIndex == INDEX_INVALID ||
        state->entryIndex == INDEX_INVALID) {
        TEXTDISP_ResetSelectionState(state);
    }
}
