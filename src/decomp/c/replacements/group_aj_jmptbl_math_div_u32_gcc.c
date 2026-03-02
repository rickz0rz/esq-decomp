#include "esq_types.h"

/*
 * Target 261 GCC trial function.
 * Jump-table stub forwarding to MATH_DivU32.
 */
void MATH_DivU32(void) __attribute__((noinline));

void GROUP_AJ_JMPTBL_MATH_DivU32(void) __attribute__((noinline, used));

void GROUP_AJ_JMPTBL_MATH_DivU32(void)
{
    MATH_DivU32();
}
