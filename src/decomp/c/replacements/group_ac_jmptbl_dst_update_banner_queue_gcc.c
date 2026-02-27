#include "esq_types.h"

/*
 * Target 227 GCC trial function.
 * Jump-table stub forwarding to DST_UpdateBannerQueue.
 */
void DST_UpdateBannerQueue(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_DST_UpdateBannerQueue(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_DST_UpdateBannerQueue(void)
{
    DST_UpdateBannerQueue();
}
