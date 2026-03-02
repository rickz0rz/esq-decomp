#include "esq_types.h"

void LADFUNC_GetPackedPenHighNibble(void) __attribute__((noinline));

void TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(void) __attribute__((noinline, used));

void TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(void)
{
    LADFUNC_GetPackedPenHighNibble();
}
