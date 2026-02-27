#include "esq_types.h"

/*
 * Target 124 GCC trial function.
 * Jump-table stub forwarding to CTASKS_StartIffTaskProcess.
 */
s32 CTASKS_StartIffTaskProcess(void) __attribute__((noinline));

s32 ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void)
{
    return CTASKS_StartIffTaskProcess();
}
