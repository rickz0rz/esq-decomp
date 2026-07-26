/* RESTORES: DISPLIB_ResetTextBufferAndLineTables
 * MODULE:   modules/groups/a/i/displibb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     2f390000807842a74ebac08423c000008078618a504f4e75
 *   got:     2f390000000042a76100000023c00000000061000000504f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *DISPTEXT_TextBufferPtr;
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newv, char *old);
extern void  DISPLIB_ResetLineTables(void);
void DISPLIB_ResetTextBufferAndLineTables(void)
{
    DISPTEXT_TextBufferPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, DISPTEXT_TextBufferPtr);
    DISPLIB_ResetLineTables();
}
