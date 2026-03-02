#include "esq_types.h"

/*
 * Target 624 GCC trial function.
 * Query Exec fast-memory bytes and set low-memory guard flag when under threshold.
 */
extern u32 AbsExecBase;
extern s16 HAS_REQUESTED_FAST_MEMORY;

u32 ESQ_CheckAvailableFastMemory(void) __attribute__((noinline, used));

u32 ESQ_CheckAvailableFastMemory(void)
{
    register u32 d0_in __asm__("d0");
    register u32 d1_in __asm__("d1") = 2;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOAvailMem(%%a6)\n\t"
        : "=r"(d0_in), "+r"(d1_in)
        : "1"(d1_in), "g"(AbsExecBase)
        : "a6", "cc", "memory");

    if (d0_in < 600000u) {
        HAS_REQUESTED_FAST_MEMORY = 1;
    }

    return d0_in;
}
