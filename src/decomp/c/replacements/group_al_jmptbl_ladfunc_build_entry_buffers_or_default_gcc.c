#include "esq_types.h"

/*
 * Target 171 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_BuildEntryBuffersOrDefault.
 */
void LADFUNC_BuildEntryBuffersOrDefault(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(void)
{
    LADFUNC_BuildEntryBuffersOrDefault();
}
