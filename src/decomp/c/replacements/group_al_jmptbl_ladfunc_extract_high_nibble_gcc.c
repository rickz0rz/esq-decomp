#include "esq_types.h"

/*
 * Target 172 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_GetPackedPenHighNibble.
 */
void LADFUNC_GetPackedPenHighNibble(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(void)
{
    LADFUNC_GetPackedPenHighNibble();
}
