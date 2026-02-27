#include "esq_types.h"

/*
 * Target 162 GCC trial function.
 * Jump-table stub forwarding to DST_ComputeBannerIndex.
 */
void DST_ComputeBannerIndex(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_DST_ComputeBannerIndex(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_DST_ComputeBannerIndex(void)
{
    DST_ComputeBannerIndex();
}
