#include "esq_types.h"

/*
 * Target 159 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_DrawInsetRectFrame.
 */
void TEXTDISP_DrawInsetRectFrame(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame(void)
{
    TEXTDISP_DrawInsetRectFrame();
}
