#include "esq_types.h"

/*
 * Target 267 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_FormatEntryTimeForIndex.
 */
void TEXTDISP_FormatEntryTimeForIndex(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(void)
{
    TEXTDISP_FormatEntryTimeForIndex();
}
