#include "esq_types.h"

/*
 * Target 114 GCC trial function.
 * Jump-table stub forwarding to ESQ_NoOp_006A.
 */
void ESQ_NoOp_006A(void) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_NoOp_006A(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_NoOp_006A(void)
{
    ESQ_NoOp_006A();
}
