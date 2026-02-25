#include "esq_types.h"

/*
 * Target 004 GCC trial function.
 * Real C logic (non-wrapper): lowercase ASCII to uppercase.
 */
u32 STRING_ToUpperChar(u32 ch) __attribute__((noinline, used));

u32 STRING_ToUpperChar(u32 ch)
{
    u8 c = (u8)ch;

    if (c >= (u8)'a' && c <= (u8)'z') {
        c = (u8)(c - 0x20);
    }

    return (u32)c;
}
