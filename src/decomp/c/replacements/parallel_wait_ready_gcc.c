#include "esq_types.h"

/*
 * Target 058 GCC trial function.
 * Busy-wait until PARALLEL_CheckReady reports non-negative.
 */
s32 PARALLEL_CheckReady(void);
void PARALLEL_WaitReady(void) __attribute__((noinline, used));

void PARALLEL_WaitReady(void)
{
    while (PARALLEL_CheckReady() < 0) {
    }
}
