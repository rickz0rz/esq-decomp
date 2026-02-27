#include "esq_types.h"

/*
 * Target 156 GCC trial function.
 * Jump-table stub forwarding to ESQIFF_RunCopperDropTransition.
 */
void ESQIFF_RunCopperDropTransition(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition(void)
{
    ESQIFF_RunCopperDropTransition();
}
