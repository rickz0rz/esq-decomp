typedef signed long LONG;

extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern LONG MATH_Mulu32(LONG lhs, LONG rhs);

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG dividend, LONG divisor)
{
    return MATH_DivS32(dividend, divisor);
}

LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG lhs, LONG rhs)
{
    return MATH_Mulu32(lhs, rhs);
}
