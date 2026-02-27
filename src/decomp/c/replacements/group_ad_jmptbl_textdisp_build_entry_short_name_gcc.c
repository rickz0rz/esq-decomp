#include "esq_types.h"

/*
 * Target 154 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_BuildEntryShortName.
 */
void TEXTDISP_BuildEntryShortName(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName(void)
{
    TEXTDISP_BuildEntryShortName();
}
