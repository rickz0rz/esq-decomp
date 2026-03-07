typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_ShowtimesWorkflowStateLatch;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesInitialLineIndex;
extern UBYTE GCOMMAND_PpvDetailLayoutFlag;

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(void *rastPort, void *entryPtr0, void *entryPtr1, LONG row, LONG mode, LONG enabled, LONG bevel);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG idx);
extern void NEWGRID_BuildShowtimesText(void *gridCtx, void *entryState, UBYTE *out);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *rastPort, UBYTE *text);
extern LONG NEWGRID_DrawGridFrameVariant3(void *gridCtx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);

LONG NEWGRID_HandleShowtimesState(UBYTE *gridCtx, UBYTE *entryState)
{
    UBYTE text[130];
    LONG row;
    LONG nextState;

    if (gridCtx == 0) {
        NEWGRID_ShowtimesWorkflowStateLatch = 4;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    if (NEWGRID_ShowtimesWorkflowStateLatch == 4) {
        if (*(LONG *)(entryState + 0) == 0 || *(LONG *)(entryState + 4) == 0) {
            return NEWGRID_ShowtimesWorkflowStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_PpvShowtimesLayoutPen);

        row = (LONG)(*(WORD *)(entryState + 20));
        if (row > 48) {
            row -= 48;
        }

        if (GCOMMAND_PpvDetailLayoutFlag == (UBYTE)78) {
            NEWGRID_DrawGridEntry((UBYTE *)gridCtx + 60, *(void **)(entryState + 0), *(void **)(entryState + 4), row, 2, 1, -1);
        } else {
            NEWGRID_DrawGridEntry((UBYTE *)gridCtx + 60, *(void **)(entryState + 0), *(void **)(entryState + 4), row, 3, 1, -1);
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(GCOMMAND_PpvShowtimesInitialLineIndex);
        NEWGRID_BuildShowtimesText(gridCtx, entryState, text);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer((UBYTE *)gridCtx + 60, text);

        if (NEWGRID_DrawGridFrameVariant3(gridCtx) != 0) {
            NEWGRID_ShowtimesWorkflowStateLatch = 4;
        } else {
            NEWGRID_ShowtimesWorkflowStateLatch = 5;
        }

        *(LONG *)(gridCtx + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    if (NEWGRID_ShowtimesWorkflowStateLatch == 5) {
        if (NEWGRID_DrawGridFrameVariant3(gridCtx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }
        *(LONG *)(gridCtx + 32) = -1;
        NEWGRID_ShowtimesWorkflowStateLatch = nextState;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    NEWGRID_ShowtimesWorkflowStateLatch = 4;
    return NEWGRID_ShowtimesWorkflowStateLatch;
}
