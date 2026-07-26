/* RESTORES: LOCAVAIL_RebuildFilterStateFromCurrentGroup
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48790000b3cc6100f12848790000b3e448790000b3cc6100f1ba48790000b3e46100f10e4fef00101039000087ba530013c00000b3e448790000b3cc6100f242584f4e75
 *   got:     487900000000610000004879000000004879000000006100000048790000000061000000103900000000530013c000000000487900000000610000004fef00144e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char LOCAVAIL_PrimaryFilterState[], LOCAVAIL_SecondaryFilterState[];
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern void LOCAVAIL_FreeResourceChain(char *st);
extern void LOCAVAIL_CopyFilterStateStructRetainRefs(char *dst, char *src);
extern void LOCAVAIL_ResetFilterCursorState(char *st);
void LOCAVAIL_RebuildFilterStateFromCurrentGroup(void)
{
    LOCAVAIL_FreeResourceChain(LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_CopyFilterStateStructRetainRefs(LOCAVAIL_PrimaryFilterState,
                                             LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_FreeResourceChain(LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_SecondaryFilterState[0] = (char)(TEXTDISP_PrimaryGroupCode - 1);
    LOCAVAIL_ResetFilterCursorState(LOCAVAIL_PrimaryFilterState);
}
