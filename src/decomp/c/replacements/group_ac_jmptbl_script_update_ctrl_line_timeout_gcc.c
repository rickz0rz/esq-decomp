#include "esq_types.h"

/*
 * Target 223 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_PollHandshakeAndApplyTimeout.
 */
void SCRIPT_PollHandshakeAndApplyTimeout(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout(void)
{
    SCRIPT_PollHandshakeAndApplyTimeout();
}
