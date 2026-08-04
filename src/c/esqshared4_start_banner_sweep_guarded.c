/* RESTORES: ESQSHARED4_StartBannerSweepGuarded
 * MODULE:   modules/groups/a/q/esqshared4.s   (1 of its 2 blocks)
 * STATUS:   behavioural
 *
 * Resets the banner sweep state and restarts the colour sweep from its first
 * colour, with the entry guard armed at 1 rather than cleared.
 *
 * THE DISASSEMBLY ALREADY CALLED THIS DEAD -- the comment above it reads
 * `; Dead code.` -- and the block carried no label until 2026-08-04. The name
 * is OURS.
 *
 * IT DIFFERS FROM ITS SIBLING IN THREE PLACES, and the third is the point.
 * esqshared4_start_banner_sweep_from_config_head.c clears both guards and
 * starts at the configured head byte; this one arms the entry guard at 1,
 * leaves the delay counter alone, and enters through
 * ESQSHARED4_ResetBannerColorToStart, which starts at the fixed colour 0x19.
 *
 * THE D0 LOAD BEFORE THE FIRST CALL IS DEAD IN THE ORIGINAL TOO. See the
 * sibling's header for the full note: the callee's first instruction is
 * `MOVEQ #0,D0`.
 *
 * SASC-MISMATCH: dead-argument-load
 *   summary: -6 bytes for a load nothing can read. Itemised in
 *            esqshared4_start_banner_sweep_from_config_head.c.
 *   scope:   two sites in this module.
 *   retest:  nothing to retest.
 *
 * SASC-MISMATCH: caller-saves
 *   summary: -8 bytes; the original saves D0-D1/A0-A4 around a body that uses
 *            none of them.
 *   scope:   several dead blocks in this cluster.
 *   retest:  nothing to retest.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorStepCounter;
extern short ESQPARS2_BannerSweepEntryGuardCounter;
extern void  ESQSHARED4_ResetBannerColorSweepState(void);

void ESQSHARED4_StartBannerSweepGuarded(void)
{
    ESQSHARED4_ResetBannerColorSweepState();
    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQPARS2_BannerSweepEntryGuardCounter = 1;
    ESQSHARED4_ResetBannerColorToStart();
}
