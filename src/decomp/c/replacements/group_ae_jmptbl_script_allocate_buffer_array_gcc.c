#include "esq_types.h"

/*
 * Target 238 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_AllocateBufferArray.
 */
void SCRIPT_AllocateBufferArray(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void)
{
    SCRIPT_AllocateBufferArray();
}
