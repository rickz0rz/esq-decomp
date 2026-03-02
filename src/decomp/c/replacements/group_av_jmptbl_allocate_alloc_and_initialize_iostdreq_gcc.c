#include "esq_types.h"

/*
 * Target 276 GCC trial function.
 * Jump-table stub forwarding to ALLOCATE_AllocAndInitializeIOStdReq.
 */
void ALLOCATE_AllocAndInitializeIOStdReq(void) __attribute__((noinline));

void GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void) __attribute__((noinline, used));

void GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void)
{
    ALLOCATE_AllocAndInitializeIOStdReq();
}
