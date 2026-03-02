#include "esq_types.h"

/*
 * Target 270 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_WriteErrorLogEntry.
 */
void PARSEINI_WriteErrorLogEntry(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void)
{
    PARSEINI_WriteErrorLogEntry();
}
