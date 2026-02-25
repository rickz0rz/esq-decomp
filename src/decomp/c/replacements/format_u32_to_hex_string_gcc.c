#include "esq_types.h"

/*
 * Target 025 GCC trial function.
 * Format unsigned integer to hex ASCII with reverse emit.
 */
extern const u8 kHexDigitTable[];
u32 FORMAT_U32ToHexString(u8 *dst, u32 value) __attribute__((noinline, used));

u32 FORMAT_U32ToHexString(u8 *dst, u32 value)
{
    u8 temp[12];
    u8 *p = temp;
    u32 len;

    do {
        u32 nibble = value & 0xFu;
        *p++ = kHexDigitTable[nibble];
        value >>= 4;
    } while (value != 0);

    len = (u32)(p - temp);
    while (p != temp) {
        *dst++ = *--p;
    }
    *dst = 0;
    return len;
}
