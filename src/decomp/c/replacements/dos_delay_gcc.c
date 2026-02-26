#include "esq_types.h"

/*
 * Target 047 GCC trial function.
 * Thin DOS Delay wrapper using Global_REF_DOS_LIBRARY_2 as library base.
 */
extern u32 Global_REF_DOS_LIBRARY_2;

void DOS_Delay(s32 ticks) __attribute__((noinline, used));

void DOS_Delay(s32 ticks)
{
    register u32 d1_in __asm__("d1") = (u32)ticks;

    __asm__ volatile(
        "movea.l %0,%%a6\n\t"
        "jsr _LVODelay(%%a6)\n\t"
        :
        : "g"(Global_REF_DOS_LIBRARY_2), "r"(d1_in)
        : "a6", "cc", "memory");
}
