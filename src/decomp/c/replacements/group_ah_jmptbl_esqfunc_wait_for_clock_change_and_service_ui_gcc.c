#include "esq_types.h"

/*
 * Target 251 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_WaitForClockChangeAndServiceUi.
 */
void ESQFUNC_WaitForClockChangeAndServiceUi(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void)
{
    ESQFUNC_WaitForClockChangeAndServiceUi();
}
