#include "esq_types.h"

/*
 * Target 241 GCC trial function.
 * Jump-table stub forwarding to ESQIFF2_ApplyIncomingStatusPacket.
 */
void ESQIFF2_ApplyIncomingStatusPacket(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(void)
{
    ESQIFF2_ApplyIncomingStatusPacket();
}
