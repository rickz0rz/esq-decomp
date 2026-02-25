#include "esq_types.h"

/*
 * Target 019 GCC trial function.
 * Find first input byte that exists in charset.
 */
u8 *STR_FindAnyCharInSet(const u8 *s, const u8 *charset) __attribute__((noinline, used));

u8 *STR_FindAnyCharInSet(const u8 *s, const u8 *charset)
{
    while (*s != 0) {
        const u8 *p = charset;
        while (*p != 0) {
            if (*p == *s) {
                return (u8 *)s;
            }
            p++;
        }
        s++;
    }

    return (u8 *)0;
}
