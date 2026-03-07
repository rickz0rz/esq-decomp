typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_DetailGridStateLatch;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern UBYTE GCOMMAND_MplexDetailLayoutFlag;
extern LONG GCOMMAND_MplexDetailInitialLineIndex;
extern UBYTE NEWGRID_ChannelRowFmt[];

extern WORD NEWGRID_UpdatePresetEntry(UBYTE **entryOut, UBYTE **auxOut, WORD rowIndex, LONG keyIndex);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams();
extern void NEWGRID_DrawGridEntry();
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex();
extern void PARSEINI_JMPTBL_WDISP_SPrintf();
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer();
extern LONG NEWGRID_DrawGridFrameVariant2(UBYTE *ctx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount();

LONG NEWGRID_HandleDetailGridState(UBYTE *ctx, LONG keyIndex, WORD rowIndex)
{
    UBYTE *entry;
    UBYTE *aux;
    LONG nextState;
    UBYTE channelRow[58];

    entry = 0;
    aux = 0;

    if (ctx == 0) {
        NEWGRID_DetailGridStateLatch = 4;
        return NEWGRID_DetailGridStateLatch;
    }

    if (NEWGRID_DetailGridStateLatch == 4) {
        rowIndex = NEWGRID_UpdatePresetEntry(&entry, &aux, rowIndex, keyIndex);
        if (entry == 0 || aux == 0) {
            return NEWGRID_DetailGridStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_MplexDetailLayoutPen);

        if (GCOMMAND_MplexDetailLayoutFlag == (UBYTE)'N') {
            NEWGRID_DrawGridEntry(ctx + 60, entry, aux, (LONG)rowIndex, 2, 1, 4);
        } else {
            NEWGRID_DrawGridEntry(ctx + 60, entry, aux, (LONG)rowIndex, 3, 1, 4);
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(GCOMMAND_MplexDetailInitialLineIndex);
        PARSEINI_JMPTBL_WDISP_SPrintf(channelRow, NEWGRID_ChannelRowFmt, entry + 19, entry + 1);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(ctx + 60, channelRow);

        if (NEWGRID_DrawGridFrameVariant2(ctx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }

        NEWGRID_DetailGridStateLatch = nextState;
        *(LONG *)(ctx + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        return NEWGRID_DetailGridStateLatch;
    }

    if (NEWGRID_DetailGridStateLatch == 5) {
        if (NEWGRID_DrawGridFrameVariant2(ctx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }
        NEWGRID_DetailGridStateLatch = nextState;
        *(LONG *)(ctx + 32) = -1;
        return NEWGRID_DetailGridStateLatch;
    }

    NEWGRID_DetailGridStateLatch = 4;
    return NEWGRID_DetailGridStateLatch;
}
