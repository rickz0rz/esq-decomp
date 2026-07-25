/* RESTORES: ESQSHARED4_ClearBannerWorkRasterWithOnes
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dbf-loop
 *   ref:     43f9000087aa2051223c0000014920fcffffffff51c9fff84e75
 *   got:     48e701042a79000000003e3c014970ff2ac0200753474a4066f44cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned long *WDISP_BannerWorkRasterPtr;
void ESQSHARED4_ClearBannerWorkRasterWithOnes(void)
{
    unsigned long *p = WDISP_BannerWorkRasterPtr;
    short n = 0x149;

    do {
        *p++ = 0xFFFFFFFFL;
    } while (n--);
}
