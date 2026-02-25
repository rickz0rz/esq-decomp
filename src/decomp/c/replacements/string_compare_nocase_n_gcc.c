#include "esq_types.h"

/*
 * Target 015 GCC trial function.
 * Case-insensitive compare up to max_len or until either string ends.
 */
s32 STRING_CompareNoCaseN(const u8 *a, const u8 *b, u32 max_len) __attribute__((noinline, used));
u32 STRING_ToUpperChar(u32 c) __attribute__((noinline));

s32 STRING_CompareNoCaseN(const u8 *a, const u8 *b, u32 max_len)
{
    while (max_len != 0 && *a != 0 && *b != 0) {
        s32 diff = (s32)STRING_ToUpperChar((u32)(*a++)) - (s32)STRING_ToUpperChar((u32)(*b++));
        if (diff != 0) {
            return diff;
        }
        max_len--;
    }

    if (max_len == 0) {
        return 0;
    }
    if (*a != 0) {
        return 1;
    }
    if (*b != 0) {
        return -1;
    }
    return 0;
}
