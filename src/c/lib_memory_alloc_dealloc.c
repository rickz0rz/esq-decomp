/* RESTORES: _MEMORY_AllocateMemory, _MEMORY_DeallocateMemory
 * MODULE:   modules/submodules/memory.s
 * STATUS:   behavioural
 *
 * SAS/C library code: AllocMem and FreeMem with running byte and call counters.
 *
 * THIS IS THE FUNCTION THAT FORCED THE VOLATILE LIBRARY-BASE HEADERS. AGENTS.md
 * and src/c/esq-libbase.md record it: the original loads AbsExecBase into A6 and
 * RETURNS WITHOUT RESTORING IT, so a C caller that had cached a different base in
 * A6 -- dos.library, say -- found exec there afterwards and its next
 * `JSR _LVOxxx(A6)` entered the wrong library. That is why every esq-*.h declares
 * its base `volatile`.
 *
 * Restoring it in C RETIRES THE HAZARD AT SOURCE. SAS/C saves and restores A6
 * around a library call, so this function no longer damages its caller's A6. The
 * volatile headers stay, because the rest of the assembly has not moved and
 * because they cost only a reload.
 *
 * THE ALLOCATION COUNTERS ARE BUMPED EVEN WHEN THE ALLOCATION FAILED. The
 * original adds the size and increments the count unconditionally after the call,
 * with no test of the result, so a run of failures inflates
 * Global_MEM_BYTES_ALLOCATED without any memory existing. The free path is not
 * symmetric: it tests BOTH the pointer and the size first and does nothing if
 * either is zero. So the two counters do not have to agree, and the byte total
 * can drift upward across a session. That is the original's behaviour and it is
 * reproduced -- a diagnostic screen reads these.
 *
 * THE FREE PATH REFUSES A ZERO SIZE as well as a null pointer. FreeMem with a
 * zero length is a no-op that would still have been counted.
 *
 * IT TAKES FOUR ARGUMENTS, NOT TWO, AND THE FIRST TWO ARE DIAGNOSTIC. Every
 * caller pushes a source-file string and a line number ahead of the size and the
 * flags -- `PEA _Global_STR_FLIB_C_1 / PEA 173.W / MOVE.L D1,-(A7) /
 * PEA MEMF_PUBLIC.W`. They are not read by either function here; they exist so a
 * leak report can name the allocation site.
 *
 * THE OFFSETS SAY SO AND THEY ARE EASY TO MISREAD. After `LINK.W A5,#-4`, 4(A5)
 * is the return address and 8(A5) is the FIRST argument, so the `16(A5)` and
 * `20(A5)` this function reads are the THIRD and FOURTH. A first draft of this
 * file took them for the first two, which made the size the address of a string
 * constant: the build produced 8 illegal-instruction lines, 43,585 log lines and
 * one frame of Amiga content out of ten. Check a caller, or an existing
 * declaration -- src/c/brush_alloc_brush_node.c already had the right one.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     MOVEA.L AbsExecBase,A6, four bytes, and A6 left damaged
 *   got:     MOVEA.L _SysBase,A6, six bytes, with A6 saved and restored
 *   summary: the volatile header costs 2 bytes per site and one save/restore
 *            pair per function. It is what makes the call safe.
 *   scope:   program-wide. See src/c/esq-libbase.md.
 *   retest:  not a compiler question; it is the header contract.
 */
#include "esq-exec.h"

extern long Global_MEM_BYTES_ALLOCATED;
extern long Global_MEM_ALLOC_COUNT;
extern long Global_MEM_DEALLOC_COUNT;

void *MEMORY_AllocateMemory(char *who, long line, long size, long requirements)
{
    void *p = (void *)AllocMem((ULONG)size, (ULONG)requirements);

    /* Counted whether or not the allocation succeeded -- see the header. */
    Global_MEM_BYTES_ALLOCATED += size;
    Global_MEM_ALLOC_COUNT++;

    return p;
}

void MEMORY_DeallocateMemory(char *who, long line, void *block, long size)
{
    if (block == 0 || size == 0)
        return;

    FreeMem((APTR)block, (ULONG)size);

    Global_MEM_BYTES_ALLOCATED -= size;
    Global_MEM_DEALLOC_COUNT++;
}
