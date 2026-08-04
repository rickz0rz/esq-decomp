/* RESTORES: ESQSHARED4_ReapplyBannerCopperColor
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Re-runs the copper-word writes with the colour that is already in the banner
 * head, which repairs the seven derived words without stepping the sweep.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and it is DEAD: it sits after
 * ESQSHARED4_ApplyBannerColorStep's RTS, so nothing reaches it by name or by
 * fall-through. The name is OURS.
 *
 * ITS ENTRY MOVEM IS THE INTERESTING PART. It saves D2-D7 and A2-A6, which its
 * own three-instruction body never touches. That is a clobber list for its
 * callee, in the sense AGENTS.md describes -- "a saved register a function
 * appears not to use is a message about its callees". Compiled C saves what it
 * uses and no more, which is correct here because the callee is now C as well
 * and honours the standard convention.
 *
 * SASC-MISMATCH: caller-saves-callee-clobbers
 *   ref:     48e73c3e ... 4cdf7c3c   MOVEM.L D2-D7/A2-A6 around three
 *            instructions
 *   got:     no MOVEM at all
 *   summary: the original saves eleven registers against a hand-written
 *            callee that does not honour the convention. Its callee is now
 *            compiled C, so the saves are unnecessary and SAS/C omits them.
 *            -8 bytes, and strictly safer rather than merely smaller.
 *   scope:   several callers of the register-argument family.
 *   retest:  nothing to retest; it follows from the callee being C.
 */
#include "esq-banner.h"

extern unsigned char ESQ_CopperListBannerA[];

void ESQSHARED4_ReapplyBannerCopperColor(void)
{
    ESQSHARED4_SetBannerCopperColorAndThreshold(ESQ_CopperListBannerA[0]);
}
