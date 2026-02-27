#include "esq_types.h"

/*
 * Target 168 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_GetPackedPenLowNibble.
 */
void LADFUNC_GetPackedPenLowNibble(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(void)
{
    LADFUNC_GetPackedPenLowNibble();
}
