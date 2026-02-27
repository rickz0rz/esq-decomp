#include "esq_types.h"

/*
 * Target 118 GCC trial function.
 * Jump-table stub forwarding to MATH_Mulu32.
 */
u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));

u32 ESQIFF_JMPTBL_MATH_Mulu32(u32 a, u32 b) __attribute__((noinline, used));

u32 ESQIFF_JMPTBL_MATH_Mulu32(u32 a, u32 b)
{
    return MATH_Mulu32(a, b);
}
