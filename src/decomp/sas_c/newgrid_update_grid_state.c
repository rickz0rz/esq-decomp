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
    UBYTE *entry;
    UBYTE *aux;
    UBYTE *rowAux;
    LONG frameState;
    LONG pen;

    if (grid == 0) {
        NEWGRID_GridStateFrameLatch = 4;
        return;
    }

    frameState = NEWGRID_GridStateFrameLatch;
    if (frameState == 5) {
        *(LONG *)(grid + 32) = -1;
    } else if (frameState == 4) {
        rowIndex = (WORD)NEWGRID_UpdatePresetEntry(&entry, &aux, rowIndex, keyIndex);

        if (entry != 0 && aux != 0) {
            if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry + 28, (LONG)rowIndex) == -1) {
                rowIndex = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, (LONG)rowIndex);
                pen = NEWGRID_SelectEntryPen(entry);
                rowAux = aux + rowIndex;
                NEWGRID_SelectedGridEntryPtr = pen;
                if ((rowAux[7] & (UBYTE)0x04) != 0) {
                    NEWGRID_SelectedGridEntryPtr = 5;
                }

                NEWGRID_DrawEntryFlagBadge(
                    grid + 60,
                    entry,
                    rowIndex,
                    *(LONG *)(aux + 56 + ((LONG)rowIndex << 2)),
                    NEWGRID_OverridePenIndex
                );

                *(LONG *)(grid + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0);
            }
        }
    } else {
        NEWGRID_GridStateFrameLatch = 4;
    }

    if (NEWGRID_DrawGridFrameAndRows(grid, NEWGRID_SelectedGridEntryPtr) == 0) {
        NEWGRID_GridStateFrameLatch = 5;
    } else {
        NEWGRID_GridStateFrameLatch = 4;
    }
}
