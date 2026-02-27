#include "esq_types.h"

/*
 * Target 214 GCC trial function.
 * Jump-table stub forwarding to LOCAVAIL_FreeResourceChain.
 */
void LOCAVAIL_FreeResourceChain(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(void)
{
    LOCAVAIL_FreeResourceChain();
}
