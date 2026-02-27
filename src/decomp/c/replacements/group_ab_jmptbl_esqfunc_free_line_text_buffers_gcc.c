#include "esq_types.h"

/*
 * Target 209 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_FreeLineTextBuffers.
 */
void ESQFUNC_FreeLineTextBuffers(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(void)
{
    ESQFUNC_FreeLineTextBuffers();
}
