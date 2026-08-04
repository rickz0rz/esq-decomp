/* RESTORES: ESQSHARED4_ClampBannerColorAtSweepEnd
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Clamps the banner colour to 0x8a when a plane pointer has come back to its
 * reset value, or when the sweep has run past 0xf6. It does the test twice --
 * once for the snapshot destination and once for the sweep source -- and each
 * arm writes its own clamp value plus the shared threshold.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and it is DEAD: it sits after
 * an unreachable RTS. The name is OURS. Its epilogue is the module's only
 * other exported label, ESQSHARED4_ApplyBannerColorStep_Return, which is a
 * `_Return` fragment rather than a function -- refbytes.py measures it as zero
 * bytes and nothing references it.
 *
 * THE CLAMP VALUES ARE WRITTEN AS WORDS AND SET SOMETHING ELSE TOO. The
 * original uses `MOVE.W #$8a,_ESQ_BannerColorClampValueA` where
 * ESQSHARED4_SetBannerColorBaseAndLimit writes the same symbol with MOVE.B.
 * ESQ_BannerColorClampValueA is ONE BYTE of storage read as two -- it is one of
 * the eight adjacency cases AGENTS.md lists, a "byte pair" -- so this word
 * write also lands on the byte that follows it. Declaring it `unsigned char`
 * here would write half of what the original writes and pass every byte check,
 * which is the extern-width failure mode. It is declared `unsigned short`.
 *
 * The two arms are NOT symmetric in their exit: the first falls into the
 * second, and the second's `<` test branches to the epilogue rather than past
 * a block. Written as two independent ifs, which is the same control flow.
 *
 * SASC-MISMATCH: caller-saves
 *   ref:     48e7c020 ... 4cdf0403   MOVEM.L D0-D1/A2 around a body that
 *            never touches A2
 *   got:     no MOVEM
 *   summary: the original saves three registers it does not all use. Compiled
 *            C saves what it uses. -8 bytes.
 *   scope:   several blocks in this module.
 *   retest:  nothing to retest.
 */
extern short ESQ_BannerPlane0DstPtrReset_LoWord;
extern short ESQ_BannerSnapshotPlane0DstPtrLoWord;
extern short ESQ_BannerSweepSrcPlane0PtrReset_LoWord;
extern short ESQ_BannerSweepSrcPlane0Ptr_LoWord;
extern short ESQPARS2_BannerColorBaseValue;
extern unsigned short ESQ_BannerColorClampValueA;
extern unsigned short ESQ_BannerColorClampValueB;
extern short ESQPARS2_BannerColorClampThreshold;

void ESQSHARED4_ClampBannerColorAtSweepEnd(void)
{
    if (ESQ_BannerSnapshotPlane0DstPtrLoWord == ESQ_BannerPlane0DstPtrReset_LoWord
        || ESQPARS2_BannerColorBaseValue >= 0xf6) {
        ESQ_BannerColorClampValueA = 0x8a;
        ESQPARS2_BannerColorClampThreshold = 0x8a;
    }

    if (ESQ_BannerSweepSrcPlane0Ptr_LoWord == ESQ_BannerSweepSrcPlane0PtrReset_LoWord
        || ESQPARS2_BannerColorBaseValue >= 0xf6) {
        ESQ_BannerColorClampValueB = 0x8a;
        ESQPARS2_BannerColorClampThreshold = 0x8a;
    }
}
