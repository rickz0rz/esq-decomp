#include "esq_types.h"

/*
 * Target 072 GCC trial function.
 * Skip class-3 chars, parse signed long via NoBranch variant, return value.
 */
u8 *STR_SkipClass3Chars(const u8 *s) __attribute__((noinline));
u32 PARSE_ReadSignedLong_NoBranch(const u8 *in, s32 *out_value) __attribute__((noinline));

s32 PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in) __attribute__((noinline, used));

s32 PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in)
{
    s32 value = 0;

    if (in == (const u8 *)0) {
        return 0;
    }

    in = STR_SkipClass3Chars(in);
    PARSE_ReadSignedLong_NoBranch(in, &value);
    return value;
}
