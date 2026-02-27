#include "esq_types.h"

/*
 * Target 093 GCC trial function.
 * Jump-table stub forwarding to STRING_AppendAtNull.
 */
u8 *STRING_AppendAtNull(u8 *dst, const u8 *src) __attribute__((noinline));

u8 *GROUP_AR_JMPTBL_STRING_AppendAtNull(u8 *dst, const u8 *src) __attribute__((noinline, used));

u8 *GROUP_AR_JMPTBL_STRING_AppendAtNull(u8 *dst, const u8 *src)
{
    return STRING_AppendAtNull(dst, src);
}
