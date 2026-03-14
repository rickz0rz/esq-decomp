#include <exec/types.h>
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

extern void DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(char *rastPort, char *entryPtr0, char *entryPtr1, UWORD row, UWORD mode, LONG enabled, LONG bevel);
extern void DISPTEXT_SetCurrentLineIndex(LONG idx);
extern void NEWGRID_BuildShowtimesText(char *gridCtx, char *entryState, char *out);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *text);
extern LONG NEWGRID_DrawGridFrameVariant3(char *gridCtx);
extern LONG DISPTEXT_ComputeVisibleLineCount(LONG mode);

LONG NEWGRID_HandleShowtimesState(char *gridCtx, const void *entryState)
{
    NEWGRID_Context *ctxView;
    const NEWGRID_ShowtimesEntryState *stateView;
    char text[130];
    LONG row;
    LONG nextState;

    if (gridCtx == 0) {
        NEWGRID_ShowtimesWorkflowStateLatch = 4;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    ctxView = (NEWGRID_Context *)gridCtx;
    stateView = (const NEWGRID_ShowtimesEntryState *)entryState;
    if (NEWGRID_ShowtimesWorkflowStateLatch == 4) {
        if (stateView->entryPtr == 0 || stateView->auxPtr == 0) {
            return NEWGRID_ShowtimesWorkflowStateLatch;
        }

        DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_PpvShowtimesLayoutPen);

        row = (LONG)stateView->rowIndex;
        if (row > 48) {
            row -= 48;
        }

        if (GCOMMAND_PpvDetailLayoutFlag == (UBYTE)78) {
            NEWGRID_DrawGridEntry(ctxView->rastPort, stateView->entryPtr, stateView->auxPtr, (UWORD)row, 2, 1, -1);
        } else {
            NEWGRID_DrawGridEntry(ctxView->rastPort, stateView->entryPtr, stateView->auxPtr, (UWORD)row, 3, 1, -1);
        }

        DISPTEXT_SetCurrentLineIndex(GCOMMAND_PpvShowtimesInitialLineIndex);
        NEWGRID_BuildShowtimesText(gridCtx, (char *)entryState, text);
        DISPTEXT_LayoutAndAppendToBuffer(ctxView->rastPort, text);

        if (NEWGRID_DrawGridFrameVariant3(gridCtx) != 0) {
            NEWGRID_ShowtimesWorkflowStateLatch = 4;
        } else {
            NEWGRID_ShowtimesWorkflowStateLatch = 5;
        }

        ctxView->selectedState = DISPTEXT_ComputeVisibleLineCount(2);
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
