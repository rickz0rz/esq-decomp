/* RESTORES: SCRIPT_GetBannerCharOrFallback
 * MODULE:   modules/groups/b/a/script4b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f0710390000cd9b7264b001670672001200600a700010390000cd9722002e0120072e1f4e75
 *   got:     2f071039000000007264b001660a7e001e390000000060047e001e0020072e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char TEXTDISP_BannerCharSelected;
extern unsigned char TEXTDISP_BannerCharFallback;
long SCRIPT_GetBannerCharOrFallback(void)
{
    long c;
    if (TEXTDISP_BannerCharSelected == 100)
        c = TEXTDISP_BannerCharFallback;
    else
        c = TEXTDISP_BannerCharSelected;
    return c;
}
