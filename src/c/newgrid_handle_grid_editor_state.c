/* RESTORES: NEWGRID_HandleGridEditorState
 * MODULE:   modules/groups/b/a/newgrid1b_p2.s
 * STATUS:   behavioural
 *
 * Runs one step of the grid editor workflow and returns the new state.
 *
 * Only states 4 and 5 do anything; every other value is forced to 4. A null
 * context also forces 4 without drawing.
 *
 * The two active states differ in what they do BEFORE drawing -- state 4 lays
 * the text out and computes the visible line count, state 5 just stamps -1 into
 * the same field -- and then both run the same draw and the same result
 * mapping.
 *
 * THE RESULT MAPPING IS INVERTED FROM THE OBVIOUS READING: a ZERO from the draw
 * gives state 5 and a non-zero gives state 4. The BEQ at 0x23584 lands on the
 * MOVEQ #5.
 *
 * The return value is RE-READ from the global rather than taken from the
 * register that just wrote it, on every path.
 *
 * The layout call takes 612 and 20 as literals, and the line-count call takes a
 * literal 0.
 *
 * 170 ref vs 168 got. The opcode chain, the PEA 612 / PEA 20 layout literals,
 * the CLR.L line-count argument, both draw calls, the MOVEQ #-1 stamp, the
 * LEA 20(A7),A7 and ADDQ.W #8 cleanups and the final re-read of the state
 * global all match in kind and size.
 *
 * SASC-MISMATCH: booleanize-instead-of-branch
 *   ref:     4a80 6704 7004 6002 7005    TST.L / BEQ / MOVEQ #4 / BRA / MOVEQ #5
 *   got:     4a80 57c1 7404 9401 23c2    TST.L / SEQ D1 / MOVEQ #4,D2 /
 *                                        SUB.B D1,D2 / store D2
 *   summary: the original branches to pick 4 or 5; 6.51 turns the same choice
 *            into a booleanize -- SEQ gives 0xFF when the draw returned zero,
 *            and subtracting it from 4 gives 5. Same two outcomes, no branch.
 *            Both arms do it, and it is 2 bytes cheaper.
 *   tried:   writing both arms as if/else instead of the conditional
 *            expression, measured at 184 bytes against the ternary's 168 and
 *            the original's 170. The if/else is much worse -- 6.51 emits the
 *            branch AND keeps the booleanize elsewhere. The ternary is kept.
 *            Note the original itself uses the branch form, so neither C
 *            spelling reaches it; the ternary is simply the closer of the two.
 *   scope:   any two-constant conditional assignment.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridEditorContext {
    char pad0[32];
    long lineCount;             /* +32 */
    char pad36[24];
    char text60[1];             /* +60 */
};

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(long a, long b, long c);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *dst,
                                                             char *src);
extern long NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(long minLines);
extern long NEWGRID_DrawGridFrameAndRows(struct NewGridEditorContext *ctx,
                                         long arg);

extern long NEWGRID_GridEditorWorkflowState;

long NEWGRID_HandleGridEditorState(struct NewGridEditorContext *ctx, long layout,
                                   long drawArg, char *text)
{
    if (ctx == 0) {
        NEWGRID_GridEditorWorkflowState = 4;
        return NEWGRID_GridEditorWorkflowState;
    }

    switch (NEWGRID_GridEditorWorkflowState) {
    case 4:
        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612L, 20L, layout);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(ctx->text60, text);
        ctx->lineCount = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0L);

        NEWGRID_GridEditorWorkflowState =
            NEWGRID_DrawGridFrameAndRows(ctx, drawArg) ? 4 : 5;
        break;

    case 5:
        ctx->lineCount = -1;
        NEWGRID_GridEditorWorkflowState =
            NEWGRID_DrawGridFrameAndRows(ctx, drawArg) ? 4 : 5;
        break;

    default:
        NEWGRID_GridEditorWorkflowState = 4;
        break;
    }

    return NEWGRID_GridEditorWorkflowState;
}
