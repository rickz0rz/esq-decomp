#include "esq_types.h"

/*
 * Target 210 GCC trial function.
 * Jump-table stub forwarding to ESQIFF_DeallocateAdsAndLogoLstData.
 */
void ESQIFF_DeallocateAdsAndLogoLstData(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(void)
{
    ESQIFF_DeallocateAdsAndLogoLstData();
}
