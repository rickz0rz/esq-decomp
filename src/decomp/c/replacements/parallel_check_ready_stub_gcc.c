#include "esq_types.h"

/*
 * Target 052 GCC trial function.
 * Stub readiness probe that always returns -1.
 */
s32 PARALLEL_CheckReadyStub(void) __attribute__((noinline, used));

s32 PARALLEL_CheckReadyStub(void)
{
    return -1;
}
