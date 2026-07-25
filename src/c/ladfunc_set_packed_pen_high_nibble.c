/* RESTORES: LADFUNC_SetPackedPenHighNibble
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     48e723001e2f00131c2f001770001007720fc081e98074001406c48180824cdf00c44e75
 *   got:     48e723001c2f00171e2f001370001007720fc081e98074001406c48180824cdf00c44e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long LADFUNC_SetPackedPenHighNibble(unsigned char high, unsigned char low)
{
    return (((long)high & 15) << 4) | ((long)low & 15);
}
