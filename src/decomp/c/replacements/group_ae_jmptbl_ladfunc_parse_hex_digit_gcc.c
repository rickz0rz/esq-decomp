#include "esq_types.h"

/*
 * Target 235 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_ParseHexDigit.
 */
void LADFUNC_ParseHexDigit(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(void)
{
    LADFUNC_ParseHexDigit();
}
