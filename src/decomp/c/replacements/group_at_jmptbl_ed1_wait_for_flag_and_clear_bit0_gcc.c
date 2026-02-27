#include "esq_types.h"

/*
 * Target 191 GCC trial function.
 * Jump-table stub forwarding to ED1_WaitForFlagAndClearBit0.
 */
void ED1_WaitForFlagAndClearBit0(void) __attribute__((noinline));

void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void) __attribute__((noinline, used));

void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void)
{
    ED1_WaitForFlagAndClearBit0();
}
