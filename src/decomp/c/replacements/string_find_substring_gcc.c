#include "esq_types.h"

/*
 * Target 069 GCC trial function.
 * Naive substring search; returns first match in haystack or null.
 */
u8 *STRING_FindSubstring(const u8 *haystack, const u8 *needle) __attribute__((noinline, used));

u8 *STRING_FindSubstring(const u8 *haystack, const u8 *needle)
{
    const u8 *h = haystack;

    for (;;) {
        const u8 *scan = h;
        const u8 *n = needle;

        while (*n != 0) {
            if (*scan != *n) {
                if (*scan == 0) {
                    return (u8 *)0;
                }
                ++h;
                if (*h == 0) {
                    return (u8 *)0;
                }
                goto next_start;
            }
            ++scan;
            ++n;
        }

        return (u8 *)h;

next_start:
        ;
    }
}
