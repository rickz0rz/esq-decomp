#include "esq_types.h"

/*
 * Target 147 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_FormatEntryTime.
 */
void TEXTDISP_FormatEntryTime(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime(void)
{
    TEXTDISP_FormatEntryTime();
}
