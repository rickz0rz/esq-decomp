/* RESTORES: ESQSHARED4_ApplyBannerColorStep
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * The common tail of the banner colour sweep. Five blocks in this module reach
 * it -- one by falling through, three by branch, one by BSR -- each having put
 * the next colour byte in D0. It writes that colour into the copper lists and
 * rebinds the banner work raster.
 *
 * IT IS ENTERED WITH THE COLOUR IN D0. `register __d0` states that; see
 * esq-banner.h for the A4 half.
 *
 * SASC-MISMATCH: dead-argument-load
 *   ref:     6100xxxx 323c0058 4eba xxxx   BSR / MOVE.W #$58,D1 / JSR
 *   got:     the two calls, with no D1 load between them
 *   summary: the original loads D1 with 0x58 before calling
 *            ESQSHARED4_BindAndClearBannerWorkRaster, and that callee never
 *            reads D1. Its entry is `MOVEM.L D0/A0-A1,-(A7)` followed by
 *            `LEA _WDISP_BannerWorkRasterPtr,A0`, and every register it touches
 *            is written before it is read. So the load is dead in the original
 *            and there is nothing for the C to reproduce. -4 bytes.
 *   tried:   giving the callee an ignored parameter, which would reproduce the
 *            load at the cost of a prototype contradicting its own
 *            restoration. AGENTS.md rule 1 says keep the honest declaration
 *            and record the divergence.
 *   scope:   one site.
 *   retest:  nothing to retest; it is a source-level choice, not codegen.
 */
#include "esq-banner.h"

extern void ESQSHARED4_BindAndClearBannerWorkRaster(void);

void __asm ESQSHARED4_ApplyBannerColorStep(register __d0 unsigned short colour)
{
    ESQSHARED4_SetBannerCopperColorAndThreshold(colour);
    ESQSHARED4_BindAndClearBannerWorkRaster();
}
