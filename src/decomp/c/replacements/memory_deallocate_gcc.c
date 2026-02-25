#include "esq_types.h"

/*
 * Target 002 GCC trial function (deallocate half).
 * First mixed C pass:
 * - Keep guard/counter logic in C.
 * - Keep Exec FreeMem call in inline asm.
 */
extern u32 Global_MEM_BYTES_ALLOCATED;
extern u32 Global_MEM_DEALLOC_COUNT;

void MEMORY_DeallocateMemory(void *memory_block, u32 byte_size) __attribute__((noinline, used));

void MEMORY_DeallocateMemory(void *memory_block, u32 byte_size)
{
    register void *block_reg __asm__("a3") = memory_block;
    register u32 size_reg __asm__("d7") = byte_size;

    if (block_reg == 0 || size_reg == 0) {
        return;
    }

    {
        register void *a1_in __asm__("a1") = block_reg;
        register u32 d0_in __asm__("d0") = size_reg;

        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFreeMem(%%a6)\n\t"
            : "+r"(d0_in), "+r"(a1_in)
            :
            : "cc", "memory");
    }

    Global_MEM_BYTES_ALLOCATED -= size_reg;
    Global_MEM_DEALLOC_COUNT += 1;
}
