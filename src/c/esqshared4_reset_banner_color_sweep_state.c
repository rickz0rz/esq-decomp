/* RESTORES: ESQSHARED4_ResetBannerColorSweepState
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-store-order
 *   ref:     700013fc00f600002fc413fc00f600004388303c00f5d079000006180440008033c000005e8833fc006200005e9033fc000100005e7c61000cb04e75
 *   got:     2f0770f613c00000000013c0000000003039000000003e000647007533c70000000033fc00620000000033fc000100000000610000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ESQ_CopperBannerTailListA, ESQ_CopperBannerTailListB;
extern short CONFIG_BannerCopperHeadByte;
extern short ESQPARS2_BannerTailBiasValue;
extern short ESQPARS2_BannerColorStepCounter;
extern short ESQPARS2_BannerSweepEntryGuardCounter;
extern void  ESQSHARED4_ResetBannerColorToStart(void);
void ESQSHARED4_ResetBannerColorSweepState(void)
{
    short bias;

    ESQ_CopperBannerTailListA = 0xf6;
    ESQ_CopperBannerTailListB = 0xf6;
    bias = 0xf5 + CONFIG_BannerCopperHeadByte - 0x80;
    ESQPARS2_BannerTailBiasValue = bias;
    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQPARS2_BannerSweepEntryGuardCounter = 1;
    ESQSHARED4_ResetBannerColorToStart();
}
