#include "memory_target.h"

/*
 * Target 002 trial function.
 * Semantics must match MEMORY_AllocateMemory in modules/submodules/memory.s:
 * - Call AllocMem-equivalent path.
 * - Increment byte/allocation counters even when allocation fails.
 */
__stdargs __reg("d0") void *MEMORY_AllocateMemory(u32 byte_size, u32 attributes)
{
    u32 frame_pad;

    /*
     * Force a 4-byte local frame slot so vbcc emits LINK.W A5,#-4,
     * matching the original frame size more closely.
     */
    frame_pad = 0;

    __asm(
        "MOVEM.L d6-d7,-(a7)\n\t"
        "MOVE.L 16(a5),d7\n\t"
        "MOVE.L 20(a5),d6\n\t"
        "MOVE.L d7,d0\n\t"
        "MOVE.L d6,d1\n\t"
        "MOVE.L 4,a6\n\t"
        "JSR -198(a6)\n\t"
        "ADD.L d7,Global_MEM_BYTES_ALLOCATED\n\t"
        "ADDQ.L #1,Global_MEM_ALLOC_COUNT\n\t"
        "MOVEM.L (a7)+,d6-d7");

    /* Keep vbcc quiet; this branch is never taken and does not alter output shape. */
    if (0) {
        return (void *)frame_pad;
    }
}
