/* RESTORES: SCRIPT_DeallocateBufferArray
 * MODULE:   modules/groups/b/a/script.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70710266f00143e2f001a3c2f001e7a00ba466c30200548c0e580220748c12f012f330800487801954879000070ae4eba01184fef0010200548c0e58042b30800524560cc4cdf08e04e75
 *   got:     48e707043c2f001e3e2f001a2a6f00147a00ba466c3048c52005e580320748c12f012f35080048780195487900000000610000004fef001048c52005e58042b50800524560cc4cdf20e04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char Global_STR_SCRIPT_C_2[];
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
void SCRIPT_DeallocateBufferArray(void **arr, short size, short count)
{
    short i;

    for (i = 0; i < count; i++) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_SCRIPT_C_2, 405, arr[i], (long)size);
        arr[i] = 0;
    }
}
