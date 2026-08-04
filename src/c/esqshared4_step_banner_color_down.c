/* RESTORES: ESQSHARED4_StepBannerColorDown
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Moves the banner colour one step DOWN the sweep, or restarts the sweep when
 * it reaches the end marker.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and it is DEAD: it sits after
 * ESQSHARED4_SetBannerCopperColorAndThreshold's RTS, so nothing reaches it by
 * name or by fall-through. The name is OURS. Its mirror image is
 * esqshared4_step_banner_color_up.c, which differs in three places: it uses
 * the DELAY counter rather than the GUARD counter, it ADDS one to the step
 * counter rather than subtracting, and it steps the colour down rather than up.
 *
 * THE GUARD DECREMENT IS TESTED TWICE AND MEANS ONE THING. The original does
 * SUBI.W, then BNE to a second test, then BPL past the body -- so the clamp
 * runs only when the result is neither zero nor positive. `if (--g < 0)` is
 * that, because a negative result cannot be zero. The two-branch spelling is
 * the assembler's, not a second condition.
 *
 * THE END TEST IS ON THE BYTE, NOT THE WORD. The original reads the head byte
 * zero-extended, adds one as a WORD, and then compares with CMPI.B -- so a
 * head of 0xff steps to 0x100 and the test sees 0x00, not 0x100. The cast is
 * written out.
 *
 * THE LAST STATEMENT IS THE FALL-THROUGH. When the end marker is reached the
 * original runs straight on into ESQSHARED4_ResetBannerColorToStart, so the
 * call has to be last for merge_module_c.py's bridge check. The early return
 * in the other arm is what keeps it there.
 *
 * SASC-MISMATCH: read-modify-write-on-memory
 *   summary: the original decrements both counters straight in memory with
 *            SUBI.W, and SAS/C emits a load, a subtract and a store. Two
 *            sites.
 *   scope:   program-wide.
 *   retest:  a compiler that emits SUBI.W #n,abs.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorBaseValue;
extern short ESQPARS2_BannerColorThreshold;
extern short ESQPARS2_BannerSweepEntryGuardCounter;
extern short ESQPARS2_BannerColorStepCounter;
extern unsigned char ESQ_CopperListBannerA[];
extern void ESQ_NoOp(void);

void ESQSHARED4_StepBannerColorDown(void)
{
    unsigned short next;

    if ((short)(ESQPARS2_BannerColorBaseValue - 2) < ESQPARS2_BannerColorThreshold)
        return;

    if (--ESQPARS2_BannerSweepEntryGuardCounter < 0) {
        ESQPARS2_BannerSweepEntryGuardCounter = 0;
        ESQ_NoOp();
    }

    ESQPARS2_BannerColorStepCounter -= 1;

    next = (unsigned short)(ESQ_CopperListBannerA[0] + 1);
    if ((unsigned char)next != 0xf6) {
        ESQSHARED4_ApplyBannerColorStep(next);
        return;
    }
    ESQSHARED4_ResetBannerColorToStart();
}
