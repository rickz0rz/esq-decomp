#include "esq_types.h"

/*
 * Target 269 GCC trial function.
 * Jump-table stub forwarding to ESQPARS_ApplyRtcBytesAndPersist.
 */
void ESQPARS_ApplyRtcBytesAndPersist(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(void)
{
    ESQPARS_ApplyRtcBytesAndPersist();
}
