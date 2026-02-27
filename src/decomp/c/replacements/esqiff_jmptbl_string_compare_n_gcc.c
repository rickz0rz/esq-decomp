#include "esq_types.h"

/*
 * Target 109 GCC trial function.
 * Jump-table stub forwarding to STRING_CompareN.
 */
s32 STRING_CompareN(const u8 *a, const u8 *b, u32 max_len) __attribute__((noinline));

s32 ESQIFF_JMPTBL_STRING_CompareN(const u8 *a, const u8 *b, u32 max_len) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_STRING_CompareN(const u8 *a, const u8 *b, u32 max_len)
{
    return STRING_CompareN(a, b, max_len);
}
