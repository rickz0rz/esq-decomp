#include "esq_types.h"

/*
 * Target 229 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_DrawEscMenuVersion.
 */
void ESQFUNC_DrawEscMenuVersion(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion(void)
{
    ESQFUNC_DrawEscMenuVersion();
}
