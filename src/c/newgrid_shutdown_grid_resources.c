/* RESTORES: NEWGRID_ShutdownGridResources
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4ab900006ba4671c487800642f3900006ba448780094487900006bd64eba10f84fef00104eba6c0c4eba10f8427900006bac4eba4f164e75
 *   got:     2039000000006718487800642f0048780094487900000000610000004fef00106100000061000000427900000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long NEWGRID_MainRastPortPtr;
extern char Global_STR_NEWGRID_C_3[];
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, long ptr, long size);
extern void NEWGRID2_FreeBuffersIfAllocated(void);
extern void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void);
extern void NEWGRID_ResetShowtimeBuckets(void);
extern short NEWGRID_GridResourcesInitializedFlag;
void NEWGRID_ShutdownGridResources(void)
{
    if (NEWGRID_MainRastPortPtr != 0)
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_NEWGRID_C_3, 148,
                                               NEWGRID_MainRastPortPtr, 100);
    NEWGRID2_FreeBuffersIfAllocated();
    NEWGRID_JMPTBL_DISPTEXT_FreeBuffers();
    NEWGRID_GridResourcesInitializedFlag = 0;
    NEWGRID_ResetShowtimeBuckets();
}
