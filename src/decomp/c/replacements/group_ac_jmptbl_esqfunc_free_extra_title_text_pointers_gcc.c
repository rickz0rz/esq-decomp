#include "esq_types.h"

/*
 * Target 225 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_FreeExtraTitleTextPointers.
 */
void ESQFUNC_FreeExtraTitleTextPointers(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers(void)
{
    ESQFUNC_FreeExtraTitleTextPointers();
}
