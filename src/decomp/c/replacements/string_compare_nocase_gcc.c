#include "esq_types.h"

/*
 * Target 014 GCC trial function.
 * Case-insensitive byte compare until NUL or mismatch.
 */
s32 STRING_CompareNoCase(const u8 *a, const u8 *b) __attribute__((noinline, used));

static u8 to_upper_ascii(u8 c)
{
    if (c >= (u8)'a' && c <= (u8)'z') {
        return (u8)(c - 0x20);
    }
    return c;
}

s32 STRING_CompareNoCase(const u8 *a, const u8 *b)
{
    for (;;) {
        u8 ca = *a++;
        u8 cb = *b++;
        s32 diff = (s32)(u32)to_upper_ascii(ca) - (s32)(u32)to_upper_ascii(cb);
        if (diff != 0) {
            return diff;
        }
        if (cb == 0) {
            return 0;
        }
    }
}
