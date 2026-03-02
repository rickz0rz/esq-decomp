#include "esq_types.h"

/*
 * Target 607 GCC trial function.
 * Normalize month field into 1..12 and set overflow flag at +18.
 */
s32 DATETIME_NormalizeMonthRange(void *ctx) __attribute__((noinline, used));

static s16 DATETIME_RemS16Div12(s16 value) __attribute__((noinline));

static s16 DATETIME_RemS16Div12(s16 value)
{
    register s32 d0_inout __asm__("d0") = (s32)value;
    register s32 d1_in __asm__("d1") = 12;

    __asm__ volatile(
        "divs %1,%0\n\t"
        "swap %0\n\t"
        : "+d"(d0_inout)
        : "d"(d1_in)
        : "cc");

    return (s16)d0_inout;
}

s32 DATETIME_NormalizeMonthRange(void *ctx)
{
    u8 *p = (u8 *)ctx;
    s16 month = *(s16 *)(p + 8);
    s16 overflow = (month > 11) ? (s16)-1 : (s16)0;
    s16 rem;

    *(s16 *)(p + 18) = overflow;

    rem = DATETIME_RemS16Div12(month);
    *(s16 *)(p + 8) = rem;

    if (rem == 0) {
        *(s16 *)(p + 8) = 12;
    }

    return (s32)rem;
}
