/* RESTORES: SCRIPT_ProcessCtrlContextPlaybackTick
 * MODULE:   modules/groups/b/a/script3b2_p1.s
 * STATUS:   behavioural
 *
 * One playback tick: update the filter state, load the CTRL snapshot, decide
 * whether to dispatch a cursor command, and save the snapshot back.
 *
 * The snapshot load and save BRACKET everything -- the save runs on every path,
 * including the ones that dispatch nothing.
 *
 * The dispatch guard reads as one condition but is two nested ones in the
 * original: runtime mode 2 AND the latch set AND the cursor above 10 falls into
 * the dispatch block, and every other combination of those three clears the
 * latch instead. The BEQ at 0x2A3C6 and the BLE at 0x2A3D2 both land on the
 * CLR.W.
 *
 * Note the latch clear is a CLR.W of a value that is already zero on one of the
 * two paths into it -- the original does not care, and neither does this.
 *
 * The cursor is forced to 2 only when the MSN flag is 'M' AND the cursor is
 * strictly between 0 and 10.
 *
 * The dispatch call takes the ADDRESS of the cursor global, so the command can
 * advance it.
 *
 * 200 ref vs 200 got, and the structure carries it rather than the size. Every
 * guard, both cursor bounds (10 and 15), the MOVEQ #2 cursor force, the
 * MOVEQ #3 mode, the TST.W on the runtime-mode helper, the PEA of the cursor
 * address, the memory-to-memory match-index save (33f9) and both snapshot calls
 * agree in kind, order and size.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 23c0000075fe    MOVEQ #0,D0 / MOVE.L D0,flag
 *   got:     42b900000000        CLR.L flag
 *   summary: 6.51 clears the deferred flag in place where the original routes
 *            zero through a register. Same store.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: guard-branch-polarity
 *   ref:     6740 ... 6f34        both guard failures branch FORWARD to the
 *                                 latch clear
 *   got:     670c ... 6e08        6.51 inverts one of the two and branches over
 *   summary: same three-way condition, same outcome on every input; only which
 *            test falls through. Costs nothing.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void LOCAVAIL_UpdateFilterStateMachine(void *ctx,
                                                             char *state);
extern void SCRIPT_LoadCtrlContextSnapshot(void *ctx);
extern void SCRIPT_SaveCtrlContextSnapshot(void *ctx);
extern short SCRIPT_UpdateRuntimeModeForPlaybackCursor(void);
extern void SCRIPT_ApplyPendingBannerTarget(void);
extern void SCRIPT_DispatchPlaybackCursorCommand(long *cursor);

extern char  LOCAVAIL_PrimaryFilterState[];
extern long  SCRIPT_RuntimeModeDeferredFlag;
extern short SCRIPT_RuntimeMode;
extern short SCRIPT_RuntimeModeDispatchLatch;
extern long  SCRIPT_PlaybackCursor;
extern char  CONFIG_MSN_FlagChar;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_CurrentMatchIndexSaved;

void SCRIPT_ProcessCtrlContextPlaybackTick(void *ctx)
{
    LOCAVAIL_UpdateFilterStateMachine(ctx,
                                                     LOCAVAIL_PrimaryFilterState);
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    if (SCRIPT_RuntimeModeDeferredFlag != 0) {
        SCRIPT_RuntimeMode = 3;
        SCRIPT_RuntimeModeDeferredFlag = 0;
    }

    if (CONFIG_MSN_FlagChar == 'M' && SCRIPT_PlaybackCursor > 0
        && SCRIPT_PlaybackCursor < 10)
        SCRIPT_PlaybackCursor = 2;

    if (SCRIPT_RuntimeMode == 2
        && (SCRIPT_RuntimeModeDispatchLatch == 0
            || SCRIPT_PlaybackCursor <= 10)) {

        SCRIPT_RuntimeModeDispatchLatch = 0;

    } else if (SCRIPT_PlaybackCursor > 0 && SCRIPT_PlaybackCursor <= 15
               && SCRIPT_UpdateRuntimeModeForPlaybackCursor() == 0) {

        if (SCRIPT_PlaybackCursor != 1)
            SCRIPT_ApplyPendingBannerTarget();

        SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor);
    }

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;
    SCRIPT_SaveCtrlContextSnapshot(ctx);
}
