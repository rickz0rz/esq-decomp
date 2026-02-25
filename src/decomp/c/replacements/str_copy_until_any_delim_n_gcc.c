#include "esq_types.h"

/*
 * Target 030 GCC trial function.
 * Copy from source into destination until delimiter, NUL, or max length.
 */
u8 *STR_CopyUntilAnyDelimN(const u8 *src, u8 *dst, s32 max_len, const u8 *delims) __attribute__((noinline, used));

u8 *STR_CopyUntilAnyDelimN(const u8 *src, u8 *dst, s32 max_len, const u8 *delims)
{
    s32 i = 0;

    while (i < (max_len - 1)) {
        u8 c = src[i];
        const u8 *p;

        if (c == 0) {
            break;
        }

        p = delims;
        while (*p != 0) {
            if (*p == c) {
                goto done;
            }
            p++;
        }

        dst[i] = c;
        i++;
    }

done:
    dst[i] = 0;
    return (u8 *)(src + i);
}
