#include "esq_types.h"

/*
 * Target 187 GCC trial function.
 * Jump-table stub forwarding to WDISP_SPrintf.
 */
void WDISP_SPrintf(void) __attribute__((noinline));

void GROUP_AW_JMPTBL_WDISP_SPrintf(void) __attribute__((noinline, used));

void GROUP_AW_JMPTBL_WDISP_SPrintf(void)
{
    WDISP_SPrintf();
}
