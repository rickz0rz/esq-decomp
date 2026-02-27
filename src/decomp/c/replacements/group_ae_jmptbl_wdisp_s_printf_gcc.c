#include "esq_types.h"

/*
 * Target 237 GCC trial function.
 * Jump-table stub forwarding to WDISP_SPrintf.
 */
void WDISP_SPrintf(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_WDISP_SPrintf(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_WDISP_SPrintf(void)
{
    WDISP_SPrintf();
}
