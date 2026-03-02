#include "esq_types.h"

/*
 * Target 609 GCC trial function.
 * Local wrapper that dispatches PARSEINI RTC write helper.
 */
void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void) __attribute__((noinline));

void DST_WriteRtcFromGlobals(void) __attribute__((noinline, used));

void DST_WriteRtcFromGlobals(void)
{
    GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals();
}
