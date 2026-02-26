#include "esq_types.h"

/*
 * Target 071 GCC trial function.
 * Skip class-3 chars, parse signed long, return parsed value.
 */
u8 *STR_SkipClass3Chars(const u8 *s) __attribute__((noinline));
u32 PARSE_ReadSignedLong(const u8 *in, s32 *out_value) __attribute__((noinline));

s32 PARSE_ReadSignedLongSkipClass3(const u8 *in) __attribute__((noinline, used));

s32 PARSE_ReadSignedLongSkipClass3(const u8 *in)
{
    s32 value = 0;

    if (in == (const u8 *)0) {
        return 0;
    }

    in = STR_SkipClass3Chars(in);
    PARSE_ReadSignedLong(in, &value);
    return value;
}
