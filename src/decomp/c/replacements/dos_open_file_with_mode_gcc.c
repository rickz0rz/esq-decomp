#include "esq_types.h"

/*
 * Target 080 GCC trial function.
 * Direct dos.library Open(name, mode) wrapper.
 */
extern u32 Global_REF_DOS_LIBRARY_2;

s32 DOS_OpenFileWithMode(const char *name, s32 mode) __attribute__((noinline, used));

static s32 dos_lvo_open(const char *name, s32 mode)
{
    register const char *d1_in __asm__("d1") = name;
    register s32 d2_in __asm__("d2") = mode;
    register s32 result;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOOpen(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result), "+r"(d1_in), "+r"(d2_in)
        : "g"(Global_REF_DOS_LIBRARY_2)
        : "a6", "d0", "cc", "memory");

    return result;
}

s32 DOS_OpenFileWithMode(const char *name, s32 mode)
{
    return dos_lvo_open(name, mode);
}
