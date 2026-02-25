#include "esq_types.h"

/*
 * Target 018 GCC trial function.
 * Wrapper around STR_FindChar.
 */
u8 *STR_FindChar(const u8 *s, u32 target) __attribute__((noinline));
u8 *STR_FindCharPtr(const u8 *s, u32 target) __attribute__((noinline, used));

u8 *STR_FindCharPtr(const u8 *s, u32 target)
{
    return STR_FindChar(s, target);
}
