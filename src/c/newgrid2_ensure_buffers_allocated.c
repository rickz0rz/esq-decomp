/* RESTORES: NEWGRID2_EnsureBuffersAllocated
 * MODULE:   modules/groups/b/a/newgrid2_p1.s
 * STATUS:   behavioural
 *
 * Allocates the two NEWGRID scratch buffers once and clears the flag that
 * asked for them. Note the sense: the work runs when the flag is NON-zero
 * (TST.L / BEQ skips the body), and the flag is cleared at the end, so it is a
 * request rather than a done-marker.
 *
 * The two allocation sizes and the two source-line numbers are literals in the
 * original (1208 at line 4153, 1000 at line 4156), which is how the tracking
 * allocator records the caller. They are reproduced exactly.
 *
 * The original writes MEMF_PUBLIC+MEMF_CLEAR as one long, 0x00010001, and
 * reuses the same stack slot for the second call rather than re-pushing.
 * That is SAS/C's argument-area reuse and needs nothing from the source.
 *
 * 84 ref vs 84 got, and per AGENTS.md that alone is not evidence of fidelity --
 * so here is the structure. Every instruction agrees in kind, order and size
 * except the two items below. Both PEA constants, both allocation sizes, both
 * line numbers, the shared 0x00010001 flag word, the argument-area reuse
 * (2ebc00010001) and the single LEA 28(A7),A7 cleanup all match exactly.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba23c6 / 4eba23a4      JSR (d16,PC)
 *   got:     61000000 / 61000000      BSR.W
 *   summary: the original reaches a callee in another translation unit with
 *            JSR (d16,PC); 6.51 emits BSR.W for every call whoever the callee
 *            is. Same size, same displacement, same semantics, different
 *            opcode. This is the single class that caps the largest number of
 *            otherwise-clean restorations at behavioural.
 *   scope:   every cross-unit restoration in the tree.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit", and the isolated probe
 *            esqiff_handle_brush_ini_reload_hotkey.c.
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 *
 * SASC-MISMATCH: store-before-stack-cleanup
 *   ref:     4fef001c 42b9... 23c0...  LEA 28(A7),A7 / CLR.L flag / MOVE.L D0,ptr
 *   got:     23c0... 4fef001c 42b9...  MOVE.L D0,ptr / LEA 28(A7),A7 / CLR.L flag
 *   summary: the original keeps the returned pointer live in D0 across the
 *            stack cleanup and stores it last; 6.51 stores it first. Same three
 *            instructions, same bytes, different order.
 *   tried:   assigning the result through an explicit local, so the store would
 *            follow the flag clear in source order. That is WORSE, not better:
 *            6.51 allocates the local to A5 and the function grows to 92 bytes
 *            (2f0d / 2a40 / 23cd / 2a5f added). Reverted.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/memory.h>
#include "esq-exec.h"

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void  NEWGRID_RebuildIndexCache(void);

extern long   NEWGRID2_BufferAllocationFlag;
extern void  *NEWGRID_SecondaryIndexCachePtr;
extern void  *NEWGRID_EntryTextScratchPtr;
extern char   Global_STR_NEWGRID2_C_3[];
extern char   Global_STR_NEWGRID2_C_4[];

void NEWGRID2_EnsureBuffersAllocated(void)
{
    if (NEWGRID2_BufferAllocationFlag) {
        NEWGRID_SecondaryIndexCachePtr = MEMORY_AllocateMemory(
            Global_STR_NEWGRID2_C_3, 4153L, 1208L, MEMF_PUBLIC | MEMF_CLEAR);
        NEWGRID_RebuildIndexCache();
        NEWGRID_EntryTextScratchPtr = MEMORY_AllocateMemory(
            Global_STR_NEWGRID2_C_4, 4156L, 1000L, MEMF_PUBLIC | MEMF_CLEAR);
        NEWGRID2_BufferAllocationFlag = 0;
    }
}
