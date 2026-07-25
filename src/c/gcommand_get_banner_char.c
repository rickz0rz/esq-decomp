/* RESTORES: GCOMMAND_GetBannerChar
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc2b7c00002da8fffc7000206dfffc10104e5d4e75
 *   got:     2f0d4bf900000000700010152a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ESQ_CopperListBannerA;
long GCOMMAND_GetBannerChar(void)
{
    unsigned char *p = &ESQ_CopperListBannerA;
    return *p;
}
