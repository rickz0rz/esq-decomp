#include "esq_types.h"

/*
 * Target 020 GCC trial function.
 * Wrapper around STR_FindAnyCharInSet.
 */
u8 *STR_FindAnyCharInSet(const u8 *s, const u8 *charset) __attribute__((noinline));
u8 *STR_FindAnyCharPtr(const u8 *s, const u8 *charset) __attribute__((noinline, used));

u8 *STR_FindAnyCharPtr(const u8 *s, const u8 *charset)
{
    return STR_FindAnyCharInSet(s, charset);
}
