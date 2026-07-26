/* RESTORES: LOCAVAIL_SyncSecondaryFilterForCurrentGroup
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     10390000b3e41239000087b6b001673810390000b3cc1239000087bab001662848790000b3e46100f15248790000b3cc48790000b3e46100f1e44fef000c13f9000087b600004e75
 *   got:     103900000000123900000000b200673a103900000000123900000000b200662a48790000000061000000487900000000487900000000610000004fef000c10390000000013c0000000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char LOCAVAIL_PrimaryFilterState[], LOCAVAIL_SecondaryFilterState[];
extern unsigned char TEXTDISP_PrimaryGroupCode, TEXTDISP_SecondaryGroupCode;
extern void LOCAVAIL_FreeResourceChain(char *st);
extern void LOCAVAIL_CopyFilterStateStructRetainRefs(char *dst, char *src);
void LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void)
{
    if (LOCAVAIL_SecondaryFilterState[0] == (char)TEXTDISP_SecondaryGroupCode)
        return;
    if (LOCAVAIL_PrimaryFilterState[0] != (char)TEXTDISP_PrimaryGroupCode)
        return;
    LOCAVAIL_FreeResourceChain(LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_CopyFilterStateStructRetainRefs(LOCAVAIL_SecondaryFilterState,
                                             LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_SecondaryFilterState[0] = (char)TEXTDISP_SecondaryGroupCode;
}
