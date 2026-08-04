/* RESTORES: ESQSHARED4_RestartBannerColorSweep
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Seeds the sweep back to its first colour. It is instruction-for-instruction
 * the same block as ESQSHARED4_ResetBannerColorToStart, twenty bytes further
 * down the module -- the original carries the sequence twice, once falling
 * through into the common tail and once branching to it.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and it is DEAD: its only way in
 * would be a fall-through from the BRA.S above it, which is terminal. The name
 * is OURS.
 *
 * A LONE RTS FOLLOWS IT, after the BRA.W, and is unreachable for the same
 * reason. It has no C counterpart and none is needed: two bytes of an
 * unreachable return.
 *
 * SASC-MISMATCH: fall-through-becomes-call
 *   ref:     the block ends in BRA.W ESQSHARED4_ApplyBannerColorStep
 *   got:     a call and a return
 *   summary: +2 bytes and one stack frame for the duration. A tail branch is
 *            not expressible in SAS/C 6.51; AGENTS.md screens the shape as
 *            `tail-jump`.
 *   scope:   two sites in this module.
 *   retest:  needs a compiler that can emit a tail jump.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorStepCounter;

void ESQSHARED4_RestartBannerColorSweep(void)
{
    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQSHARED4_ApplyBannerColorStep(0x19);
}
