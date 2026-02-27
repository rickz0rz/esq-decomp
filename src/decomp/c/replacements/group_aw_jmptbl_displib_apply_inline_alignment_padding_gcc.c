#include "esq_types.h"

/*
 * Target 183 GCC trial function.
 * Jump-table stub forwarding to DISPLIB_ApplyInlineAlignmentPadding.
 */
void DISPLIB_ApplyInlineAlignmentPadding(void) __attribute__((noinline));

void GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(void) __attribute__((noinline, used));

void GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(void)
{
    DISPLIB_ApplyInlineAlignmentPadding();
}
