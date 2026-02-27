#include "esq_types.h"

/*
 * Target 234 GCC trial function.
 * Jump-table stub forwarding to ESQDISP_GetEntryPointerByMode.
 */
void ESQDISP_GetEntryPointerByMode(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(void)
{
    ESQDISP_GetEntryPointerByMode();
}
