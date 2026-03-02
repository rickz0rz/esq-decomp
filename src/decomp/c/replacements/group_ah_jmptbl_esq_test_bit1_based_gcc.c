#include "esq_types.h"

/*
 * Target 252 GCC trial function.
 * Jump-table stub forwarding to ESQ_TestBit1Based.
 */
void ESQ_TestBit1Based(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQ_TestBit1Based(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQ_TestBit1Based(void)
{
    ESQ_TestBit1Based();
}
