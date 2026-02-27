#include "esq_types.h"

/*
 * Target 222 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_UpdateBannerBounds.
 */
void GCOMMAND_UpdateBannerBounds(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(void)
{
    GCOMMAND_UpdateBannerBounds();
}
