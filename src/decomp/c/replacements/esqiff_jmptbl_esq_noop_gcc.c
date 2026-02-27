#include "esq_types.h"

/*
 * Target 112 GCC trial function.
 * Jump-table stub forwarding to ESQ_NoOp.
 */
void ESQ_NoOp(void) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_NoOp(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_NoOp(void)
{
    ESQ_NoOp();
}
