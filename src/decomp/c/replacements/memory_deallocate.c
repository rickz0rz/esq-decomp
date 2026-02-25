#include "memory_target.h"

/*
 * Target 002 trial function (second half).
 * Semantics must match MEMORY_DeallocateMemory in modules/submodules/memory.s:
 * - Return early when ptr==0 or size==0.
 * - FreeMem path updates counters only when both checks pass.
 */
void MEMORY_DeallocateMemory(void *memory_block, u32 byte_size)
{
    __asm(
        "MOVEM.L d7/a3,-(a7)\n\t"
        "MOVEA.L 16(a5),a3\n\t"
        "MOVE.L 20(a5),d7\n\t"
        "MOVE.L a3,d0\n\t"
        "BEQ.S .return\n\t"
        "TST.L d7\n\t"
        "BEQ.S .return\n\t"
        "MOVEA.L a3,a1\n\t"
        "MOVE.L d7,d0\n\t"
        "MOVEA.L 4,a6\n\t"
        "JSR -210(a6)\n\t"
        "SUB.L d7,Global_MEM_BYTES_ALLOCATED\n\t"
        "ADDQ.L #1,Global_MEM_DEALLOC_COUNT\n"
        ".return:\n\t"
        "MOVEM.L (a7)+,d7/a3");
}
