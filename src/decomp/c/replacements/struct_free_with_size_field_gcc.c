#include "esq_types.h"

/*
 * Target 064 GCC trial function.
 * Mark struct fields invalid and free using size at +18.
 */
extern u32 AbsExecBase;

void STRUCT_FreeWithSizeField(void *ptr) __attribute__((noinline, used));

void STRUCT_FreeWithSizeField(void *ptr)
{
    u8 *p = (u8 *)ptr;
    u32 minus_one = 0xffffffffu;
    u32 size = (u32)(*(u16 *)(p + 18));
    register void *a1_in __asm__("a1") = p;
    register u32 d0_in __asm__("d0") = size;

    p[8] = 0xff;
    *(u32 *)(p + 20) = minus_one;
    *(u32 *)(p + 24) = minus_one;

    __asm__ volatile(
        "movea.l %2,%%a6\n\t"
        "jsr _LVOFreeMem(%%a6)\n\t"
        : "+r"(d0_in), "+r"(a1_in)
        : "g"(AbsExecBase)
        : "a6", "cc", "memory");
}
