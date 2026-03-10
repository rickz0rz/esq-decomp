typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID_Context;

typedef struct NEWGRID_ShowtimesEntryState {
    char *entryPtr;
    char *auxPtr;
    UBYTE pad0[12];
    WORD rowIndex;
} NEWGRID_ShowtimesEntryState;

extern LONG NEWGRID_ShowtimesWorkflowStateLatch;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesInitialLineIndex;
extern UBYTE GCOMMAND_PpvDetailLayoutFlag;

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(char *rastPort, char *entryPtr0, char *entryPtr1, LONG row, LONG mode, LONG enabled, LONG bevel);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG idx);
extern void NEWGRID_BuildShowtimesText(char *gridCtx, char *entryState, char *out);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *text);
extern LONG NEWGRID_DrawGridFrameVariant3(char *gridCtx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);

LONG NEWGRID_HandleShowtimesState(char *gridCtx, char *entryState)
{
    NEWGRID_Context *ctxView;
    NEWGRID_ShowtimesEntryState *stateView;
    char text[130];
    LONG row;
    LONG nextState;

    if (gridCtx == 0) {
        NEWGRID_ShowtimesWorkflowStateLatch = 4;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    ctxView = (NEWGRID_Context *)gridCtx;
    stateView = (NEWGRID_ShowtimesEntryState *)entryState;
    if (NEWGRID_ShowtimesWorkflowStateLatch == 4) {
        if (stateView->entryPtr == 0 || stateView->auxPtr == 0) {
            return NEWGRID_ShowtimesWorkflowStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_PpvShowtimesLayoutPen);

        row = (LONG)stateView->rowIndex;
        if (row > 48) {
            row -= 48;
        }

        if (GCOMMAND_PpvDetailLayoutFlag == (UBYTE)78) {
            NEWGRID_DrawGridEntry(ctxView->rastPort, stateView->entryPtr, stateView->auxPtr, row, 2, 1, -1);
        } else {
            NEWGRID_DrawGridEntry(ctxView->rastPort, stateView->entryPtr, stateView->auxPtr, row, 3, 1, -1);
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(GCOMMAND_PpvShowtimesInitialLineIndex);
        NEWGRID_BuildShowtimesText(gridCtx, entryState, text);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(ctxView->rastPort, text);

        if (NEWGRID_DrawGridFrameVariant3(gridCtx) != 0) {
            NEWGRID_ShowtimesWorkflowStateLatch = 4;
        } else {
            NEWGRID_ShowtimesWorkflowStateLatch = 5;
        }

        ctxView->selectedState = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    if (NEWGRID_ShowtimesWorkflowStateLatch == 5) {
        if (NEWGRID_DrawGridFrameVariant3(gridCtx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }
        ctxView->selectedState = -1;
        NEWGRID_ShowtimesWorkflowStateLatch = nextState;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    NEWGRID_ShowtimesWorkflowStateLatch = 4;
    return NEWGRID_ShowtimesWorkflowStateLatch;
}
