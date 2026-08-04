/* RESTORES: ESQSHARED4_StartBannerSweepFromConfigHead
 * MODULE:   modules/groups/a/q/esqshared4.s   (1 of its 2 blocks)
 * STATUS:   behavioural
 *
 * Resets the banner sweep state and starts the colour sweep at the head byte
 * the INI file configured, with both step guards cleared.
 *
 * THE DISASSEMBLY ALREADY CALLED THIS DEAD -- the module's first line is the
 * comment `; Dead code` -- and the block carried no label until 2026-08-04.
 * Adding it is byte-neutral and test-hash.sh confirms it. The name is OURS,
 * chosen from what the block does. Its sibling in the same module is
 * esqshared4_start_banner_sweep_guarded.c.
 *
 * THE D0 LOAD BEFORE THE FIRST CALL IS DEAD IN THE ORIGINAL TOO, and it is not
 * reproduced. `MOVE.W _ESQSHARED_BannerColorModeWord,D0` is followed by
 * `BSR.S _ESQSHARED4_ResetBannerColorSweepState`, whose first instruction is
 * `MOVEQ #0,D0`. So the value cannot be read. Reproducing it would mean
 * declaring the callee with a parameter it does not have, which contradicts its
 * own restoration.
 *
 * The `LEA _ESQ_CopperListBannerA,A4` before the second call is the A4 setup
 * that esq-banner.h folds away. See that header.
 *
 * SASC-MISMATCH: dead-argument-load
 *   ref:     3039<mode> 61xx   the mode word loaded into D0, then a call that
 *            immediately clears D0
 *   got:     the call alone
 *   summary: -6 bytes for a load nothing can read. Same class as the D1 load
 *            in esqshared4_apply_banner_color_step.c.
 *   scope:   two sites in this module.
 *   retest:  nothing to retest; it is a source-level choice.
 *
 * SASC-MISMATCH: caller-saves
 *   ref:     48e7c0f8 ... 4cdf1f03   MOVEM.L D0-D1/A0-A4 around a body whose
 *            only register use is the A4 setup
 *   got:     no MOVEM
 *   summary: -8 bytes. Compiled C saves what it uses.
 *   scope:   several dead blocks in this cluster.
 *   retest:  nothing to retest.
 */
#include "esq-banner.h"

extern short ESQPARS2_BannerColorStepCounter;
extern short ESQPARS2_BannerSweepEntryGuardCounter;
extern short ESQPARS2_BannerSweepDelayCounter;
extern short CONFIG_BannerCopperHeadByte;
extern void  ESQSHARED4_ResetBannerColorSweepState(void);

void ESQSHARED4_StartBannerSweepFromConfigHead(void)
{
    ESQSHARED4_ResetBannerColorSweepState();
    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQPARS2_BannerSweepEntryGuardCounter = 0;
    ESQPARS2_BannerSweepDelayCounter = 0;
    ESQSHARED4_ApplyBannerColorStep(CONFIG_BannerCopperHeadByte);
}
