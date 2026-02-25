#include "esq_types.h"

/*
 * Target 021 GCC trial function.
 * Skip chars while class-table bit 3 is set.
 */
extern u8 Global_CharClassTable[];
u8 *STR_SkipClass3Chars(const u8 *s) __attribute__((noinline, used));

u8 *STR_SkipClass3Chars(const u8 *s)
{
    while ((Global_CharClassTable[(u32)(*s)] & 0x08u) != 0u) {
        s++;
    }

    return (u8 *)s;
}
