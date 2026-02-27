#include "esq_types.h"

/*
 * Target 216 GCC trial function.
 * Jump-table stub forwarding to IOSTDREQ_Free.
 */
void IOSTDREQ_Free(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_IOSTDREQ_Free(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_IOSTDREQ_Free(void)
{
    IOSTDREQ_Free();
}
