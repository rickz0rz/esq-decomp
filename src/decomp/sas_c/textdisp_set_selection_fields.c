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
    LONG groupCount;
    LONG outMode;
    LONG outDisplay;
    LONG outEntry;

    if (state == (TEXTDISP_State *)0) {
        return;
    }

    if (mode == 1 || mode == 2) {
        outMode = mode;
    } else {
        outMode = 3;
    }

    state->selectionMode = outMode;

    groupCount = TEXTDISP_GetGroupEntryCount(outMode);
    if (displayIndex < groupCount) {
        outDisplay = displayIndex;
    } else {
        outDisplay = -1;
    }
    state->displayIndex = outDisplay;

    if (entryIndex > 0 && entryIndex < 49) {
        outEntry = entryIndex;
    } else {
        outEntry = -1;
    }
    state->entryIndex = (WORD)outEntry;
    state->flags = 0;

    if (state->selectionMode == 3 || state->displayIndex == -1 || state->entryIndex == -1) {
        TEXTDISP_ResetSelectionState(state);
    }
}
