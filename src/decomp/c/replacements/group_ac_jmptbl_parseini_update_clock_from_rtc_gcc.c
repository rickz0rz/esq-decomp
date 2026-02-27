#include "esq_types.h"

/*
 * Target 218 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_UpdateClockFromRtc.
 */
void PARSEINI_UpdateClockFromRtc(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc(void)
{
    PARSEINI_UpdateClockFromRtc();
}
