/* RESTORES: DISPTEXT_FinalizeLineTable
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     4ab90000815066363039000080ce33c0000080cc72003200d28141f9000080d0d1c14a506708524033c0000080cc487800016100ff46584f4279000080ce4e75
 *   got:     2f074ab900000000663c3e390000000033c70000000030074840424048402200d28141f900000000d1c14a506708524733c7000000004878000161000000584f4279000000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  DISPTEXT_LineTableLockFlag;
extern short DISPTEXT_CurrentLineIndex, DISPTEXT_TargetLineIndex;
extern short DISPTEXT_LineLengthTable[];
extern void  DISPTEXT_BuildLinePointerTable(long mode);
void DISPTEXT_FinalizeLineTable(void)
{
    short idx;

    if (DISPTEXT_LineTableLockFlag != 0)
        return;
    idx = DISPTEXT_CurrentLineIndex;
    DISPTEXT_TargetLineIndex = idx;
    if (DISPTEXT_LineLengthTable[(unsigned short)idx] != 0) {
        idx++;
        DISPTEXT_TargetLineIndex = idx;
    }
    DISPTEXT_BuildLinePointerTable(1);
    DISPTEXT_CurrentLineIndex = 0;
}
