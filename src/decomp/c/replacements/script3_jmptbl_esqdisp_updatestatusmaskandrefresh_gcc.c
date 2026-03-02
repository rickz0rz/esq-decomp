#include "esq_types.h"

void ESQDISP_UpdateStatusMaskAndRefresh(void) __attribute__((noinline));

void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(void) __attribute__((noinline, used));

void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(void)
{
    ESQDISP_UpdateStatusMaskAndRefresh();
}
