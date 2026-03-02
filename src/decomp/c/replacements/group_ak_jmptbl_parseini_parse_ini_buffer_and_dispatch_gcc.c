#include "esq_types.h"

/*
 * Target 266 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_ParseIniBufferAndDispatch.
 */
void PARSEINI_ParseIniBufferAndDispatch(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(void)
{
    PARSEINI_ParseIniBufferAndDispatch();
}
