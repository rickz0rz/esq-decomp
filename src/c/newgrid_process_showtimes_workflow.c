/* RESTORES: NEWGRID_ProcessShowtimesWorkflow
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * The showtimes state machine: eight states over a jump table, with FOUR
 * deliberate fall-throughs. It answers the next state, and the caller drives it
 * until the state returns to 0.
 *
 * THE FALL-THROUGHS ARE THE DESIGN, not an accident of layout. State 0 falls
 * into 1 once the selection window accepts input; state 2 falls into 3 when the
 * workflow mode is neither 'B' nor 'F'; states 3 and 4 share a body and fall
 * into 5; and the no-entry exit from 5 sets state 7 and falls into its body. So
 * one call can traverse four states. Writing each case with its own `break`
 * turns a single-call advance into four calls.
 *
 * A NULL CONTEXT IS A SEPARATE, SMALLER MACHINE. It handles only states 2, 7
 * and 5 -- the first two together -- and then unconditionally resets the
 * selection window and the state. Nothing else in the function is reachable
 * with a null context.
 *
 * THE MODE LETTERS DIFFER BETWEEN THE TWO EDITOR STATES. State 2 accepts 66
 * ('B') or 70 ('F'); state 7 accepts 66 ('B') or 76 ('L'). Both call the same
 * editor with the same three arguments, and both map a returned 5 back to their
 * OWN state -- 2 stays 2, 7 stays 7 -- and anything else forward: 2 goes to 3,
 * 7 goes to 0. The two blocks look identical and differ in three constants.
 *
 * STATE 6 IS NOT A STATE. Its table slot points at the clear-and-exit path,
 * alongside every index at or above 8. The C expresses that as `default`, per
 * the AGENTS.md rule against writing an explicit range guard in front of a
 * switch.
 *
 * THE COLUMN ADJUSTMENT IS ONLY SEEDED ONCE PER PASS, and only when the state
 * actually advanced through 3 or 4 -- that is what the local flag records. It
 * is then decremented by the computed column on EVERY pass through state 5,
 * seeded or not, so it drifts negative until something reseeds it.
 *
 * The seeding call pair is odd and is reproduced as-is: ValidateSelectionCode
 * is called with the context and 53, and GetGridModeIndex is then called with
 * NO arguments of its own -- the original pops both frames with one `ADDQ #8`.
 *
 * The marker bits are cleared only when the machine has returned to state 0,
 * which is the one thing every exit path has in common.
 *
 * 656 ref vs 660 got, 26 differing regions. THE JUMP TABLE IS REPRODUCED: the
 * reference emits `303b` / `4efb` and so does this candidate, with the same
 * eight entries and the same two indices pointing at the clear path. For a
 * state machine that is the structural check that matters, and it is the fourth
 * dispatcher in this tranche where it succeeded and the second where it did
 * not -- see script_handle_serial_ctrl_cmd.c for the failure.
 *
 * All four fall-throughs, both null-context arms, both editor blocks with their
 * differing mode letters and state mappings, the selection-window init and
 * update calls, the flag-gated seeding, the unconditional decrement and the
 * state-0 marker clear match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fffc   LINK.W A5,#-4
 *   got:     a bare stack adjust, the flag kept in a register
 *   summary: the frame class, and 4 bytes -- the smallest in this tranche. The
 *            function has one local and the original spills it; 6.51 does not.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long NEWGRID_HandleGridEditorState(void *ctx, long a, long b, void *c);
extern long NEWGRID_ShouldOpenEditor(void *p);
extern long NEWGRID_UpdateGridState(void *ctx, long a, long b);
extern long NEWGRID_HandleShowtimesState(void *ctx, void *p);
extern void NEWGRID_InitSelectionWindow(void *slot, long v);
extern long NEWGRID_UpdateSelectionFromInput(long state, void *slot);
extern void NEWGRID_DrawGridMessageAlt(void *ctx);
extern void NEWGRID_ValidateSelectionCode(void *ctx, long code);
extern long NEWGRID_GetGridModeIndex(void);
extern long NEWGRID_ComputeColumnIndex(void *ctx);
extern void NEWGRID_ClearEntryMarkerBits(long v);

extern long  NEWGRID_ShowtimesWorkflowState;
extern void *NEWGRID_ShowtimesSelectionContextPtr;
extern long  NEWGRID_ShowtimesColumnAdjust;
extern long  NEWGRID_ShowtimesWorkflowArgLong;
extern short NEWGRID_ShowtimesWorkflowArgWord;
extern char  GCOMMAND_PpvShowtimesWorkflowMode;
extern char  GCOMMAND_DigitalPpvEnabledFlag;
extern long  GCOMMAND_PpvEditorLayoutPen;
extern long  GCOMMAND_PpvEditorRowPen;
extern void *GCOMMAND_PPVListingsTemplatePtr;

long NEWGRID_ProcessShowtimesWorkflow(void *ctx, short arg)
{
    long advanced;

    advanced = 0;

    if (ctx == 0) {

        if (NEWGRID_ShowtimesWorkflowState == 2
            || NEWGRID_ShowtimesWorkflowState == 7) {

            NEWGRID_ShowtimesWorkflowState =
                NEWGRID_HandleGridEditorState(ctx, 0L, 0L, 0);

        } else if (NEWGRID_ShowtimesWorkflowState == 5) {

            if (NEWGRID_ShouldOpenEditor(
                    NEWGRID_ShowtimesSelectionContextPtr) != 0)
                NEWGRID_ShowtimesWorkflowState =
                    NEWGRID_UpdateGridState(ctx, 0L, 0L);
            else
                NEWGRID_ShowtimesWorkflowState =
                    NEWGRID_HandleShowtimesState(ctx, 0);
        }

        NEWGRID_InitSelectionWindow(&NEWGRID_ShowtimesSelectionContextPtr, 0L);
        NEWGRID_ShowtimesWorkflowState = 0;
        goto returnState;
    }

    switch (NEWGRID_ShowtimesWorkflowState) {

    case 0:
        NEWGRID_InitSelectionWindow(&NEWGRID_ShowtimesSelectionContextPtr,
                                    (long)arg);

        if (NEWGRID_UpdateSelectionFromInput(
                NEWGRID_ShowtimesWorkflowState,
                &NEWGRID_ShowtimesSelectionContextPtr) == 0)
            goto returnState;

        NEWGRID_ShowtimesWorkflowState = 1;
        /* fall through */

    case 1:
        NEWGRID_DrawGridMessageAlt(ctx);
        NEWGRID_ShowtimesColumnAdjust  = 0;
        NEWGRID_ShowtimesWorkflowState = 2;
        goto returnState;

    case 2:
        if (GCOMMAND_PpvShowtimesWorkflowMode == 66
            || GCOMMAND_PpvShowtimesWorkflowMode == 70) {

            NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen,
                GCOMMAND_PPVListingsTemplatePtr);

            if (NEWGRID_ShowtimesWorkflowState == 5)
                NEWGRID_ShowtimesWorkflowState = 2;
            else
                NEWGRID_ShowtimesWorkflowState = 3;

            goto returnState;
        }

        NEWGRID_ShowtimesWorkflowState = 3;
        /* fall through */

    case 3:
    case 4:
        NEWGRID_UpdateSelectionFromInput(
            NEWGRID_ShowtimesWorkflowState,
            &NEWGRID_ShowtimesSelectionContextPtr);
        advanced = 1;
        /* fall through */

    case 5:
        if (NEWGRID_ShowtimesSelectionContextPtr == 0) {
            NEWGRID_ShowtimesWorkflowState = 7;
            goto state6;
        }

        if (NEWGRID_ShouldOpenEditor(
                NEWGRID_ShowtimesSelectionContextPtr) != 0)
            NEWGRID_ShowtimesWorkflowState = NEWGRID_UpdateGridState(
                ctx, NEWGRID_ShowtimesWorkflowArgLong,
                (long)NEWGRID_ShowtimesWorkflowArgWord);
        else
            NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleShowtimesState(
                ctx, &NEWGRID_ShowtimesSelectionContextPtr);

        if (GCOMMAND_DigitalPpvEnabledFlag != 89)
            goto returnState;

        if (advanced != 0 && NEWGRID_ShowtimesColumnAdjust < 1) {
            NEWGRID_ValidateSelectionCode(ctx, 53L);
            NEWGRID_ShowtimesColumnAdjust = NEWGRID_GetGridModeIndex();
        }

        NEWGRID_ShowtimesColumnAdjust -= NEWGRID_ComputeColumnIndex(ctx);
        goto returnState;

    case 7:
state6:
        if (GCOMMAND_PpvShowtimesWorkflowMode == 66
            || GCOMMAND_PpvShowtimesWorkflowMode == 76) {

            NEWGRID_ShowtimesWorkflowState = NEWGRID_HandleGridEditorState(
                ctx, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen,
                GCOMMAND_PPVListingsTemplatePtr);

            if (NEWGRID_ShowtimesWorkflowState == 5)
                NEWGRID_ShowtimesWorkflowState = 7;
            else
                NEWGRID_ShowtimesWorkflowState = 0;

            goto returnState;
        }

        NEWGRID_ShowtimesWorkflowState = 0;
        goto returnState;

    default:
        NEWGRID_ShowtimesWorkflowState = 0;
        break;
    }

returnState:
    if (NEWGRID_ShowtimesWorkflowState == 0)
        NEWGRID_ClearEntryMarkerBits((long)arg);

    return NEWGRID_ShowtimesWorkflowState;
}
