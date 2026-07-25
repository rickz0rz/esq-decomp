/* RESTORES: LOCAVAIL_GetFilterWindowHalfSpan
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f077001b0b900006acc6612303900006adc6f0448c06002701e2e0060027e1ee247524720072e1f4e75
 *   got:     2f077001b0b90000000066123239000000006f063e0148c760067e1e60027e1ee287528720072e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  LOCAVAIL_FilterModeFlag;
extern short LOCAVAIL_FilterWindowHalfSpan;
long LOCAVAIL_GetFilterWindowHalfSpan(void)
{
    long span;

    if (LOCAVAIL_FilterModeFlag == 1) {
        if (LOCAVAIL_FilterWindowHalfSpan > 0)
            span = LOCAVAIL_FilterWindowHalfSpan;
        else
            span = 30;
    } else {
        span = 30;
    }
    span >>= 1;
    span += 1;
    return span;
}
