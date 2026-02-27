#include "esq_types.h"

/*
 * Target 160 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_TrimTextToPixelWidth.
 */
void TEXTDISP_TrimTextToPixelWidth(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth(void)
{
    TEXTDISP_TrimTextToPixelWidth();
}
