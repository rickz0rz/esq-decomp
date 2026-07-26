/* RESTORES: P_TYPE_EnsureSecondaryList
 * MODULE:   modules/groups/b/a/p_typeb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4ab90000b4e067264ab90000b4e4661e2f390000b4e02f390000b4e46188504f23c00000b4e4204010b9000087b64e75
 *   got:     2f0d203900000000672022390000000066182f002f016100000023c000000000504f2a401ab9000000002a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;
extern void *P_TYPE_CloneEntry(void *dst, void *src);
extern unsigned char TEXTDISP_SecondaryGroupCode;
void P_TYPE_EnsureSecondaryList(void)
{
    unsigned char *p;

    if (P_TYPE_PrimaryGroupListPtr == 0)
        return;
    if (P_TYPE_SecondaryGroupListPtr != 0)
        return;
    P_TYPE_SecondaryGroupListPtr = P_TYPE_CloneEntry(P_TYPE_SecondaryGroupListPtr,
                                                     P_TYPE_PrimaryGroupListPtr);
    p = (unsigned char *)P_TYPE_SecondaryGroupListPtr;
    *p = TEXTDISP_SecondaryGroupCode;
}
