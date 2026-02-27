#include "esq_types.h"

/*
 * Target 095 GCC trial function.
 * Jump-table stub forwarding to STRING_CompareNoCase.
 */
s32 STRING_CompareNoCase(const u8 *a, const u8 *b) __attribute__((noinline));

s32 GROUP_AA_JMPTBL_STRING_CompareNoCase(const u8 *a, const u8 *b) __attribute__((noinline, used));

s32 GROUP_AA_JMPTBL_STRING_CompareNoCase(const u8 *a, const u8 *b)
{
    return STRING_CompareNoCase(a, b);
}
