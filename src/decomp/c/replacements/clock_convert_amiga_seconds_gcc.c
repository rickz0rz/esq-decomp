#include "esq_types.h"

/*
 * Target 003 GCC trial function.
 * Keep this as a pure assembly body so GCC does not add C-level logic noise.
 */
void CLOCK_ConvertAmigaSecondsToClockData(void) __attribute__((noinline, used));

void CLOCK_ConvertAmigaSecondsToClockData(void)
{
    __asm__ volatile(
        "move.l %a6,-(%sp)\n\t"
        "movea.l Global_REF_UTILITY_LIBRARY,%a6\n\t"
        "movem.l 8(%sp),%d0/%a0\n\t"
        "jsr _LVOAmiga2Date(%a6)\n\t"
        "movea.l (%sp)+,%a6\n\t"
        "rts\n\t");
    __builtin_unreachable();
}
