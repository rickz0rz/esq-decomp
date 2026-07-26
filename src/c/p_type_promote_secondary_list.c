/* RESTORES: P_TYPE_PromoteSecondaryList
 * MODULE:   modules/groups/b/a/p_typeb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     2f390000b4e06100ff12584f23f90000b4e4000042b90000b4e44e75
 *   got:     2f390000000061000000584f23f9000000000000000042b9000000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;
extern void  P_TYPE_FreeEntry(void *e);
void P_TYPE_PromoteSecondaryList(void)
{
    P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr);
    P_TYPE_PrimaryGroupListPtr = P_TYPE_SecondaryGroupListPtr;
    P_TYPE_SecondaryGroupListPtr = 0;
}
