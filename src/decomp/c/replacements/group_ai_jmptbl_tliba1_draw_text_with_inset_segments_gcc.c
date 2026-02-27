#include "esq_types.h"

/*
 * Target 203 GCC trial function.
 * Jump-table stub forwarding to TLIBA1_DrawTextWithInsetSegments.
 */
void TLIBA1_DrawTextWithInsetSegments(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(void)
{
    TLIBA1_DrawTextWithInsetSegments();
}
