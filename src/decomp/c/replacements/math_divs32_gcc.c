#include "esq_types.h"

/*
 * Target 043 GCC trial function.
 * Signed 32-bit division helper via unsigned core.
 */
s32 MATH_DivU32(u32 dividend, u32 divisor);

s32 MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline, used));

s32 MATH_DivS32(s32 dividend, s32 divisor)
{
    s32 q;

    if (dividend < 0) {
        dividend = -dividend;
        if (divisor < 0) {
            divisor = -divisor;
            q = MATH_DivU32((u32)dividend, (u32)divisor);
            return q;
        }
        q = MATH_DivU32((u32)dividend, (u32)divisor);
        return -q;
    }

    if (divisor < 0) {
        divisor = -divisor;
        q = MATH_DivU32((u32)dividend, (u32)divisor);
        return -q;
    }

    return MATH_DivU32((u32)dividend, (u32)divisor);
}
