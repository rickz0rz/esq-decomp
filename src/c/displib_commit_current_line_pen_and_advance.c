/* RESTORES: DISPLIB_CommitCurrentLinePenAndAdvance
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: index-widening
 *   ref:     2f072e2f000870003039000080ced08041f9000080d0d1c04a5067103039000080ce2200524133c1000080ce3039000080ce3239000080ccb041641072003200e58141f9000080f8d1c120872e1f4e75
 *   got:     2f072e2f00083039000000004840424048402200d28141f900000000d1c14a50670a3200524133c100000000303900000000323900000000b04164144840424048402200e58141f900000000d1c120872e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short DISPTEXT_CurrentLineIndex, DISPTEXT_TargetLineIndex;
extern short DISPTEXT_LineLengthTable[];
extern long  DISPTEXT_LinePenTable[];

void DISPLIB_CommitCurrentLinePenAndAdvance(long pen)
{
    if (DISPTEXT_LineLengthTable[(unsigned short)DISPTEXT_CurrentLineIndex] != 0)
        DISPTEXT_CurrentLineIndex = DISPTEXT_CurrentLineIndex + 1;
    if ((unsigned short)DISPTEXT_CurrentLineIndex < (unsigned short)DISPTEXT_TargetLineIndex)
        DISPTEXT_LinePenTable[(unsigned short)DISPTEXT_CurrentLineIndex] = pen;
}
