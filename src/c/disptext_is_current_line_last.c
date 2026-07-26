/* RESTORES: DISPTEXT_IsCurrentLineLast
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: booleanize-shape
 *   ref:     2f026100f9943039000080ce3239000080ccb04157c24402488248c22002241f4e75
 *   got:     48e7210061000000303900000000323900000000b04157c24402488248c22e0220074cdf00844e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void  DISPTEXT_FinalizeLineTable(void);
extern short DISPTEXT_CurrentLineIndex, DISPTEXT_TargetLineIndex;
long DISPTEXT_IsCurrentLineLast(void)
{
    long same;
    DISPTEXT_FinalizeLineTable();
    same = (DISPTEXT_CurrentLineIndex == DISPTEXT_TargetLineIndex);
    return same;
}
