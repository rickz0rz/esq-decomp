/* RESTORES: ESQSHARED4_ResetBannerColorToStart
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Seeds the sweep back to its first colour. This is the ONE live entry point
 * in the whole of esqshared4_p5.s: ESQSHARED4_ResetBannerColorSweepState calls
 * it, and so does esqshared4_reset_banner_color_sweep_state.c. Everything else
 * in the module is reached only from dead blocks.
 *
 * THE ORIGINAL FALLS THROUGH into ESQSHARED4_ApplyBannerColorStep, with 0x19
 * in D0 and the copper-list pointer in A4. The call below is that fall-through
 * written down, which is what lets merge_module_c.py join the module -- the
 * check requires it to be the LAST statement. See ed1_enter_esc_menu.c, where
 * the same bridge is used and explained at length.
 *
 * The `LEA _ESQ_CopperListBannerA,A4` this block performs is the A4 setup that
 * esq-banner.h folds away, so it has no counterpart here.
 *
 * SASC-MISMATCH: fall-through-becomes-call
 *   ref:     the block ends at MOVE.W #$19,D0 and runs on into the next label
 *   got:     a call and a return
 *   summary: +2 bytes and one stack frame for the duration. The alternative is
 *            to leave the module in assembly.
 *   scope:   two sites in this module, and one in ed1_p0.s.
 *   retest:  needs a compiler that can emit a tail jump; SAS/C 6.51 cannot.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorStepCounter;

void ESQSHARED4_ResetBannerColorToStart(void)
{
    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQSHARED4_ApplyBannerColorStep(0x19);
}
