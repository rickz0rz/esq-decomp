/* RESTORES: LOCAVAIL_FreeNodeAtPointer
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008200b672e4aab00066722302b00044a406f1a48c02f002f2b00064878006a487900006ade4eba22924fef00102f0b61b0584f265f4e75
 *   got:     2f0d2a6f0008200d672e202d00066720322d00044a416f1848c12f012f004878006a487900000000610000004fef00102f0d61000000584f2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct LocAvailNode3 { char pad[4]; short count; long data; };
extern char Global_STR_LOCAVAIL_C_1[];
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, long ptr, long size);
extern void LOCAVAIL_FreeNodeRecord(struct LocAvailNode3 *n);
void LOCAVAIL_FreeNodeAtPointer(struct LocAvailNode3 *n)
{
    if (n == 0)
        return;
    if (n->data != 0 && n->count > 0)
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LOCAVAIL_C_1, 106,
                                               n->data, (long)n->count);
    LOCAVAIL_FreeNodeRecord(n);
}
