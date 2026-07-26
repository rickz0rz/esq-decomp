/* RESTORES: DISPTEXT_HasMultipleLines
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     6100f9de3039000080ce66103039000080cc7200b04163047001600270004e75
 *   got:     610000003039000000006704700060123039000000007200b04162047000600270014e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void  DISPTEXT_FinalizeLineTable(void);
extern short DISPTEXT_CurrentLineIndex, DISPTEXT_TargetLineIndex;
long DISPTEXT_HasMultipleLines(void)
{
    DISPTEXT_FinalizeLineTable();
    if (DISPTEXT_CurrentLineIndex != 0)
        return 0;
    if ((unsigned short)DISPTEXT_TargetLineIndex <= 0)
        return 0;
    return 1;
}
