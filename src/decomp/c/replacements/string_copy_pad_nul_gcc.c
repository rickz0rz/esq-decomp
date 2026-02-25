#include "esq_types.h"

/*
 * Target 012 GCC trial function.
 * Copy src into dst up to max_len, padding remaining bytes with NUL.
 */
u8 *STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len) __attribute__((noinline, used));

u8 *STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len)
{
    u8 *ret = dst;

    while (max_len != 0) {
        *dst = *src;
        src++;
        dst++;
        max_len--;
        if (dst[-1] == 0) {
            break;
        }
    }

    while (max_len != 0) {
        *dst++ = 0;
        max_len--;
    }

    return ret;
}
