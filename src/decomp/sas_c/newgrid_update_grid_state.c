typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_GridStateFrameLatch;
extern LONG NEWGRID_SelectedGridEntryPtr;
extern LONG NEWGRID_OverridePenIndex;

extern LONG NEWGRID_UpdatePresetEntry(UBYTE **entryOut, UBYTE **auxOut, WORD rowIndex, LONG keyIndex);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitset, LONG bitIndex);
extern WORD NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(UBYTE *entry, UBYTE *aux, LONG rowIndex);
extern LONG NEWGRID_SelectEntryPen(UBYTE *entry);
extern void NEWGRID_DrawEntryFlagBadge(void *rastPort, UBYTE *entry, WORD rowIndex, LONG fallbackText, LONG layoutMode);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG unused);
extern LONG NEWGRID_DrawGridFrameAndRows(UBYTE *grid, LONG selectedEntryState);

void NEWGRID_UpdateGridState(UBYTE *grid, LONG keyIndex, WORD rowIndex)
{
    const LONG GRID_NULL = 0;
    const LONG GRIDSTATE_READY = 4;
    const LONG GRIDSTATE_LATCHED = 5;
    const LONG SELECTED_NONE = -1;
    const LONG ENTRY_BITSET_OFFSET = 28;
    const LONG ROWAUX_FLAGS_OFFSET = 7;
    const LONG ROWAUX_TITLE_TABLE_OFFSET = 56;
    const LONG ROWAUX_TITLE_PTR_SHIFT = 2;
    const LONG GRID_SELECTED_STATE_OFFSET = 32;
    const LONG GRID_RASTPORT_OFFSET = 60;
    const LONG PEN_OVERRIDE_FLAGGED = 5;
    const UBYTE ROW_FLAG_BADGE = 0x04;
    UBYTE *entry;
    UBYTE *aux;
    UBYTE *rowAux;
    LONG frameState;
    LONG pen;

    if (grid == (UBYTE *)GRID_NULL) {
        NEWGRID_GridStateFrameLatch = GRIDSTATE_READY;
        return;
    }

    frameState = NEWGRID_GridStateFrameLatch;
    if (frameState == GRIDSTATE_LATCHED) {
        *(LONG *)(grid + GRID_SELECTED_STATE_OFFSET) = SELECTED_NONE;
    } else if (frameState == GRIDSTATE_READY) {
        rowIndex = (WORD)NEWGRID_UpdatePresetEntry(&entry, &aux, rowIndex, keyIndex);

        if (entry != 0 && aux != 0) {
            if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry + ENTRY_BITSET_OFFSET, (LONG)rowIndex) == SELECTED_NONE) {
                rowIndex = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, (LONG)rowIndex);
                pen = NEWGRID_SelectEntryPen(entry);
                rowAux = aux + rowIndex;
                NEWGRID_SelectedGridEntryPtr = pen;
                if ((rowAux[ROWAUX_FLAGS_OFFSET] & ROW_FLAG_BADGE) != 0) {
                    NEWGRID_SelectedGridEntryPtr = PEN_OVERRIDE_FLAGGED;
                }

                NEWGRID_DrawEntryFlagBadge(
                    grid + GRID_RASTPORT_OFFSET,
                    entry,
                    rowIndex,
                    *(LONG *)(aux + ROWAUX_TITLE_TABLE_OFFSET + ((LONG)rowIndex << ROWAUX_TITLE_PTR_SHIFT)),
                    NEWGRID_OverridePenIndex
                );

                *(LONG *)(grid + GRID_SELECTED_STATE_OFFSET) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0);
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
