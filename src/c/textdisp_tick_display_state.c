/* RESTORES: TEXTDISP_TickDisplayState
 * MODULE:   modules/groups/b/a/textdisp2_p0_p0_p1.s
 * STATUS:   behavioural
 *
 * The per-tick display state machine. Every path ends in the copper-animation
 * call, and the two refresh-timer paths are DIFFERENT, which is the part worth
 * getting right.
 *
 * The busy path (UI busy, or runtime mode 2) does NOT run the deferred-action
 * block at all. It reaches the timer through a separate arm that reads the
 * counter, adds one, and clears the counter unless the add wrapped to zero --
 * so a counter of -1 is left alone and anything else is reset. The add result
 * is never stored; it exists only to make that test.
 *
 * The idle path runs the deferred block and then a DIFFERENT timer arm, which
 * compares against 180 and resets plus refreshes when it is reached.
 *
 * Inside the deferred block, countdowns of 3 AND 2 share one arm: the 3 test
 * branches into it and the 2 test falls through into it. Everything else takes
 * the class-id clear.
 *
 * The countdown decrement is guarded by an UNSIGNED compare (CMP.W / BLS), so
 * zero is left alone rather than wrapping.
 *
 * 188 ref vs 184 got. Both refresh-timer arms with their distinct shapes, the
 * CMPI.W #$b4 threshold, the ADDQ.W #1 wrap test, the shared 3-and-2 arm, the
 * MOVEQ #-1 class-id compare, the unsigned BLS decrement guard and all four
 * calls match in kind and size -- including the fact that the busy path never
 * touches the deferred block.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 33c00000c754 ... 33c0000028fa
 *            MOVEQ #0,D0 once, then stored to two different globals far apart
 *   got:     427900000000 ... 42790000
 *            CLR.W at each site
 *   summary: the original builds zero once at the top and reuses the register
 *            for the deferred-armed clear much later; 6.51 emits an independent
 *            CLR.W at each. Same stores, and it is where the 4 bytes go.
 *   tried:   nothing further; a plain `= 0` is the shape the original compiled
 *            from, and chaining the two would move the second store next to the
 *            first, which is not where the original has it.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern short TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan(void);
extern void  SCRIPT_AssertCtrlLineIfEnabled(void);
extern void  TEXTDISP_UpdateHighlightOrPreview(void);
extern void  TEXTDISP_ResetSelectionAndRefresh(void);
extern void  TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations(void);

extern short ESQ_GlobalTickCounter;
extern short TEXTDISP_TickSuspendFlag;
extern short Global_UIBusyFlag;
extern short SCRIPT_RuntimeMode;
extern unsigned short TEXTDISP_DeferredActionCountdown;
extern short TEXTDISP_DeferredActionArmed;
extern short TEXTDISP_DeferredActionDelayTicks;
extern short Global_RefreshTickCounter;
extern long  LOCAVAIL_FilterPrevClassId;

void TEXTDISP_TickDisplayState(void)
{
    ESQ_GlobalTickCounter = 0;

    if (TEXTDISP_TickSuspendFlag != 0)
        return;

    if (Global_UIBusyFlag != 0 || SCRIPT_RuntimeMode == 2) {
        if (Global_RefreshTickCounter + 1 != 0)
            Global_RefreshTickCounter = 0;
        TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
        return;
    }

    if (TEXTDISP_DeferredActionCountdown != 0
        && TEXTDISP_DeferredActionArmed != 0) {

        TEXTDISP_DeferredActionArmed = 0;

        if (TEXTDISP_DeferredActionCountdown == 3
            || TEXTDISP_DeferredActionCountdown == 2) {

            TEXTDISP_DeferredActionDelayTicks =
                TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan();
            SCRIPT_AssertCtrlLineIfEnabled();
            TEXTDISP_UpdateHighlightOrPreview();

        } else if (LOCAVAIL_FilterPrevClassId != -1) {
            LOCAVAIL_FilterPrevClassId = -1;
        }

        if (TEXTDISP_DeferredActionCountdown > 0)
            TEXTDISP_DeferredActionCountdown--;
    }

    if (Global_RefreshTickCounter >= 0xb4) {
        Global_RefreshTickCounter = 0;
        TEXTDISP_ResetSelectionAndRefresh();
    }

    TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
}
