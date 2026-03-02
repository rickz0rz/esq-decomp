#include "esq_types.h"

/*
 * Target 283 GCC trial function.
 * Jump-table stub forwarding to IOSTDREQ_CleanupSignalAndMsgport.
 */
void IOSTDREQ_CleanupSignalAndMsgport(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void)
{
    IOSTDREQ_CleanupSignalAndMsgport();
}
