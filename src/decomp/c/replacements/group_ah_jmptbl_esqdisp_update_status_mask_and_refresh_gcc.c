#include "esq_types.h"

/*
 * Target 244 GCC trial function.
 * Jump-table stub forwarding to ESQDISP_UpdateStatusMaskAndRefresh.
 */
void ESQDISP_UpdateStatusMaskAndRefresh(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(void)
{
    ESQDISP_UpdateStatusMaskAndRefresh();
}
