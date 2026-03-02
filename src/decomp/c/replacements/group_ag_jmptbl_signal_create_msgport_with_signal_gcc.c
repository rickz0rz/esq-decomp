#include "esq_types.h"

/*
 * Target 281 GCC trial function.
 * Jump-table stub forwarding to SIGNAL_CreateMsgPortWithSignal.
 */
void SIGNAL_CreateMsgPortWithSignal(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(void)
{
    SIGNAL_CreateMsgPortWithSignal();
}
