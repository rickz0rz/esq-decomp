#include "esq_types.h"

/*
 * Target 253 GCC trial function.
 * Jump-table stub forwarding to ESQIFF2_ShowAttentionOverlay.
 */
void ESQIFF2_ShowAttentionOverlay(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(void)
{
    ESQIFF2_ShowAttentionOverlay();
}
