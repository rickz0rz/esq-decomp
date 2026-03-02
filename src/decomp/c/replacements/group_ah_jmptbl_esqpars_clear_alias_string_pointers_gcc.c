#include "esq_types.h"

/*
 * Target 257 GCC trial function.
 * Jump-table stub forwarding to ESQPARS_ClearAliasStringPointers.
 */
void ESQPARS_ClearAliasStringPointers(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void)
{
    ESQPARS_ClearAliasStringPointers();
}
