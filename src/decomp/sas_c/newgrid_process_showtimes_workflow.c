typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LayoutCtx LayoutCtx;

extern LONG NEWGRID_ShowtimesWorkflowState;
extern LONG NEWGRID_ShowtimesSelectionContextPtr;
extern LONG NEWGRID_ShowtimesWorkflowArgLong;
extern UWORD NEWGRID_ShowtimesWorkflowArgWord;
extern LONG NEWGRID_ShowtimesColumnAdjust;

extern UBYTE GCOMMAND_PpvShowtimesWorkflowMode;
extern UBYTE GCOMMAND_DigitalPpvEnabledFlag;
extern LONG GCOMMAND_PPVListingsTemplatePtr;
extern LONG GCOMMAND_PpvEditorRowPen;
extern LONG GCOMMAND_PpvEditorLayoutPen;

extern LONG NEWGRID_HandleGridEditorState(LayoutCtx *ctx, LONG a, LONG b, LONG c);
extern LONG NEWGRID_ShouldOpenEditor(void *entry);
extern LONG NEWGRID_UpdateGridState(LayoutCtx *ctx, LONG index, LONG row);
extern LONG NEWGRID_HandleShowtimesState(LayoutCtx *ctx, LONG *selCtxPtr);
extern LONG NEWGRID_InitSelectionWindow(LONG *selCtxPtr, LONG rowBase);
extern LONG NEWGRID_UpdateSelectionFromInput(LONG state, LONG *selCtxPtr);
extern LONG NEWGRID_DrawGridMessageAlt(LayoutCtx *ctx);
extern LONG NEWGRID_ValidateSelectionCode(LayoutCtx *ctx, LONG code);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(LayoutCtx *ctx);
extern LONG NEWGRID_ClearEntryMarkerBits(LONG row);

LONG NEWGRID_ProcessShowtimesWorkflow(LayoutCtx *ctx, UWORD rowBase)
{
    LONG steppedFrom34 = 0;

    if (!ctx) {
        if (NEWGRID_ShowtimesWorkflowState == 2) {
            NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleGridEditorState(ctx, 0, 0, 0);
        } else if (NEWGRID_ShowtimesWorkflowState == 5) {
            if (NEWGRID_ShouldOpenEditor((void *)NEWGRID_ShowtimesSelectionContextPtr) != 0) {
                NEWGRID_ShowtimesWorkflowState = NEWGRID_UpdateGridState(ctx, 0, 0);
            } else {
                NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleShowtimesState(ctx, (LONG *)&NEWGRID_ShowtimesSelectionContextPtr);
            }
        }
        NEWGRID_InitSelectionWindow((LONG *)&NEWGRID_ShowtimesSelectionContextPtr, 0);
        NEWGRID_ShowtimesWorkflowState = 0;
    } else if (NEWGRID_ShowtimesWorkflowState < 8) {
        switch (NEWGRID_ShowtimesWorkflowState) {
        case 0:
            NEWGRID_InitSelectionWindow((LONG *)&NEWGRID_ShowtimesSelectionContextPtr, rowBase);
            if (NEWGRID_UpdateSelectionFromInput(NEWGRID_ShowtimesWorkflowState, (LONG *)&NEWGRID_ShowtimesSelectionContextPtr) != 0) {
                NEWGRID_ShowtimesWorkflowState = 1;
            }
            break;

        case 1:
            NEWGRID_DrawGridMessageAlt(ctx);
            NEWGRID_ShowtimesColumnAdjust = 0;
            NEWGRID_ShowtimesWorkflowState = 2;
            break;

        case 2:
            if (GCOMMAND_PpvShowtimesWorkflowMode == 'B' || GCOMMAND_PpvShowtimesWorkflowMode == 'F') {
                NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleGridEditorState(
                    ctx, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen, GCOMMAND_PPVListingsTemplatePtr);
                if (NEWGRID_ShowtimesWorkflowState == 5) {
                    NEWGRID_ShowtimesWorkflowState = 2;
                    break;
                }
            }
            NEWGRID_ShowtimesWorkflowState = 3;
            break;

        case 3:
        case 4:
            NEWGRID_UpdateSelectionFromInput(NEWGRID_ShowtimesWorkflowState, (LONG *)&NEWGRID_ShowtimesSelectionContextPtr);
            steppedFrom34 = 1;
            /* fallthrough */

        case 5:
            if (NEWGRID_ShowtimesSelectionContextPtr != 0) {
                if (NEWGRID_ShouldOpenEditor((void *)NEWGRID_ShowtimesSelectionContextPtr) != 0) {
                    NEWGRID_ShowtimesWorkflowState = NEWGRID_UpdateGridState(
                        ctx, NEWGRID_ShowtimesWorkflowArgLong, (LONG)NEWGRID_ShowtimesWorkflowArgWord);
                } else {
                    NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleShowtimesState(
                        ctx, (LONG *)&NEWGRID_ShowtimesSelectionContextPtr);
                }

                if (GCOMMAND_DigitalPpvEnabledFlag == 'Y') {
                    if (steppedFrom34 && NEWGRID_ShowtimesColumnAdjust < 1) {
                        NEWGRID_ValidateSelectionCode(ctx, 53);
                        NEWGRID_ShowtimesColumnAdjust = NEWGRID_GetGridModeIndex();
                    }
                    NEWGRID_ShowtimesColumnAdjust -= NEWGRID_ComputeColumnIndex(ctx);
                }
            } else {
                NEWGRID_ShowtimesWorkflowState = 7;
            }
            break;

        case 6:
            if (GCOMMAND_PpvShowtimesWorkflowMode == 'B' || GCOMMAND_PpvShowtimesWorkflowMode == 'L') {
                NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleGridEditorState(
                    ctx, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen, GCOMMAND_PPVListingsTemplatePtr);
                if (NEWGRID_ShowtimesWorkflowState == 5) {
                    NEWGRID_ShowtimesWorkflowState = 7;
                    break;
                }
                NEWGRID_ShowtimesWorkflowState = 0;
            } else {
                NEWGRID_ShowtimesWorkflowState = 0;
            }
            break;

        case 7:
            NEWGRID_ShowtimesWorkflowState = 0;
            break;

        default:
            NEWGRID_ShowtimesWorkflowState = 0;
            break;
        }
    } else {
        NEWGRID_ShowtimesWorkflowState = 0;
    }

    if (NEWGRID_ShowtimesWorkflowState == 0) {
        NEWGRID_ClearEntryMarkerBits(rowBase);
    }
    return NEWGRID_ShowtimesWorkflowState;
}
