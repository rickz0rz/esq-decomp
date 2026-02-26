#include "esq_types.h"

/*
 * Target 048 GCC trial function.
 * Read seconds from battery-backed clock resource.
 */
extern u32 Global_REF_BATTCLOCK_RESOURCE;

u32 BATTCLOCK_GetSecondsFromBatteryBackedClock(void) __attribute__((noinline, used));

u32 BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    register u32 d0_out __asm__("d0");

    __asm__ volatile(
        "movea.l %1,%%a6\n\t"
        "jsr _LVOReadBattClock(%%a6)\n\t"
        : "=r"(d0_out)
        : "g"(Global_REF_BATTCLOCK_RESOURCE)
        : "a6", "cc", "memory");

    return d0_out;
}
