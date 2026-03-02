#include "esq_types.h"

/*
 * Target 605 GCC trial function.
 * Leap-year check with the same 1900-base normalization used by original code.
 */
s32 DATETIME_IsLeapYear(s32 year) __attribute__((noinline, used));

static s32 DATETIME_ModByDivS32Helper(s32 dividend, s32 divisor) __attribute__((noinline));

static s32 DATETIME_ModByDivS32Helper(s32 dividend, s32 divisor)
{
    register s32 d0_inout __asm__("d0") = dividend;
    register s32 d1_inout __asm__("d1") = divisor;

    __asm__ volatile(
        "jsr GROUP_AG_JMPTBL_MATH_DivS32\n\t"
        : "+d"(d0_inout), "+d"(d1_inout)
        :
        : "cc", "memory");

    return d1_inout;
}

s32 DATETIME_IsLeapYear(s32 year)
{
    if (year < 1900) {
        year += 1900;
    }

    if (DATETIME_ModByDivS32Helper(year, 4) != 0) {
        return 0;
    }

    if (DATETIME_ModByDivS32Helper(year, 100) != 0) {
        return 1;
    }

    if (DATETIME_ModByDivS32Helper(year, 400) == 0) {
        return 1;
    }

    return 0;
}
