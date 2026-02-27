#include "esq_types.h"

/*
 * Target 236 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_DeallocateBufferArray.
 */
void SCRIPT_DeallocateBufferArray(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void)
{
    SCRIPT_DeallocateBufferArray();
}
