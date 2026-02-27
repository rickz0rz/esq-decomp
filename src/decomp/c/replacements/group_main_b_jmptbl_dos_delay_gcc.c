#include "esq_types.h"

/*
 * Target 090 GCC trial function.
 * Jump-table stub forwarding to DOS_Delay.
 */
void DOS_Delay(s32 ticks) __attribute__((noinline));

void GROUP_MAIN_B_JMPTBL_DOS_Delay(s32 ticks) __attribute__((noinline, used));

void GROUP_MAIN_B_JMPTBL_DOS_Delay(s32 ticks)
{
    DOS_Delay(ticks);
}
