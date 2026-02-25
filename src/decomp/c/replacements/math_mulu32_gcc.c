#include "esq_types.h"

/*
 * Target 040 GCC trial function.
 * Unsigned 32-bit multiply helper.
 */
u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline, used));

u32 MATH_Mulu32(u32 a, u32 b)
{
    return (u32)(a * b);
}
