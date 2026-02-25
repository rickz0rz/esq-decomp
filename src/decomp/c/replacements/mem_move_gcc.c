#include "esq_types.h"

/*
 * Target 005 GCC trial function.
 * Overlap-safe byte copy (memmove-style) with original return semantics.
 */
s32 MEM_Move(u8 *src, u8 *dst, s32 length) __attribute__((noinline, used));

s32 MEM_Move(u8 *src, u8 *dst, s32 length)
{
    if (length <= 0) {
        return length;
    }

    if (dst < src) {
        do {
            *dst++ = *src++;
            length--;
        } while (length != 0);
        return length;
    }

    src += length;
    dst += length;
    do {
        *--dst = *--src;
        length--;
    } while (length != 0);

    return length;
}
