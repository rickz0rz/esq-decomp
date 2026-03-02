#include "esq_types.h"

/*
 * Target 606 GCC trial function.
 * Convert month field to modulo-12 bucket and optionally offset by +12.
 */
s32 DATETIME_AdjustMonthIndex(void *ctx) __attribute__((noinline, used));

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

s32 DATETIME_AdjustMonthIndex(void *ctx)
{
    u8 *p = (u8 *)ctx;
    s32 month = (s32)(s16)(*(s16 *)(p + 8));
    s32 rem = DATETIME_ModByDivS32Helper(month, 12);

    if (*(s16 *)(p + 18) != 0) {
        rem += 12;
    }

    *(s16 *)(p + 8) = (s16)rem;
    return rem;
}
