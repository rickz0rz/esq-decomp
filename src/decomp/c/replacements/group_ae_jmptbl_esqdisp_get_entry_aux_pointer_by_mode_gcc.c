#include "esq_types.h"

/*
 * Target 233 GCC trial function.
 * Jump-table stub forwarding to ESQDISP_GetEntryAuxPointerByMode.
 */
void ESQDISP_GetEntryAuxPointerByMode(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(void)
{
    ESQDISP_GetEntryAuxPointerByMode();
}
