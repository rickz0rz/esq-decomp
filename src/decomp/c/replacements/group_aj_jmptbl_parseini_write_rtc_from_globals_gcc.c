#include "esq_types.h"

/*
 * Target 262 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_WriteRtcFromGlobals.
 */
void PARSEINI_WriteRtcFromGlobals(void) __attribute__((noinline));

void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void) __attribute__((noinline, used));

void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void)
{
    PARSEINI_WriteRtcFromGlobals();
}
