#include "esq_types.h"

/*
 * Target 228 GCC trial function.
 * Jump-table stub forwarding to DST_RefreshBannerBuffer.
 */
void DST_RefreshBannerBuffer(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_DST_RefreshBannerBuffer(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_DST_RefreshBannerBuffer(void)
{
    DST_RefreshBannerBuffer();
}
