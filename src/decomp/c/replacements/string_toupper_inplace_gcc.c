#include "esq_types.h"

/*
 * Target 016 GCC trial function.
 * Convert a NUL-terminated string to uppercase in place.
 */
u8 *STRING_ToUpperInPlace(u8 *s) __attribute__((noinline, used));
extern u8 Global_CharClassTable[];

u8 *STRING_ToUpperInPlace(u8 *s)
{
    u8 *p = s;

    while (*p != 0) {
        u8 c = *p;
        if ((Global_CharClassTable[(u32)c] & 0x02u) != 0u) {
            c = (u8)(c - 0x20u);
        }
        *p = c;
        p++;
    }

    return s;
}
