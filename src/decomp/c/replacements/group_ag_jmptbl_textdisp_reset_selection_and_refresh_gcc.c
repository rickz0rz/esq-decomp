#include "esq_types.h"

/*
 * Target 282 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_ResetSelectionAndRefresh.
 */
void TEXTDISP_ResetSelectionAndRefresh(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void)
{
    TEXTDISP_ResetSelectionAndRefresh();
}
