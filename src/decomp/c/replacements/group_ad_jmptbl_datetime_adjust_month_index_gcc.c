#include "esq_types.h"

/*
 * Target 151 GCC trial function.
 * Jump-table stub forwarding to DATETIME_AdjustMonthIndex.
 */
s32 DATETIME_AdjustMonthIndex(void) __attribute__((noinline));

s32 GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex(void) __attribute__((noinline, used));

s32 GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex(void)
{
    return DATETIME_AdjustMonthIndex();
}
