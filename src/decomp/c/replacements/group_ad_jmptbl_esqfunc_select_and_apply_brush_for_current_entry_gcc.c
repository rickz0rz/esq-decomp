#include "esq_types.h"

/*
 * Target 161 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_SelectAndApplyBrushForCurrentEntry.
 */
void ESQFUNC_SelectAndApplyBrushForCurrentEntry(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry(void)
{
    ESQFUNC_SelectAndApplyBrushForCurrentEntry();
}
