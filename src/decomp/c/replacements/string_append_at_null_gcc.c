#include "esq_types.h"

/*
 * Target 010 GCC trial function.
 * Append source C-string to destination at destination's terminating NUL.
 */
u8 *STRING_AppendAtNull(u8 *dst, const u8 *src) __attribute__((noinline, used));

u8 *STRING_AppendAtNull(u8 *dst, const u8 *src)
{
    u8 *ret = dst;

    while (*dst != 0) {
        dst++;
    }

    do {
        *dst = *src;
        src++;
        dst++;
    } while (dst[-1] != 0);

    return ret;
}
