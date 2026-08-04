/* RESTORES: NEWGRID2_FreeBuffersIfAllocated
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4ab90000b4586740487803e82f390000b45848781044487900006d104eba236042b90000b458487804b82f3900006c1c48781047487900006d1c4eba23424fef002042b900006c1c4e75
 *   got:     203900000000673c487803e82f00487810444879000000006100000042b900000000487804b82f390000000048781047487900000000610000004fef002042b9000000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *NEWGRID_EntryTextScratchPtr;
extern char *NEWGRID_SecondaryIndexCachePtr;
extern char  Global_STR_NEWGRID2_C_5[], Global_STR_NEWGRID2_C_6[];
extern void  MEMORY_DeallocateMemory(char *who, long line, char *p, long size);
void NEWGRID2_FreeBuffersIfAllocated(void)
{
    if (NEWGRID_EntryTextScratchPtr == 0)
        return;
    MEMORY_DeallocateMemory(Global_STR_NEWGRID2_C_5, 4164,
                                          NEWGRID_EntryTextScratchPtr, 1000);
    NEWGRID_EntryTextScratchPtr = 0;
    MEMORY_DeallocateMemory(Global_STR_NEWGRID2_C_6, 4167,
                                          NEWGRID_SecondaryIndexCachePtr, 1208);
    NEWGRID_SecondaryIndexCachePtr = 0;
}
