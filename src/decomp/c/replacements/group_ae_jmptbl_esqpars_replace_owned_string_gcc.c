#include "esq_types.h"

/*
 * Target 240 GCC trial function.
 * Jump-table stub forwarding to ESQPARS_ReplaceOwnedString.
 */
void ESQPARS_ReplaceOwnedString(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void)
{
    ESQPARS_ReplaceOwnedString();
}
