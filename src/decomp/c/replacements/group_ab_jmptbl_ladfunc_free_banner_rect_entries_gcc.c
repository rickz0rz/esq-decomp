#include "esq_types.h"

/*
 * Target 211 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_FreeBannerRectEntries.
 */
void LADFUNC_FreeBannerRectEntries(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(void)
{
    LADFUNC_FreeBannerRectEntries();
}
