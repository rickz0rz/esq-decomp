/* RESTORES: _NEWGRID_ProcessSecondaryState
 * MODULE:   modules/groups/b/a/newgrid1b_p2_newgrid_processsecondarystate.s
 * STATUS:   behavioural
 *
 * The secondary (Niche) grid state machine -- the sibling of
 * newgrid_process_schedule_state.c, same eight-state jump table and the same
 * deliberate fall-throughs (0 into 2, 2 into 3, 3 and 4 into 5, 5 into 7), but a
 * different set of globals and two states that do nothing at all.
 *
 * Restoring the pair together is what shows the shape is the program's idiom for
 * a grid workflow rather than a one-off. The differences are the interesting
 * part: this one has no row-offset retry loop, so states 1 and 6 fall straight to
 * the exit, and its editor gate is a mode-byte test (66 or 70 for state 2, 66 or
 * 76 for state 7) instead of a cached flag.
 *
 * It also recalculates the selection hint in TWO places rather than one -- once
 * inside the process-entries arm when that arm returns state 5, and again in the
 * shared tail -- each gated on a different config byte. Both then get the column
 * index subtracted at the end.
 *
 * As in the sibling, `progressed` (D6) is only set when state 5 was reached by
 * falling through from 3/4, and gates both hint recalculations.
 *
 * 684 against 662 -- +22, against the sibling's +58 on 934. The pair is worth
 * comparing: the same fall-through switch shape, written the same way, lands at
 * 3.3% over here and 6.2% over there. The difference is that this one has no
 * retry loops inside its cases, which supports the sibling's header note that
 * its residual is case-body LAYOUT rather than any idiom either file gets wrong.
 *
 * SASC-MISMATCH: switch-body-layout
 *   summary: +22, not itemised for the same reason as the sibling -- casm.py
 *            loses alignment across the eight case bodies, so a per-arm
 *            attribution would be invention. Recorded per AGENTS.md rule 3.
 *   tried:   with and without SHORTINT (688 / 684); without is kept. Both are
 *            close enough that the option is not load-bearing here, unlike the
 *            three files in scopts.txt.
 *   scope:   large fall-through switches; see newgrid_process_schedule_state.c.
 *   retest:  a compiler that reserves A5, then re-measure both siblings together.
 */

struct GridCtx;

extern long NEWGRID_SecondaryWorkflowState;
extern long NEWGRID_SecondarySelectedEntryIndex;
extern long NEWGRID_SecondarySelectionHintCounter;

extern unsigned char GCOMMAND_NicheWorkflowMode;
extern unsigned char GCOMMAND_DigitalNicheEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern long GCOMMAND_DigitalNicheListingsTemplatePtr;
extern long GCOMMAND_NicheEditorRowPen;
extern long GCOMMAND_NicheEditorLayoutPen;
extern void *TEXTDISP_PrimaryEntryPtrTable[];

extern long NEWGRID_HandleGridEditorState(struct GridCtx *c, long a, long b, long d);
extern long NEWGRID_UpdateGridState(struct GridCtx *c, long idx, long row);
extern long NEWGRID_ProcessGridEntries(struct GridCtx *c, long idx, long row);
extern long NEWGRID_ShouldOpenEditor(void *entry);
extern long NEWGRID_FindNextEntryWithFlags(long state, long idx);
extern long NEWGRID_ComputeColumnIndex(struct GridCtx *c);
extern void NEWGRID_ValidateSelectionCode(struct GridCtx *c, long code);
extern long NEWGRID_GetGridModeIndex(void);

long NEWGRID_ProcessSecondaryState(struct GridCtx *ctx, short row)
{
    long progressed = 0;

    if (!ctx) {
        switch (NEWGRID_SecondaryWorkflowState) {
        case 5:
            if (NEWGRID_ShouldOpenEditor(
                    TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SecondarySelectedEntryIndex]))
                NEWGRID_UpdateGridState(ctx, 0L, 0L);
            else
                NEWGRID_ProcessGridEntries(ctx, 0L, 0L);
            break;
        case 2:
        case 7:
            NEWGRID_HandleGridEditorState(ctx, 0L, 0L, 0L);
            break;
        }
        NEWGRID_SecondaryWorkflowState = NEWGRID_SecondarySelectedEntryIndex = 0;
        return NEWGRID_SecondaryWorkflowState;
    }

    switch (NEWGRID_SecondaryWorkflowState) {

    case 0:
        NEWGRID_SecondarySelectionHintCounter = 0;
        NEWGRID_SecondarySelectedEntryIndex = NEWGRID_FindNextEntryWithFlags(
            NEWGRID_SecondaryWorkflowState, NEWGRID_SecondarySelectedEntryIndex);
        if (NEWGRID_SecondarySelectedEntryIndex + 1 == 0)
            return NEWGRID_SecondaryWorkflowState;
        NEWGRID_SecondaryWorkflowState = 2;
        /* FALLS THROUGH */

    case 2:
        if (GCOMMAND_NicheWorkflowMode == 66 || GCOMMAND_NicheWorkflowMode == 70) {
            NEWGRID_SecondaryWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_NicheEditorLayoutPen, GCOMMAND_NicheEditorRowPen,
                GCOMMAND_DigitalNicheListingsTemplatePtr);
            if (NEWGRID_SecondaryWorkflowState == 5) {
                NEWGRID_SecondaryWorkflowState = 2;
                return NEWGRID_SecondaryWorkflowState;
            }
            NEWGRID_SecondaryWorkflowState = 3;
            return NEWGRID_SecondaryWorkflowState;
        }
        NEWGRID_SecondaryWorkflowState = 3;
        /* FALLS THROUGH */

    case 3:
    case 4:
        NEWGRID_SecondarySelectedEntryIndex = NEWGRID_FindNextEntryWithFlags(
            NEWGRID_SecondaryWorkflowState, NEWGRID_SecondarySelectedEntryIndex);
        progressed = 1;
        /* FALLS THROUGH */

    case 5:
        if (NEWGRID_SecondarySelectedEntryIndex == -1) {
            NEWGRID_SecondaryWorkflowState = 7;
        } else {
            if (NEWGRID_ShouldOpenEditor(
                    TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SecondarySelectedEntryIndex])) {
                NEWGRID_SecondaryWorkflowState = NEWGRID_UpdateGridState(
                    ctx, NEWGRID_SecondarySelectedEntryIndex, row);
            } else {
                NEWGRID_SecondaryWorkflowState = NEWGRID_ProcessGridEntries(
                    ctx, NEWGRID_SecondarySelectedEntryIndex, row);
                if (progressed
                    && NEWGRID_SecondarySelectionHintCounter < 1
                    && NEWGRID_SecondaryWorkflowState == 5
                    && CONFIG_NewgridSelectionCode48_49EnabledFlag == 89) {
                    NEWGRID_ValidateSelectionCode(ctx, 49L);
                    NEWGRID_SecondarySelectionHintCounter = NEWGRID_GetGridModeIndex();
                }
            }

            if (GCOMMAND_DigitalNicheEnabledFlag == 89
                && progressed
                && NEWGRID_SecondarySelectionHintCounter < 1) {
                NEWGRID_ValidateSelectionCode(ctx, 33L);
                NEWGRID_SecondarySelectionHintCounter = NEWGRID_GetGridModeIndex();
            }

            if (NEWGRID_SecondarySelectionHintCounter > 0)
                NEWGRID_SecondarySelectionHintCounter -= NEWGRID_ComputeColumnIndex(ctx);
            return NEWGRID_SecondaryWorkflowState;
        }
        /* FALLS THROUGH -- only when there was no entry left */

    case 7:
        if (GCOMMAND_NicheWorkflowMode == 66 || GCOMMAND_NicheWorkflowMode == 76) {
            NEWGRID_SecondaryWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_NicheEditorLayoutPen, GCOMMAND_NicheEditorRowPen,
                GCOMMAND_DigitalNicheListingsTemplatePtr);
            if (NEWGRID_SecondaryWorkflowState == 5) {
                NEWGRID_SecondaryWorkflowState = 7;
                return NEWGRID_SecondaryWorkflowState;
            }
            NEWGRID_SecondaryWorkflowState = 0;
            return NEWGRID_SecondaryWorkflowState;
        }
        NEWGRID_SecondaryWorkflowState = 0;
        break;
    }

    return NEWGRID_SecondaryWorkflowState;
}
