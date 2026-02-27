#include "esq_types.h"

/*
 * Target 103 GCC trial function.
 * Jump-table stub forwarding to STRING_CopyPadNul.
 */
u8 *STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len) __attribute__((noinline));

u8 *GROUP_AG_JMPTBL_STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len) __attribute__((noinline, used));

u8 *GROUP_AG_JMPTBL_STRING_CopyPadNul(u8 *dst, const u8 *src, u32 max_len)
{
    return STRING_CopyPadNul(dst, src, max_len);
}
