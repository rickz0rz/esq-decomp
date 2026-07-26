/* RESTORES: ED_NextAdNumber
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     20390000860ab0b90000860e6c0c61d052b90000860a6100fe424e75
 *   got:     203900000000b0b9000000006c0e6100000052b900000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern long ED_MaxAdNumber;
extern void ED_CommitCurrentAdEdits(void);
extern void ED_LoadCurrentAdIntoBuffers(void);
void ED_NextAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER < ED_MaxAdNumber) {
        ED_CommitCurrentAdEdits();
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER += 1;
        ED_LoadCurrentAdIntoBuffers();
    }
}
