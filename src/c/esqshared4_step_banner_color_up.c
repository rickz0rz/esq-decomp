/* RESTORES: ESQSHARED4_StepBannerColorUp
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Moves the banner colour one step UP the sweep. It is the mirror of
 * esqshared4_step_banner_color_down.c and differs in three places: the DELAY
 * counter rather than the GUARD counter, an ADD on the step counter rather
 * than a subtract, and one subtracted from the head byte rather than added.
 *
 * IT HAS NO END TEST, which is the fourth difference and the one worth
 * noticing. The downward direction checks for the 0xf6 marker and restarts;
 * this one branches to the common tail unconditionally. So the two are not
 * symmetric, whatever the names suggest.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and it is DEAD: it sits after
 * ESQSHARED4_ReapplyBannerCopperColor's RTS. The name is OURS.
 *
 * SASC-MISMATCH: read-modify-write-on-memory
 *   summary: the original decrements and increments the counters straight in
 *            memory, and SAS/C emits a load, an add and a store. Two sites.
 *            Same item as the downward sibling.
 *   scope:   program-wide.
 *   retest:  a compiler that emits ADDI.W/SUBI.W with a memory destination.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorBaseValue;
extern short ESQPARS2_BannerColorThreshold;
extern short ESQPARS2_BannerSweepDelayCounter;
extern short ESQPARS2_BannerColorStepCounter;
extern unsigned char ESQ_CopperListBannerA[];
extern void ESQ_NoOp(void);

void ESQSHARED4_StepBannerColorUp(void)
{
    unsigned short next;

    if ((short)(ESQPARS2_BannerColorBaseValue - 2) < ESQPARS2_BannerColorThreshold)
        return;

    if (--ESQPARS2_BannerSweepDelayCounter < 0) {
        ESQPARS2_BannerSweepDelayCounter = 0;
        ESQ_NoOp();
    }

    ESQPARS2_BannerColorStepCounter += 1;

    next = (unsigned short)(ESQ_CopperListBannerA[0] - 1);
    ESQSHARED4_ApplyBannerColorStep(next);
}
