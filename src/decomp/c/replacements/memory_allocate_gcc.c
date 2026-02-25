#include "esq_types.h"

/*
 * Target 002 GCC trial function.
 * First mixed C pass:
 * - Keep counter updates in C.
 * - Keep Exec AllocMem call in inline asm.
 */
extern u32 Global_MEM_BYTES_ALLOCATED;
extern u32 Global_MEM_ALLOC_COUNT;

void *MEMORY_AllocateMemory(u32 byte_size, u32 attributes) __attribute__((noinline, used));

void *MEMORY_AllocateMemory(u32 byte_size, u32 attributes)
{
    register u32 d0_ret __asm__("d0") = byte_size;
    register u32 d1_in __asm__("d1") = attributes;

    __asm__ volatile(
        "movea.l 4.w,%%a6\n\t"
        "jsr _LVOAllocMem(%%a6)\n\t"
        : "+r"(d0_ret)
        : "r"(d1_in)
        : "a6", "cc", "memory");

    Global_MEM_BYTES_ALLOCATED += byte_size;
    Global_MEM_ALLOC_COUNT += 1;
    return (void *)d0_ret;
}
