/* RESTORES: P_TYPE_FreeEntry
 * MODULE:   modules/groups/b/a/p_type.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008200b673a4aab0006671c202b00022f002f2b00064878005c487900006d4a4eba21544fef00104878000a2f0b4878005f487900006d544eba213c4fef0010265f4e75
 *   got:     2f0d2a6f0008200d6736202d000667182f2d00022f004878005c487900000000610000004fef00104878000a2f0d4878005f487900000000610000004fef00102a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct PTypeEntry { char pad[2]; long size; char *data; };
extern char Global_STR_P_TYPE_C_4[], Global_STR_P_TYPE_C_5[];
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
void P_TYPE_FreeEntry(struct PTypeEntry *e)
{
    if (e == 0)
        return;
    if (e->data != 0)
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_4, 92, e->data, e->size);
    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_5, 95, e, 10);
}
