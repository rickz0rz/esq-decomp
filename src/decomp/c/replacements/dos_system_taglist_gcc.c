#include "esq_types.h"

/*
 * Target 050 GCC trial function.
 * Thin wrapper for DOS SystemTagList.
 */
extern u32 Global_REF_DOS_LIBRARY_2;

s32 DOS_SystemTagList(const char *command, const void *tags) __attribute__((noinline, used));

s32 DOS_SystemTagList(const char *command, const void *tags)
{
    register u32 d1_in __asm__("d1") = (u32)command;
    register u32 d2_in __asm__("d2") = (u32)tags;
    register s32 d0_out __asm__("d0");

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOSystemTagList(%%a6)\n\t"
        : "=r"(d0_out), "+r"(d1_in), "+r"(d2_in)
        : "g"(Global_REF_DOS_LIBRARY_2)
        : "a6", "cc", "memory");

    return d0_out;
}
