#include "esq_types.h"

/*
 * Target 153 GCC trial function.
 * Jump-table stub forwarding to ESQIFF_RunCopperRiseTransition.
 */
void ESQIFF_RunCopperRiseTransition(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition(void)
{
    ESQIFF_RunCopperRiseTransition();
}
