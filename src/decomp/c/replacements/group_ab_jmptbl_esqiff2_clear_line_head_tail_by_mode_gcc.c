#include "esq_types.h"

/*
 * Target 217 GCC trial function.
 * Jump-table stub forwarding to ESQIFF2_ClearLineHeadTailByMode.
 */
void ESQIFF2_ClearLineHeadTailByMode(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(void)
{
    ESQIFF2_ClearLineHeadTailByMode();
}
