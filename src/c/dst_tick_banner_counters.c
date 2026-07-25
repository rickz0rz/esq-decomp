/* RESTORES: DST_TickBannerCounters
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     70001039000028d90440003633c00000a2c4323900009ab05341660a2200534133c10000a2c430390000a3205340660e30390000a2c4524033c00000a2c44e75
 *   got:     2f077e001e390000000070369e80200733c00000000032390000000053416608538033c00000000032390000000053416608524033c0000000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ESQ_STR_6;
extern short WDISP_BannerCharPhaseShift;
extern short DST_PrimaryCountdown;
extern short DST_SecondaryCountdown;
void DST_TickBannerCounters(void)
{
    long phase = ESQ_STR_6;

    phase -= 0x36;
    WDISP_BannerCharPhaseShift = (short)phase;
    if ((short)(DST_PrimaryCountdown - 1) == 0)
        WDISP_BannerCharPhaseShift = (short)(phase - 1);
    if ((short)(DST_SecondaryCountdown - 1) == 0)
        WDISP_BannerCharPhaseShift = WDISP_BannerCharPhaseShift + 1;
}
