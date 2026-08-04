/* RESTORES: ED1_EnterEscMenu_AfterVersionText
 * MODULE:   modules/groups/a/k/ed1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: epilogue-fragment
 *   ref:     48790000b3cc4eba02904ced0084ffc84e5d4e75
 *   got:     48790000000061000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char ED_EditBufferLive[];
extern void LOCAVAIL_ResetFilterCursorState(char *st);
extern char LOCAVAIL_PrimaryFilterState[];
void ED1_EnterEscMenu_AfterVersionText(void)
{
    LOCAVAIL_ResetFilterCursorState(LOCAVAIL_PrimaryFilterState);
}
