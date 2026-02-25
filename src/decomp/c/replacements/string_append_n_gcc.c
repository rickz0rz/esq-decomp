#include "esq_types.h"

/*
 * Target 011 GCC trial function.
 * Append up to max bytes from src to dst, then write trailing NUL.
 */
u8 *STRING_AppendN(u8 *dst, const u8 *src, u32 max_bytes) __attribute__((noinline, used));

u8 *STRING_AppendN(u8 *dst, const u8 *src, u32 max_bytes)
{
    const u8 *s = src;
    u8 *d = dst;
    u32 src_len = 0;
    u32 dst_len = 0;
    u32 copy_len;
    u32 i;

    while (*s != 0) {
        s++;
    }
    src_len = (u32)(s - src);

    while (*d != 0) {
        d++;
    }
    dst_len = (u32)(d - dst);

    copy_len = src_len;
    if (copy_len > max_bytes) {
        copy_len = max_bytes;
    }

    for (i = 0; i < copy_len; i++) {
        dst[dst_len + i] = src[i];
    }

    dst[dst_len + copy_len] = 0;
    return dst;
}
