#include "esq_types.h"

/*
 * Target 268 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_GetBannerChar.
 */
void GCOMMAND_GetBannerChar(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void)
{
    GCOMMAND_GetBannerChar();
}
