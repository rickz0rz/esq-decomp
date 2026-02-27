#include "esq_types.h"

/*
 * Target 149 GCC trial function.
 * Jump-table stub forwarding to TLIBA3_GetViewModeRastPort.
 */
s32 TLIBA3_GetViewModeRastPort(void) __attribute__((noinline));

s32 GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort(void) __attribute__((noinline, used));

s32 GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort(void)
{
    return TLIBA3_GetViewModeRastPort();
}
