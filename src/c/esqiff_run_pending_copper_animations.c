/* RESTORES: _ESQIFF_RunPendingCopperAnimations
 * MODULE:   modules/groups/a/n/esqiffbb.s
 * STATUS:   behavioural
 *
 * Drains four independent copper-animation countdowns, running each lane's step
 * function once per remaining tick. The lanes are drained in order and to
 * completion, not interleaved -- lane 0 runs to zero before lane 1 starts.
 *
 * The counters are unsigned: the original tests them with BLS against a
 * register-held zero, so a lane that somehow went negative would run 65535 times
 * rather than being skipped. Declaring them `short` would emit BLE and quietly
 * change that.
 *
 * Written as four separate while loops because that is what the original is --
 * the four counters are consecutive words but each lane calls a DIFFERENT step
 * function, so there is nothing to fold into a loop.
 *
 * 130 bytes in the original, 130 emitted, four differing hunks -- all four are
 * `4eba` against `6100` at the four cross-unit calls. Same shape as
 * esqiff_service_pending_copper_palette_moves.c in the same module: a whole
 * function with exactly one open class and nothing else.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100, four sites, 16 bytes of 130. The whole difference.
 */

extern void ESQIFF_JMPTBL_ESQ_NoOp_006A(void);
extern void ESQIFF_JMPTBL_ESQ_NoOp_0074(void);
extern void ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(void);
extern void ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(void);

extern unsigned short COPPER_AnimationLane0_Countdown;
extern unsigned short COPPER_AnimationLane1_Countdown;
extern unsigned short COPPER_AnimationLane2_Countdown;
extern unsigned short COPPER_AnimationLane3_Countdown;

void ESQIFF_RunPendingCopperAnimations(void)
{
    while (COPPER_AnimationLane0_Countdown > 0) {
        ESQIFF_JMPTBL_ESQ_NoOp_006A();
        COPPER_AnimationLane0_Countdown = COPPER_AnimationLane0_Countdown - 1;
    }

    while (COPPER_AnimationLane1_Countdown > 0) {
        ESQIFF_JMPTBL_ESQ_NoOp_0074();
        COPPER_AnimationLane1_Countdown = COPPER_AnimationLane1_Countdown - 1;
    }

    while (COPPER_AnimationLane2_Countdown > 0) {
        ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary();
        COPPER_AnimationLane2_Countdown = COPPER_AnimationLane2_Countdown - 1;
    }

    while (COPPER_AnimationLane3_Countdown > 0) {
        ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets();
        COPPER_AnimationLane3_Countdown = COPPER_AnimationLane3_Countdown - 1;
    }
}
