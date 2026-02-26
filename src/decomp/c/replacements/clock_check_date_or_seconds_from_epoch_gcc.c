#include "esq_types.h"

/*
 * Target 057 GCC trial function.
 * utility.library CheckDate wrapper.
 */
extern u32 Global_REF_UTILITY_LIBRARY;

s32 CLOCK_CheckDateOrSecondsFromEpoch(void *clock_data) __attribute__((noinline, used));

s32 CLOCK_CheckDateOrSecondsFromEpoch(void *clock_data)
{
    register void *a0_in __asm__("a0") = clock_data;
    register s32 d0_out __asm__("d0");

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOCheckDate(%%a6)\n\t"
        : "=r"(d0_out), "+r"(a0_in)
        : "0"(0), "g"(Global_REF_UTILITY_LIBRARY)
        : "a6", "cc", "memory");

    return d0_out;
}
