#include "esq_types.h"

/*
 * Target 051 GCC trial function.
 * Wrapper around input-device private vector call.
 */
extern u32 INPUTDEVICE_LibraryBaseFromConsoleIo;

u32 EXEC_CallVector_48(void *arg_a0, void *arg_a1, u32 arg_d1, void *arg_a2) __attribute__((noinline, used));

u32 EXEC_CallVector_48(void *arg_a0, void *arg_a1, u32 arg_d1, void *arg_a2)
{
    register void *a0_in __asm__("a0") = arg_a0;
    register void *a1_in __asm__("a1") = arg_a1;
    register u32 d1_in __asm__("d1") = arg_d1;
    register void *a2_in __asm__("a2") = arg_a2;
    register u32 d0_out __asm__("d0");

    __asm__ volatile(
        "movea.l %6,%%a6\n\t"
        "jsr _LVOexecPrivate3(%%a6)\n\t"
        : "=r"(d0_out), "+r"(a0_in), "+r"(a1_in), "+r"(d1_in), "+r"(a2_in)
        : "0"(0), "g"(INPUTDEVICE_LibraryBaseFromConsoleIo)
        : "a6", "cc", "memory");

    return d0_out;
}
