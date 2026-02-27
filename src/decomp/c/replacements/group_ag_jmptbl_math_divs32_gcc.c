#include "esq_types.h"

/*
 * Target 100 GCC trial function.
 * Jump-table stub forwarding to MATH_DivS32.
 */
s32 MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline));

s32 GROUP_AG_JMPTBL_MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline, used));

s32 GROUP_AG_JMPTBL_MATH_DivS32(s32 dividend, s32 divisor)
{
    return MATH_DivS32(dividend, divisor);
}
