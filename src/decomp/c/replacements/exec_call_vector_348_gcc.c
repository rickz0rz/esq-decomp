#include "esq_types.h"

/*
 * Target 035 GCC trial function.
 * Preserve wrapper behavior for Exec vector call at LVO -348.
 */
void EXEC_CallVector_348(void) __attribute__((noinline, used));

void EXEC_CallVector_348(void)
{
    __asm__ volatile(
        "movem.l %d2-%d3/%a2-%a3/%a6,-(%sp)\n\t"
        "movea.l 24(%sp),%a0\n\t"
        "movea.l 28(%sp),%a1\n\t"
        "movea.l 32(%sp),%a2\n\t"
        "movea.l 36(%sp),%a3\n\t"
        "move.l 40(%sp),%d0\n\t"
        "move.l 44(%sp),%d1\n\t"
        "move.l 48(%sp),%d2\n\t"
        "move.l 52(%sp),%d3\n\t"
        "jsr _LVOFreeTrap(%a6)\n\t"
        "movem.l (%sp)+,%d2-%d3/%a2-%a3/%a6\n\t"
        "rts\n\t");
    __builtin_unreachable();
}
