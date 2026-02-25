#include "esq_types.h"

/*
 * Target 029 GCC trial function.
 * Parse signed decimal and return consumed length.
 */
u32 PARSE_ReadSignedLong(const u8 *in, s32 *out_value) __attribute__((noinline, used));

u32 PARSE_ReadSignedLong(const u8 *in, s32 *out_value)
{
    const u8 *start = in;
    s32 value = 0;

    if (*in == (u8)'+' || *in == (u8)'-') {
        in++;
    }

    for (;;) {
        s32 digit = (s32)(*in++) - (s32)(u8)'0';
        if (digit < 0 || digit > 9) {
            break;
        }
        value = value * 10 + digit;
    }

    if (*start == (u8)'-') {
        value = -value;
    }

    *out_value = value;
    return (u32)((in - 1) - start);
}
