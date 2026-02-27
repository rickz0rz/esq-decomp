#include "esq_types.h"

/*
 * Target 167 GCC trial function.
 * Jump-table stub forwarding to LADFUNC_ComposePackedPenByte.
 */
void LADFUNC_ComposePackedPenByte(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(void)
{
    LADFUNC_ComposePackedPenByte();
}
