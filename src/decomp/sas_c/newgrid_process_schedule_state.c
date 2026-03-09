typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LayoutCtx LayoutCtx;
typedef struct NEWGRID_Entry NEWGRID_Entry;

struct NEWGRID_Entry {
    UBYTE pad0[1];
};

extern LONG NEWGRID_ScheduleWorkflowState;
extern LONG NEWGRID_SelectedPrimaryEntryIndex;
extern LONG NEWGRID_ScheduleEditorGateFlag;
extern LONG NEWGRID_ScheduleAltSelectorFlag;
extern LONG NEWGRID_ScheduleSelectionCodeCache;
extern UWORD NEWGRID_ScheduleRowOffset;

extern UBYTE GCOMMAND_MplexWorkflowMode;
extern UBYTE GCOMMAND_DigitalMplexEnabledFlag;
extern UBYTE GCOMMAND_MplexDetailLayoutFlag;
extern LONG GCOMMAND_MplexSearchRowLimit;
extern LONG GCOMMAND_MplexListingsTemplatePtr;
extern LONG GCOMMAND_MplexEditorRowPen;
extern LONG GCOMMAND_MplexEditorLayoutPen;

extern UWORD CLOCK_DaySlotIndex;
extern NEWGRID_Entry *TEXTDISP_PrimaryEntryPtrTable[];

extern LONG NEWGRID_HandleGridEditorState(LayoutCtx *ctx, LONG a, LONG b, LONG c);
extern LONG NEWGRID_ShouldOpenEditor(void *entry);
extern LONG NEWGRID_UpdateGridState(LayoutCtx *ctx, LONG index, LONG row);
extern LONG NEWGRID_HandleDetailGridState(LayoutCtx *ctx, LONG index, LONG row);
extern LONG NEWGRID_FindNextEntryWithAltMarkers(LONG state, LONG selected, LONG row);
extern LONG NEWGRID_DrawStatusMessage(LayoutCtx *ctx, LONG row);
extern LONG NEWGRID_ValidateSelectionCode(LayoutCtx *ctx, LONG code);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(LayoutCtx *ctx);

LONG NEWGRID_ProcessScheduleState(LayoutCtx *ctx, UWORD rowBase, UWORD rowCur)
{
    LONG steppedFromState34 = 0;

    if (!ctx) {
        if (NEWGRID_ScheduleWorkflowState == 2 || NEWGRID_ScheduleWorkflowState == 7) {
            NEWGRID_HandleGridEditorState(ctx, 0, 0, 0);
        } else if (NEWGRID_ScheduleWorkflowState == 5) {
            LONG idx = NEWGRID_SelectedPrimaryEntryIndex;
            NEWGRID_Entry *entry = TEXTDISP_PrimaryEntryPtrTable[idx];
            if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                NEWGRID_UpdateGridState(ctx, 0, 0);
            } else {
                NEWGRID_HandleDetailGridState(ctx, 0, 0);
            }
        }
        NEWGRID_ScheduleWorkflowState = 0;
        NEWGRID_SelectedPrimaryEntryIndex = 0;
        return NEWGRID_ScheduleWorkflowState;
    }

    if (NEWGRID_ScheduleWorkflowState >= 8) {
        NEWGRID_ScheduleWorkflowState = 0;
        return NEWGRID_ScheduleWorkflowState;
    }

    switch (NEWGRID_ScheduleWorkflowState) {
    case 0: {
        LONG gate = (GCOMMAND_MplexWorkflowMode == 'B' || GCOMMAND_MplexWorkflowMode == 'F') ? 1 : 0;
        LONG alt = (GCOMMAND_MplexWorkflowMode == 'B' || GCOMMAND_MplexWorkflowMode == 'L') ? 1 : 0;

        NEWGRID_ScheduleEditorGateFlag = gate;
        NEWGRID_ScheduleAltSelectorFlag = alt;
        NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
            NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex, rowBase);

        NEWGRID_ScheduleRowOffset = 0;
        while (NEWGRID_SelectedPrimaryEntryIndex == -1 && NEWGRID_ScheduleRowOffset < GCOMMAND_MplexSearchRowLimit) {
            NEWGRID_ScheduleRowOffset++;
            NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
                NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
                (LONG)rowBase + NEWGRID_ScheduleRowOffset);
        }

        if (NEWGRID_SelectedPrimaryEntryIndex != -1) {
            NEWGRID_ScheduleWorkflowState = 1;
        }
        break;
    }

    case 1:
        NEWGRID_DrawStatusMessage(ctx, (LONG)rowCur + NEWGRID_ScheduleRowOffset);
        NEWGRID_ScheduleSelectionCodeCache = 0;
        NEWGRID_ScheduleWorkflowState = NEWGRID_ScheduleEditorGateFlag ? 2 : 3;
        break;

    case 2:
        if (NEWGRID_ScheduleEditorGateFlag) {
            NEWGRID_ScheduleWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen, GCOMMAND_MplexListingsTemplatePtr);
            if (NEWGRID_ScheduleWorkflowState == 5) {
                NEWGRID_ScheduleWorkflowState = 2;
                return NEWGRID_ScheduleWorkflowState;
            }
            NEWGRID_ScheduleEditorGateFlag = 0;
        }
        NEWGRID_ScheduleWorkflowState = 3;
        break;

    case 3:
    case 4:
        NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
            NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
            (LONG)rowBase + NEWGRID_ScheduleRowOffset);
        steppedFromState34 = 1;
        /* fallthrough */

    case 5:
        if (NEWGRID_SelectedPrimaryEntryIndex != -1) {
            NEWGRID_Entry *entry = TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SelectedPrimaryEntryIndex];
            if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                NEWGRID_ScheduleWorkflowState = NEWGRID_UpdateGridState(
                    ctx, NEWGRID_SelectedPrimaryEntryIndex, (LONG)rowBase + NEWGRID_ScheduleRowOffset);
            } else {
                NEWGRID_ScheduleWorkflowState = NEWGRID_HandleDetailGridState(
                    ctx, NEWGRID_SelectedPrimaryEntryIndex, (LONG)rowBase + NEWGRID_ScheduleRowOffset);
            }

            if (GCOMMAND_DigitalMplexEnabledFlag == 'Y') {
                if (steppedFromState34 && NEWGRID_ScheduleSelectionCodeCache < 1) {
                    LONG seed = (GCOMMAND_MplexDetailLayoutFlag == 'N') ? 36 : 52;
                    NEWGRID_ValidateSelectionCode(ctx, seed);
                    NEWGRID_ScheduleSelectionCodeCache = NEWGRID_GetGridModeIndex();
                }
                NEWGRID_ScheduleSelectionCodeCache -= NEWGRID_ComputeColumnIndex(ctx);
            }
        } else {
            NEWGRID_ScheduleWorkflowState = 6;
        }
        break;

    case 6:
        while (NEWGRID_SelectedPrimaryEntryIndex == -1 && NEWGRID_ScheduleRowOffset < GCOMMAND_MplexSearchRowLimit) {
            NEWGRID_ScheduleRowOffset++;
            NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
                NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
                (LONG)rowBase + NEWGRID_ScheduleRowOffset);
        }
        NEWGRID_ScheduleWorkflowState = (NEWGRID_SelectedPrimaryEntryIndex == -1) ? 7 : 1;
        break;

    case 7:
        if (NEWGRID_ScheduleAltSelectorFlag) {
            NEWGRID_ScheduleWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen, GCOMMAND_MplexListingsTemplatePtr);
            if (NEWGRID_ScheduleWorkflowState == 5) {
                NEWGRID_ScheduleWorkflowState = 7;
                return NEWGRID_ScheduleWorkflowState;
            }
            NEWGRID_ScheduleWorkflowState = 0;
            NEWGRID_ScheduleAltSelectorFlag = 0;
        } else {
            NEWGRID_ScheduleWorkflowState = 0;
        }
        break;

    default:
        NEWGRID_ScheduleWorkflowState = 0;
        break;
    }

    return NEWGRID_ScheduleWorkflowState;
}
