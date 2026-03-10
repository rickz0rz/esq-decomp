typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
    UBYTE pad1[0x38 - 0x38];
    char *titleTable[49];
} NEWGRID_AuxData;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern LONG NEWGRID_GridStateFrameLatch;
extern LONG NEWGRID_SelectedGridEntryPtr;
extern LONG NEWGRID_OverridePenIndex;

extern LONG NEWGRID_UpdatePresetEntry(char **entryOut, char **auxOut, WORD rowIndex, LONG keyIndex);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(const UBYTE *bitset, LONG bitIndex);
extern WORD NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(char *entry, char *aux, LONG rowIndex);
extern LONG NEWGRID_SelectEntryPen(char *entry);
extern void NEWGRID_DrawEntryFlagBadge(char *rastPort, char *entry, WORD rowIndex, LONG fallbackText, LONG layoutMode);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG unused);
extern LONG NEWGRID_DrawGridFrameAndRows(char *grid, LONG selectedEntryState);

void NEWGRID_UpdateGridState(char *grid, LONG keyIndex, WORD rowIndex)
{
    const LONG GRID_NULL = 0;
    const LONG GRIDSTATE_READY = 4;
    const LONG GRIDSTATE_LATCHED = 5;
    const LONG SELECTED_NONE = -1;
    const LONG PEN_OVERRIDE_FLAGGED = 5;
    const UBYTE ROW_FLAG_BADGE = 0x04;
    NEWGRID_Context *gridView;
    NEWGRID_Entry *entry;
    NEWGRID_AuxData *aux;
    LONG frameState;
    LONG pen;

    gridView = (NEWGRID_Context *)grid;
    if (grid == (char *)GRID_NULL) {
        NEWGRID_GridStateFrameLatch = GRIDSTATE_READY;
        return;
    }

    frameState = NEWGRID_GridStateFrameLatch;
    if (frameState == GRIDSTATE_LATCHED) {
        gridView->selectedState = SELECTED_NONE;
    } else if (frameState == GRIDSTATE_READY) {
        rowIndex = (WORD)NEWGRID_UpdatePresetEntry((char **)&entry, (char **)&aux, rowIndex, keyIndex);

        if (entry != 0 && aux != 0) {
            if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry->selectionBits, (LONG)rowIndex) == SELECTED_NONE) {
                rowIndex = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex((char *)entry, (char *)aux, (LONG)rowIndex);
                pen = NEWGRID_SelectEntryPen((char *)entry);
                NEWGRID_SelectedGridEntryPtr = pen;
                if ((aux->rowFlags[rowIndex] & ROW_FLAG_BADGE) != 0) {
                    NEWGRID_SelectedGridEntryPtr = PEN_OVERRIDE_FLAGGED;
                }

                NEWGRID_DrawEntryFlagBadge(
                    gridView->rastPort,
                    (char *)entry,
                    rowIndex,
                    (LONG)aux->titleTable[rowIndex],
                    NEWGRID_OverridePenIndex
                );

                gridView->selectedState = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0);
            }
        }
    } else {
        NEWGRID_GridStateFrameLatch = GRIDSTATE_READY;
    }

    if (NEWGRID_DrawGridFrameAndRows(grid, NEWGRID_SelectedGridEntryPtr) == 0) {
        NEWGRID_GridStateFrameLatch = GRIDSTATE_LATCHED;
    } else {
        NEWGRID_GridStateFrameLatch = GRIDSTATE_READY;
    }
}
