#include "esq_types.h"

/*
 * Target 150 GCC trial function.
 * Jump-table stub forwarding to DATETIME_NormalizeMonthRange.
 */
s32 DATETIME_NormalizeMonthRange(void) __attribute__((noinline));

s32 GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange(void) __attribute__((noinline, used));

s32 GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange(void)
{
    return DATETIME_NormalizeMonthRange();
}
