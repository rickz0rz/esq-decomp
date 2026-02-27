#include "esq_types.h"

/*
 * Target 178 GCC trial function.
 * Jump-table stub forwarding to STRING_CompareNoCaseN.
 */
void STRING_CompareNoCaseN(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_STRING_CompareNoCaseN(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_STRING_CompareNoCaseN(void)
{
    STRING_CompareNoCaseN();
}
