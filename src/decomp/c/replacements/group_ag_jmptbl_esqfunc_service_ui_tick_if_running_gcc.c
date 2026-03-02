#include "esq_types.h"

/*
 * Target 284 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_ServiceUiTickIfRunning.
 */
void ESQFUNC_ServiceUiTickIfRunning(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void)
{
    ESQFUNC_ServiceUiTickIfRunning();
}
