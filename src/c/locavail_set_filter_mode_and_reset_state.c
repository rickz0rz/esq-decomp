/* RESTORES: LOCAVAIL_SetFilterModeAndResetState
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f072e2f0008203900006accb087671a7001be8067044a87661023c700006acc48790000b3cc61b8584f2e1f4e75
 *   got:     2f072e2f0008203900000000b087671c7001be8067044a87661223c70000000048790000000061000000584f2e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long LOCAVAIL_FilterModeFlag;
extern char LOCAVAIL_PrimaryFilterState[];
extern void LOCAVAIL_ResetFilterCursorState(char *st);
void LOCAVAIL_SetFilterModeAndResetState(long mode)
{
    if (LOCAVAIL_FilterModeFlag == mode)
        return;
    if (mode != 1 && mode != 0)
        return;
    LOCAVAIL_FilterModeFlag = mode;
    LOCAVAIL_ResetFilterCursorState(LOCAVAIL_PrimaryFilterState);
}
