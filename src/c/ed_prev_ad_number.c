/* RESTORES: ED_PrevAdNumber
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     0cb90000000100006f0c61b653b90000860a6100fe284e75
 *   got:     0cb900000001000000006f0e6100000053b900000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern void ED_CommitCurrentAdEdits(void);
extern void ED_LoadCurrentAdIntoBuffers(void);
void ED_PrevAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER > 1) {
        ED_CommitCurrentAdEdits();
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER -= 1;
        ED_LoadCurrentAdIntoBuffers();
    }
}
