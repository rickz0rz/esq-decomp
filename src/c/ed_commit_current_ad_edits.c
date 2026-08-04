/* RESTORES: ED_CommitCurrentAdEdits
 * MODULE:   modules/groups/a/l/ed3bbb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     20390000860a53804879000084604879000082f82f004eba01cc4fef000c4e75
 *   got:     20390000000053804879000000004879000000002f00610000004fef000c4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern char ED_EditBufferLive[], ED_EditBufferScratch[];
extern void LADFUNC_UpdateEntryFromTextAndAttrBuffers(long idx, char *a, char *b);
void ED_CommitCurrentAdEdits(void)
{
    LADFUNC_UpdateEntryFromTextAndAttrBuffers(
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER - 1,
        ED_EditBufferScratch, ED_EditBufferLive);
}
