#include "esq_types.h"

/*
 * Target 286 GCC trial function.
 * Jump-table stub forwarding to LADFUNC2_EmitEscapedStringToScratch.
 */
void LADFUNC2_EmitEscapedStringToScratch(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(void)
{
    LADFUNC2_EmitEscapedStringToScratch();
}
