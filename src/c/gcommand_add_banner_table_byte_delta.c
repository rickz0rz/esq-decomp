/* RESTORES: GCOMMAND_AddBannerTableByteDelta
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70110266f000c1e2f0013df134cdf08804e75
 *   got:     48e701041e2f00132a6f000cdf154cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
void GCOMMAND_AddBannerTableByteDelta(unsigned char *slot, unsigned char delta)
{
    *slot += delta;
}
