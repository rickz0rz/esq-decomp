#include "esq_types.h"

/*
 * Target 158 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_BuildChannelLabel.
 */
void TEXTDISP_BuildChannelLabel(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel(void)
{
    TEXTDISP_BuildChannelLabel();
}
