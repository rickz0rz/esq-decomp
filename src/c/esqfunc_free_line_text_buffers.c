/* RESTORES: ESQFUNC_FreeLineTextBuffers
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f077e007014be406c3a200748c0e58041f90000a24cd1c04878003c2f10487804d34879000054504eba270e4fef0010200748c0e58041f90000a24cd1c04290524760c02e1f4e75
 *   got:     2f077e007014be406c3a48c72007e58041f900000000d1c04878003c2f10487804d3487900000000610000004fef001048c72007e58041f900000000d1c04290524760c02e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *LADFUNC_LineTextBufferPtrs[];
extern char  Global_STR_ESQFUNC_C_6[];
extern void  MEMORY_DeallocateMemory(char *who, long line, char *p, long size);
void ESQFUNC_FreeLineTextBuffers(void)
{
    short i;

    for (i = 0; i < 20; i++) {
        MEMORY_DeallocateMemory(Global_STR_ESQFUNC_C_6, 1235,
                                              LADFUNC_LineTextBufferPtrs[i], 60);
        LADFUNC_LineTextBufferPtrs[i] = 0;
    }
}
