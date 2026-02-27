#include "esq_types.h"

/*
 * Target 226 GCC trial function.
 * Jump-table stub forwarding to ESQDISP_DrawStatusBanner.
 */
void ESQDISP_DrawStatusBanner(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(void)
{
    ESQDISP_DrawStatusBanner();
}
