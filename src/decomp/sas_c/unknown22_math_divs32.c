#include <exec/types.h>
extern ULONG MATH_DivU32(ULONG dividend, ULONG divisor);

LONG MATH_DivS32(LONG dividend, LONG divisor)
{
    if (dividend < 0) {
        dividend = -dividend;
        if (divisor < 0) {
            divisor = -divisor;
            dividend = (LONG)MATH_DivU32((ULONG)dividend, (ULONG)divisor);
            divisor = -divisor;
            return dividend;
        }
        dividend = (LONG)MATH_DivU32((ULONG)dividend, (ULONG)divisor);
        dividend = -dividend;
        divisor = -divisor;
        return dividend;
    }

    if (divisor >= 0) {
        return (LONG)MATH_DivU32((ULONG)dividend, (ULONG)divisor);
    }

    divisor = -divisor;
    dividend = (LONG)MATH_DivU32((ULONG)dividend, (ULONG)divisor);
    return -dividend;
}
