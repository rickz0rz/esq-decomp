#include "esq_types.h"

/*
 * Target 104 GCC trial function.
 * Jump-table stub forwarding to SIGNAL_CreateMsgPortWithSignal.
 */
void *SIGNAL_CreateMsgPortWithSignal(void *port_name, s32 port_pri) __attribute__((noinline));

void *GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(void *port_name, s32 port_pri) __attribute__((noinline, used));

void *GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(void *port_name, s32 port_pri)
{
    return SIGNAL_CreateMsgPortWithSignal(port_name, port_pri);
}
