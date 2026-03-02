#include "esq_types.h"

/*
 * Target 288 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_UpdateRefreshModeState.
 */
void ESQFUNC_UpdateRefreshModeState(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(void)
{
    ESQFUNC_UpdateRefreshModeState();
}
