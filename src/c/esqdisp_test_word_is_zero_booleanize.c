/* RESTORES: ESQDISP_TestWordIsZeroBooleanize
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: booleanize-shape
 *   ref:     2f073e2f000a4a4757c04400488048c02e0020072e1f4e75
 *   got:     48e703003e2f000e4a4757c04400488048c02c0020064cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long ESQDISP_TestWordIsZeroBooleanize(short value)
{
    long r = (value == 0);
    return r;
}
