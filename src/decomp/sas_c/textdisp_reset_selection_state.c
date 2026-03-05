typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_State {
    UBYTE pad0[210];
    LONG selectionMode;
    LONG selectedIndex;
    WORD selectedSubIndex;
    UBYTE selectedFlags;
} TEXTDISP_State;

void TEXTDISP_ResetSelectionState(TEXTDISP_State *state)
{
    if (state == (TEXTDISP_State *)0) {
        return;
    }

    state->selectionMode = 3;
    state->selectedIndex = -1;
    state->selectedSubIndex = -1;
    state->selectedFlags = 0;
}
