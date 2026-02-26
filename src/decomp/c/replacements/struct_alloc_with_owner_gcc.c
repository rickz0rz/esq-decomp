#include "esq_types.h"

/*
 * Target 065 GCC trial function.
 * Allocate owner-backed struct and initialize core fields.
 */
extern u32 AbsExecBase;

void *STRUCT_AllocWithOwner(void *owner, u32 size) __attribute__((noinline, used));

void *STRUCT_AllocWithOwner(void *owner, u32 size)
{
    u8 *p;

    if (owner == 0) {
        return 0;
    }

    {
        register u32 d0_in __asm__("d0") = size;
        register u32 d1_in __asm__("d1") = 0x00010001u;

        __asm__ volatile(
            "movea.l %3,%%a6\n\t"
            "jsr _LVOAllocMem(%%a6)\n\t"
            : "+r"(d0_in), "+r"(d1_in)
            : "0"(d0_in), "g"(AbsExecBase)
            : "a6", "cc", "memory");

        p = (u8 *)d0_in;
    }

    if (p != 0) {
        p[8] = 5;
        p[9] = 0;
        *(u32 *)(p + 14) = (u32)owner;
        *(u16 *)(p + 18) = (u16)size;
    }

    return p;
}
