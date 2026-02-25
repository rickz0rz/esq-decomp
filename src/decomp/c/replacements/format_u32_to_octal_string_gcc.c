#include "esq_types.h"

/*
 * Target 024 GCC trial function.
 * Format unsigned integer to octal ASCII with reverse emit.
 */
u32 FORMAT_U32ToOctalString(u8 *dst, u32 value) __attribute__((noinline, used));

u32 FORMAT_U32ToOctalString(u8 *dst, u32 value)
{
    u8 temp[12];
    u8 *p = temp;
    u32 len;

    do {
        *p++ = (u8)((value & 7u) + (u32)'0');
        value >>= 3;
    } while (value != 0);

    len = (u32)(p - temp);
    while (p != temp) {
        *dst++ = *--p;
    }
    *dst = 0;
    return len;
}
