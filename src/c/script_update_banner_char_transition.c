/* RESTORES: SCRIPT_UpdateBannerCharTransition
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * 198 bytes in the original, 204 emitted, 6 differing regions.
 *
 * SECOND __saveds function found (after ctasks_ifftaskcleanup.c) -- same
 * MOVE.L A4 / LEA <data>,A4 prologue, so this is also reached from a context
 * without the small-data base. Given it is a per-frame banner update that is
 * consistent with it running off an interrupt or a task rather than the main
 * loop.
 *
 * Reproduces: the active-flag gate, the target-reached case that clears both the
 * active flag and the step cursor from one zeroed register, the step budget
 * accounting where the cursor advances only while a budget is set and rolls over
 * into a delta adjustment, the candidate position, and the three-way snap test.
 *
 * The snap condition is the interesting shape. The original branches into a
 * shared tail from three different tests -- overshoot going negative, overshoot
 * going positive, and the degenerate case where both the delta and the budget are
 * zero -- which C cannot express as a jump into the middle of an if. Written as a
 * single disjunction:
 *
 *     if ((sign < 0 && cand < target)
 *         || (sign > 0 && cand > target)
 *         || (StepDelta == 0 && StepBudget == 0))
 *         delta = target - cur;
 *
 * it produces the same evaluation order and short-circuit structure, and the
 * whole function comes out within six bytes.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     (no frame)                 MOVEM only
 *   got:     594f 48e73f08              SUBQ.W #4,A7 / MOVEM
 *   summary: Reversed from the usual direction -- here SAS/C adds a four-byte
 *            stack adjustment the original does not need.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
extern short GCOMMAND_GetBannerChar(void);
extern void  GCOMMAND_AdjustBannerCopperOffset(long delta);
extern short SCRIPT_BannerTransitionActive;
extern unsigned char SCRIPT_BannerTransitionTargetChar;
extern short SCRIPT_BannerTransitionStepDelta;
extern short SCRIPT_BannerTransitionStepBudget;
extern short SCRIPT_BannerTransitionStepCursor;
extern short SCRIPT_BannerTransitionStepSign;

void __saveds SCRIPT_UpdateBannerCharTransition(void)
{
    register short cur;
    register short delta;
    register short cand;
    long target;
    short budget;
    short sign;

    if (SCRIPT_BannerTransitionActive == 0)
        return;

    cur = GCOMMAND_GetBannerChar();
    target = SCRIPT_BannerTransitionTargetChar;

    if (target == (long)cur) {
        SCRIPT_BannerTransitionStepCursor = SCRIPT_BannerTransitionActive = 0;
        return;
    }

    delta = SCRIPT_BannerTransitionStepDelta;
    budget = SCRIPT_BannerTransitionStepBudget;

    if ((unsigned short)budget > 0) {
        SCRIPT_BannerTransitionStepCursor++;
        if (SCRIPT_BannerTransitionStepCursor >= budget) {
            delta += SCRIPT_BannerTransitionStepSign;
            SCRIPT_BannerTransitionStepCursor = 0;
        }
    }

    cand = delta + cur;
    sign = SCRIPT_BannerTransitionStepSign;

    if ((sign < 0 && (long)cand < target)
        || (sign > 0 && (long)cand > target)
        || (SCRIPT_BannerTransitionStepDelta == 0
            && SCRIPT_BannerTransitionStepBudget == 0))
        delta = (short)(target - cur);

    GCOMMAND_AdjustBannerCopperOffset((long)delta);
}
