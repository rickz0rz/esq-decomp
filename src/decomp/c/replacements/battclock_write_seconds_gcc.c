#include "esq_types.h"

/*
 * Target 049 GCC trial function.
 * Write seconds to battery-backed clock resource.
 */
extern u32 Global_REF_BATTCLOCK_RESOURCE;

u32 BATTCLOCK_WriteSecondsToBatteryBackedClock(u32 seconds) __attribute__((noinline, used));

u32 BATTCLOCK_WriteSecondsToBatteryBackedClock(u32 seconds)
{
    register u32 d0_in __asm__("d0") = seconds;

    __asm__ volatile(
        "movea.l %0,%%a6\n\t"
        "jsr _LVOWriteBattClock(%%a6)\n\t"
        : "+r"(d0_in)
        : "g"(Global_REF_BATTCLOCK_RESOURCE)
        : "a6", "cc", "memory");

    return d0_in;
}
