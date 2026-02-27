#include "esq_types.h"

/*
 * Target 169 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_UpdateEntryFromTextAndAttrBuffers.
 */
void LADFUNC_UpdateEntryFromTextAndAttrBuffers(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(void)
{
    LADFUNC_UpdateEntryFromTextAndAttrBuffers();
}
