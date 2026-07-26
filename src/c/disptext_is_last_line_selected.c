/* RESTORES: DISPTEXT_IsLastLineSelected
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: booleanize-shape
 *   ref:     2f026100f9bc70003039000080cc538072003239000080ceb28057c24402488248c22002241f4e75
 *   got:     48e7070061000000303900000000720032002e0153873039000000007c003c00bc8757c04400488048c02a0020054cdf00e04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void  DISPTEXT_FinalizeLineTable(void);
extern short DISPTEXT_TargetLineIndex, DISPTEXT_CurrentLineIndex;
long DISPTEXT_IsLastLineSelected(void)
{
    long last, cur, same;

    DISPTEXT_FinalizeLineTable();
    last = (unsigned short)DISPTEXT_TargetLineIndex - 1;
    cur  = (unsigned short)DISPTEXT_CurrentLineIndex;
    same = (cur == last);
    return same;
}
