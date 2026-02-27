#include "esq_types.h"

/*
 * Target 148 GCC trial function.
 * Jump-table stub forwarding to TLIBA3_GetViewModeHeight.
 */
s32 TLIBA3_GetViewModeHeight(void) __attribute__((noinline));

s32 GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight(void) __attribute__((noinline, used));

s32 GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight(void)
{
    return TLIBA3_GetViewModeHeight();
}
