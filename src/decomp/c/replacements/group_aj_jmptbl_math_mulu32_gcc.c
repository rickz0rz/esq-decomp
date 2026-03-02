#include "esq_types.h"

/*
 * Target 263 GCC trial function.
 * Jump-table stub forwarding to MATH_Mulu32.
 */
void MATH_Mulu32(void) __attribute__((noinline));

void GROUP_AJ_JMPTBL_MATH_Mulu32(void) __attribute__((noinline, used));

void GROUP_AJ_JMPTBL_MATH_Mulu32(void)
{
    MATH_Mulu32();
}
