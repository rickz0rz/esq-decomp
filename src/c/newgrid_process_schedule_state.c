/* RESTORES: _NEWGRID_ProcessScheduleState
 * MODULE:   modules/groups/b/a/newgrid1b_p2_newgrid_processschedulestate_newgrid_processschedulestate.s
 * STATUS:   behavioural
 *
 * The grid schedule state machine: one step per call, returning the new state.
 * Eight states dispatched through a real PC-relative jump table, and the cases
 * DELIBERATELY FALL THROUGH -- 0 into 1, 3 and 4 into 5, 5 into 6 into 7. Those
 * fall-throughs are load-bearing, not tidiness: state 0 sets up a search and then
 * runs state 1's draw in the same call, and state 5 with no entry left drops
 * straight into 6's retry loop. Writing them as independent cases with `break`
 * would change behaviour, not just bytes.
 *
 * A NULL context takes a separate legacy path with its own sparse dispatch on
 * states 2, 5 and 7 (chained SUBQ in the original -- 2 and 7 share a body), and
 * always ends by clearing both the state and the selection.
 *
 * The out-of-range check is UNSIGNED (`CMPI.L #8` / `BCC`), so a negative state
 * also lands in the default arm. Per AGENTS.md the bound test belongs to the
 * switch, so there is no explicit `if (state >= 8)` guard here -- `default:`
 * carries it, and writing both makes SAS/C emit the test twice.
 *
 * `progressed` (D5) exists only to gate the selection-code recalculation at the
 * end of state 5: it is set when the state arrived by falling through from 3/4,
 * and stays clear when state 5 was entered directly. That distinction is why it
 * cannot be replaced by a test on the state itself.
 *
 * NEEDS SHORTINT (992 against 934; 1004 without). Declared in src/c/scopts.txt.
 *
 * SASC-MISMATCH: switch-body-layout
 *   summary: +58 over 934, and it is NOT itemised. casm.py aligns the prologue
 *            and the legacy path but then produces a single 768-byte hunk for the
 *            whole main switch -- once the two streams disagree about where a
 *            case body sits, instruction alignment is lost and every later hunk
 *            is misleading. Per AGENTS.md rule 3 this is recorded as a
 *            known-unknown rather than attributed by guesswork; the honest
 *            statement is that the code generator laid the eight case bodies out
 *            differently, and how much of the 58 is that versus the A3/A5 class
 *            is not established.
 *   tried:   with and without SHORTINT (1004 / 992). Replacing the state-5
 *            no-entry `goto` with an if/else that falls through was worth 8
 *            bytes (1000 -> 992) and is also closer to the original's shape, so
 *            it was kept on both counts. The fall-through structure itself is
 *            not negotiable -- it is the program's behaviour.
 *   scope:   this function; large fall-through switches generally.
 *   retest:  a compiler that reserves A5, then re-run casm.py and see whether
 *            the switch region aligns before theorising further.
 */

struct GridCtx;

extern long  NEWGRID_ScheduleWorkflowState;
extern long  NEWGRID_SelectedPrimaryEntryIndex;
extern long  NEWGRID_ScheduleEditorGateFlag;
extern long  NEWGRID_ScheduleAltSelectorFlag;
extern short NEWGRID_ScheduleRowOffset;
extern long  NEWGRID_ScheduleSelectionCodeCache;

extern unsigned char  GCOMMAND_MplexWorkflowMode;
extern long           GCOMMAND_MplexSearchRowLimit;
extern unsigned char  GCOMMAND_DigitalMplexEnabledFlag;
extern unsigned char  GCOMMAND_MplexDetailLayoutFlag;
extern long           GCOMMAND_MplexListingsTemplatePtr;
extern long           GCOMMAND_MplexEditorRowPen;
extern long           GCOMMAND_MplexEditorLayoutPen;
extern void          *TEXTDISP_PrimaryEntryPtrTable[];

extern long NEWGRID_HandleGridEditorState(struct GridCtx *c, long a, long b, long d);
extern long NEWGRID_UpdateGridState(struct GridCtx *c, long idx, long row);
extern long NEWGRID_HandleDetailGridState(struct GridCtx *c, long idx, long row);
extern long NEWGRID_ShouldOpenEditor(void *entry);
extern long NEWGRID_FindNextEntryWithAltMarkers(long state, long idx, long row);
extern void NEWGRID_DrawStatusMessage(struct GridCtx *c, long row);
extern long NEWGRID_ComputeColumnIndex(struct GridCtx *c);
extern void NEWGRID_ValidateSelectionCode(struct GridCtx *c, long code);
extern long NEWGRID_GetGridModeIndex(void);

long NEWGRID_ProcessScheduleState(struct GridCtx *ctx, short baseRow, short statusRow)
{
    long progressed = 0;
    long code;

    if (!ctx) {
        switch (NEWGRID_ScheduleWorkflowState) {
        case 5:
            if (NEWGRID_ShouldOpenEditor(
                    TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SelectedPrimaryEntryIndex]))
                NEWGRID_UpdateGridState(ctx, 0L, 0L);
            else
                NEWGRID_HandleDetailGridState(ctx, 0L, 0L);
            break;
        case 2:
        case 7:
            NEWGRID_HandleGridEditorState(ctx, 0L, 0L, 0L);
            break;
        }
        NEWGRID_ScheduleWorkflowState = NEWGRID_SelectedPrimaryEntryIndex = 0;
        return NEWGRID_ScheduleWorkflowState;
    }

    switch (NEWGRID_ScheduleWorkflowState) {

    case 0:
        NEWGRID_ScheduleEditorGateFlag =
            (GCOMMAND_MplexWorkflowMode == 66 || GCOMMAND_MplexWorkflowMode == 70);
        NEWGRID_ScheduleAltSelectorFlag =
            (GCOMMAND_MplexWorkflowMode == 66 || GCOMMAND_MplexWorkflowMode == 76);

        NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
            NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex, baseRow);
        NEWGRID_ScheduleRowOffset = 0;

        while (NEWGRID_SelectedPrimaryEntryIndex == -1
               && NEWGRID_ScheduleRowOffset < GCOMMAND_MplexSearchRowLimit) {
            NEWGRID_ScheduleRowOffset++;
            NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
                NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
                (short)(baseRow + NEWGRID_ScheduleRowOffset));
        }

        if (NEWGRID_SelectedPrimaryEntryIndex == -1)
            return NEWGRID_ScheduleWorkflowState;

        NEWGRID_ScheduleWorkflowState = 1;
        /* FALLS THROUGH into state 1 -- the search and the draw happen in one call */

    case 1:
        NEWGRID_DrawStatusMessage(ctx, (short)(statusRow + NEWGRID_ScheduleRowOffset));
        NEWGRID_ScheduleSelectionCodeCache = 0;
        NEWGRID_ScheduleWorkflowState = NEWGRID_ScheduleEditorGateFlag ? 2 : 3;
        return NEWGRID_ScheduleWorkflowState;

    case 2:
        if (NEWGRID_ScheduleEditorGateFlag) {
            NEWGRID_ScheduleWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen,
                GCOMMAND_MplexListingsTemplatePtr);
            if (NEWGRID_ScheduleWorkflowState == 5) {
                NEWGRID_ScheduleWorkflowState = 2;
                return NEWGRID_ScheduleWorkflowState;
            }
            NEWGRID_ScheduleEditorGateFlag = 0;
            NEWGRID_ScheduleWorkflowState = 3;
            return NEWGRID_ScheduleWorkflowState;
        }
        NEWGRID_ScheduleWorkflowState = 3;
        /* FALLS THROUGH */

    case 3:
    case 4:
        NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
            NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
            (short)(baseRow + NEWGRID_ScheduleRowOffset));
        progressed = 1;
        /* FALLS THROUGH */

    case 5:
        if (NEWGRID_SelectedPrimaryEntryIndex == -1) {
            NEWGRID_ScheduleWorkflowState = 6;
        } else {
            if (NEWGRID_ShouldOpenEditor(
                    TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SelectedPrimaryEntryIndex]))
                NEWGRID_ScheduleWorkflowState = NEWGRID_UpdateGridState(
                    ctx, NEWGRID_SelectedPrimaryEntryIndex,
                    (short)(baseRow + NEWGRID_ScheduleRowOffset));
            else
                NEWGRID_ScheduleWorkflowState = NEWGRID_HandleDetailGridState(
                    ctx, NEWGRID_SelectedPrimaryEntryIndex,
                    (short)(baseRow + NEWGRID_ScheduleRowOffset));

            if (GCOMMAND_DigitalMplexEnabledFlag != 'Y')
                return NEWGRID_ScheduleWorkflowState;

            if (progressed && NEWGRID_ScheduleSelectionCodeCache < 1) {
                code = (GCOMMAND_MplexDetailLayoutFlag == 'N') ? 36 : 52;
                NEWGRID_ValidateSelectionCode(ctx, code);
                NEWGRID_ScheduleSelectionCodeCache = NEWGRID_GetGridModeIndex();
        }
        NEWGRID_ScheduleSelectionCodeCache -= NEWGRID_ComputeColumnIndex(ctx);
        return NEWGRID_ScheduleWorkflowState;
        }
        /* FALLS THROUGH -- only reached when there was no entry left */

    case 6:
        while (NEWGRID_SelectedPrimaryEntryIndex == -1
               && NEWGRID_ScheduleRowOffset < GCOMMAND_MplexSearchRowLimit) {
            NEWGRID_ScheduleRowOffset++;
            NEWGRID_SelectedPrimaryEntryIndex = NEWGRID_FindNextEntryWithAltMarkers(
                NEWGRID_ScheduleWorkflowState, NEWGRID_SelectedPrimaryEntryIndex,
                (short)(baseRow + NEWGRID_ScheduleRowOffset));
        }
        if (NEWGRID_SelectedPrimaryEntryIndex != -1) {
            NEWGRID_ScheduleWorkflowState = 1;
            return NEWGRID_ScheduleWorkflowState;
        }
        NEWGRID_ScheduleWorkflowState = 7;
        /* FALLS THROUGH */

    case 7:
        if (!NEWGRID_ScheduleAltSelectorFlag) {
            NEWGRID_ScheduleWorkflowState = 0;
            return NEWGRID_ScheduleWorkflowState;
        }
        NEWGRID_ScheduleWorkflowState = NEWGRID_HandleGridEditorState(
            ctx, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen,
            GCOMMAND_MplexListingsTemplatePtr);
        if (NEWGRID_ScheduleWorkflowState == 5) {
            NEWGRID_ScheduleWorkflowState = 7;
            return NEWGRID_ScheduleWorkflowState;
        }
        NEWGRID_ScheduleWorkflowState = NEWGRID_ScheduleAltSelectorFlag = 0;
        return NEWGRID_ScheduleWorkflowState;

    default:
        NEWGRID_ScheduleWorkflowState = 0;
        break;
    }

    return NEWGRID_ScheduleWorkflowState;
}
