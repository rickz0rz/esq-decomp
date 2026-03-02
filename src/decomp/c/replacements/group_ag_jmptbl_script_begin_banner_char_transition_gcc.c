#include "esq_types.h"

/*
 * Target 285 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_BeginBannerCharTransition.
 */
void SCRIPT_BeginBannerCharTransition(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(void)
{
    SCRIPT_BeginBannerCharTransition();
}
