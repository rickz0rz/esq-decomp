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

void TEXTDISP_ResetSelectionState(TEXTDISP_SelectionEntry *state)
{
    if (state == (TEXTDISP_SelectionEntry *)0) {
        return;
    }

    state->mode = 3;
    state->groupIndex = -1;
    state->selectionIndex = -1;
    state->detailLine[0] = 0;
}
