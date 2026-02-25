#include "esq_types.h"

/*
 * Target 006 GCC trial function.
 * Format unsigned integer to decimal ASCII with reverse emit.
 */
u32 FORMAT_U32ToDecimalString(u8 *dst, u32 value) __attribute__((noinline, used));

u32 FORMAT_U32ToDecimalString(u8 *dst, u32 value)
{
    u8 temp[12];
    u8 *p = temp;
    u32 q;
    u32 r;
    u32 len;

    do {
        register u32 d0_inout __asm__("d0") = value;
        register u32 d1_inout __asm__("d1") = 10;
        __asm__ volatile(
            "jsr MATH_DivU32\n\t"
            : "+r"(d0_inout), "+r"(d1_inout)
            :
            : "cc", "memory");
        q = d0_inout;
        r = d1_inout;

        *p++ = (u8)(r + (u32)'0');
        value = q;
    } while (value != 0);

    len = (u32)(p - temp);
    while (p != temp) {
        *dst++ = *--p;
    }
    *dst = 0;
    return len;
}
