typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG NEWGRID_GridEditorWorkflowState;

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *rastPort, UBYTE *text);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);
extern LONG NEWGRID_DrawGridFrameAndRows(void *gridCtx, LONG rowPen);

LONG NEWGRID_HandleGridEditorState(void *gridCtx, LONG layoutPen, LONG rowPen, UBYTE *sourceText)
{
    if (gridCtx == 0) {
        NEWGRID_GridEditorWorkflowState = 4;
        return NEWGRID_GridEditorWorkflowState;
    }

    if (NEWGRID_GridEditorWorkflowState == 4) {
        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, layoutPen);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer((UBYTE *)gridCtx + 60, sourceText);
        *(LONG *)((UBYTE *)gridCtx + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0);

        if (NEWGRID_DrawGridFrameAndRows(gridCtx, rowPen) != 0) {
            NEWGRID_GridEditorWorkflowState = 4;
        } else {
            NEWGRID_GridEditorWorkflowState = 5;
        }
        return NEWGRID_GridEditorWorkflowState;
    }

    if (NEWGRID_GridEditorWorkflowState == 5) {
        *(LONG *)((UBYTE *)gridCtx + 32) = -1;
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
