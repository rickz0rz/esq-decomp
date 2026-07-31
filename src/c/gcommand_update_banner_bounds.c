/* RESTORES: GCOMMAND_UpdateBannerBounds
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p0.s
 * STATUS:   behavioural
 *
 * Stores four banner bounds, derives a step for each, and raises the rebuild
 * flag under Disable/Enable.
 *
 * The step base is 17 when the UI is IDLE and 0 when it is busy -- the BEQ at
 * 0x1BF20 lands on the MOVEQ #17, so a ZERO flag gives 17. Reading the flag as
 * "busy means 17" inverts the animation speed.
 *
 * The base is computed once and parked in a frame slot, then written back into
 * the argument area before each of the remaining three calls (MOVE.L -4(A5),(A7)
 * three times) rather than recomputed. That is the reserved-A5 spill class.
 *
 * The flag store sits BETWEEN Disable and Enable, which is the whole point of
 * the pair -- it is a word write that must not be seen half-done by the
 * interrupt that reads it.
 *
 * 158 ref vs 164 got. All four bound stores, all four step stores, the
 * MOVEQ #17 base, all four increment calls with their argument-slot reuse, the
 * MOVE.W #1 flag store and both exec LVO offsets (ff88 Disable, ff82 Enable)
 * match in kind and size.
 *
 * SASC-MISMATCH: a6-reload-between-adjacent-library-calls
 *   ref:     2c780004 4eaeff88 ... 4eaeff82
 *            AbsExecBase loaded once, kept across Disable and Enable
 *   got:     2c79.... 4eaeff88 ... 2c79.... 4eaeff82
 *            reloaded before each
 *   summary: the volatile exec base reloads before both calls where the
 *            original caches it across the adjacent pair -- 6 bytes. Nothing
 *            between them can clobber A6, so the cache is safe and the reload
 *            is our artifact. Same class as
 *            parseini_test_memory_and_open_topaz_font.c, and closing it would
 *            need the esq-exec-leaf.h that AGENTS.md declines to provide.
 *   scope:   every function making two adjacent exec calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"

extern long GCOMMAND_ComputePresetIncrement(long bound, long base);

extern long  GCOMMAND_BannerBoundLeft;
extern long  GCOMMAND_BannerBoundTop;
extern long  GCOMMAND_BannerBoundRight;
extern long  GCOMMAND_BannerBoundBottom;
extern long  GCOMMAND_BannerStepLeft;
extern long  GCOMMAND_BannerStepTop;
extern long  GCOMMAND_BannerStepRight;
extern long  GCOMMAND_BannerStepBottom;
extern short GCOMMAND_BannerRebuildPendingFlag;
extern short Global_UIBusyFlag;

void GCOMMAND_UpdateBannerBounds(long left, long top, long right, long bottom)
{
    long base;

    GCOMMAND_BannerBoundLeft   = left;
    GCOMMAND_BannerBoundTop    = top;
    GCOMMAND_BannerBoundRight  = right;
    GCOMMAND_BannerBoundBottom = bottom;

    base = Global_UIBusyFlag ? 0 : 17;

    GCOMMAND_BannerStepLeft   = GCOMMAND_ComputePresetIncrement(left, base);
    GCOMMAND_BannerStepTop    = GCOMMAND_ComputePresetIncrement(top, base);
    GCOMMAND_BannerStepRight  = GCOMMAND_ComputePresetIncrement(right, base);
    GCOMMAND_BannerStepBottom = GCOMMAND_ComputePresetIncrement(bottom, base);

    Disable();
    GCOMMAND_BannerRebuildPendingFlag = 1;
    Enable();
}
