#include "esq_types.h"

/*
 * Target 017 GCC trial function.
 * Find first occurrence of target byte in string.
 */
u8 *STR_FindChar(const u8 *s, u32 target) __attribute__((noinline, used));

u8 *STR_FindChar(const u8 *s, u32 target)
{
    for (;;) {
        u32 c = (u32)(*s);
        if (c == target) {
            return (u8 *)s;
        }
        if (*s++ == 0) {
            return (u8 *)0;
        }
    }
}
