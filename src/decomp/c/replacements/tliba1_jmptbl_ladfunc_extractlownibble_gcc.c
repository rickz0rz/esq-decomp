#include "esq_types.h"

void LADFUNC_GetPackedPenLowNibble(void) __attribute__((noinline));

void TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(void) __attribute__((noinline, used));

void TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(void)
{
    LADFUNC_GetPackedPenLowNibble();
}
