#include "esq_types.h"

/*
 * Target 054 GCC trial function.
 * Thin wrapper around PARALLEL_CheckReadyStub.
 */
s32 PARALLEL_CheckReadyStub(void);
s32 PARALLEL_CheckReady(void) __attribute__((noinline, used));

s32 PARALLEL_CheckReady(void)
{
    return PARALLEL_CheckReadyStub();
}
