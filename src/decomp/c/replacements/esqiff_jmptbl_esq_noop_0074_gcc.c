#include "esq_types.h"

/*
 * Target 115 GCC trial function.
 * Jump-table stub forwarding to ESQ_NoOp_0074.
 */
void ESQ_NoOp_0074(void) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_NoOp_0074(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_NoOp_0074(void)
{
    ESQ_NoOp_0074();
}
