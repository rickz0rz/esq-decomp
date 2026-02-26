#include "esq_types.h"

/*
 * Target 060 GCC trial function.
 * RawDoFmt wrapper using PARALLEL_WriteCharHw as output callback.
 */
extern u32 AbsExecBase;

void PARALLEL_WriteCharHw(s32 ch);
void PARALLEL_RawDoFmt(const u8 *fmt, const void *arg_stream) __attribute__((noinline, used));

void PARALLEL_RawDoFmt(const u8 *fmt, const void *arg_stream)
{
    register const u8 *a0_in __asm__("a0") = fmt;
    register const void *a1_in __asm__("a1") = arg_stream;
    register void (*a2_in)(s32) __asm__("a2") = PARALLEL_WriteCharHw;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVORawDoFmt(%%a6)\n\t"
        : "+r"(a0_in), "+r"(a1_in), "+r"(a2_in)
        : "g"(AbsExecBase)
        : "a6", "cc", "memory");
}
