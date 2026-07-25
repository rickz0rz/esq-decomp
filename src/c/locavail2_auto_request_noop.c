/* RESTORES: LOCAVAIL2_AutoRequestNoOp
 * MODULE:   modules/groups/a/z/locavail2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: unused-a4-setup
 *   ref:     2f0c49f9000080007000285f4e75
 *   got:     70004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char Global_REF_LONG_FILE_SCRATCH[];
long LOCAVAIL2_AutoRequestNoOp(void)
{
    return 0;
}
