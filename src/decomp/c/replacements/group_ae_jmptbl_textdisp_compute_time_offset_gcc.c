#include "esq_types.h"

/*
 * Target 239 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_ComputeTimeOffset.
 */
void TEXTDISP_ComputeTimeOffset(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(void)
{
    TEXTDISP_ComputeTimeOffset();
}
