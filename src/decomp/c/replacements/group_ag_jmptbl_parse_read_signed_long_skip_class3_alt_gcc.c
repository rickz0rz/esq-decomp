#include "esq_types.h"

/*
 * Target 107 GCC trial function.
 * Jump-table stub forwarding to PARSE_ReadSignedLongSkipClass3_Alt.
 */
s32 PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in) __attribute__((noinline));

s32 GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in) __attribute__((noinline, used));

s32 GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const u8 *in)
{
    return PARSE_ReadSignedLongSkipClass3_Alt(in);
}
