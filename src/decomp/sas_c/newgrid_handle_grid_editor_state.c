#include <exec/types.h>
typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern LONG NEWGRID_GridEditorWorkflowState;

extern void DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *text);
extern LONG DISPTEXT_ComputeVisibleLineCount(LONG mode);
extern LONG NEWGRID_DrawGridFrameAndRows(char *gridCtx, LONG rowPen);

LONG NEWGRID_HandleGridEditorState(char *gridCtx, LONG layoutPen, LONG rowPen, const char *sourceText)
{
    NEWGRID_Context *ctxView;

    if (gridCtx == 0) {
        NEWGRID_GridEditorWorkflowState = 4;
        return NEWGRID_GridEditorWorkflowState;
    }

    ctxView = (NEWGRID_Context *)gridCtx;

    if (NEWGRID_GridEditorWorkflowState == 4) {
        DISPTEXT_SetLayoutParams(612, 20, layoutPen);
        DISPTEXT_LayoutAndAppendToBuffer(ctxView->rastPort, sourceText);
        ctxView->selectedState = DISPTEXT_ComputeVisibleLineCount(0);

        if (NEWGRID_DrawGridFrameAndRows(gridCtx, rowPen) != 0) {
            NEWGRID_GridEditorWorkflowState = 4;
        } else {
            NEWGRID_GridEditorWorkflowState = 5;
        }
        return NEWGRID_GridEditorWorkflowState;
    }

    if (NEWGRID_GridEditorWorkflowState == 5) {
        ctxView->selectedState = -1;
        if (NEWGRID_DrawGridFrameAndRows(gridCtx, rowPen) != 0) {
            NEWGRID_GridEditorWorkflowState = 4;
        } else {
            NEWGRID_GridEditorWorkflowState = 5;
        }
        return NEWGRID_GridEditorWorkflowState;
    }

    NEWGRID_GridEditorWorkflowState = 4;
    return NEWGRID_GridEditorWorkflowState;
}
