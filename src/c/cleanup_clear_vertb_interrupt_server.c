/* RESTORES: CLEANUP_ClearVertbInterruptServer
 * MODULE:   modules/groups/a/b/cleanup.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     70052279000086e22c7800044eaeff52487800162f39000086e2487800394879000002784eba62cc4fef00104e75
 *   got:     2f0e22790000000070052c7800044eaeff52487800162f390000000048780039487900000000610000004fef00102c5f4e75
 *   summary: Uses #pragma libcall so the OS call encoding matches; the residual is A6 in the MOVEM masks. See the os-library-call section of docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <proto/exec.h>
extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern char Global_STR_CLEANUP_C_1[];
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
void CLEANUP_ClearVertbInterruptServer(void)
{
    RemIntServer(5, Global_REF_INTERRUPT_STRUCT_INTB_VERTB);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_1, 57,
                                            Global_REF_INTERRUPT_STRUCT_INTB_VERTB, 22);
}
