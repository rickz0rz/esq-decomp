#include "esq_types.h"

/*
 * Target 110 GCC trial function.
 * Jump-table stub forwarding to STRING_CompareNoCaseN.
 */
s32 STRING_CompareNoCaseN(const u8 *a, const u8 *b, u32 max_len) __attribute__((noinline));

s32 ESQIFF_JMPTBL_STRING_CompareNoCaseN(const u8 *a, const u8 *b, u32 max_len) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_STRING_CompareNoCaseN(const u8 *a, const u8 *b, u32 max_len)
{
    return STRING_CompareNoCaseN(a, b, max_len);
}
