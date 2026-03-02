#include "esq_types.h"

/*
 * Target 272 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_DeassertCtrlLineNow.
 */
void SCRIPT_DeassertCtrlLineNow(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void)
{
    SCRIPT_DeassertCtrlLineNow();
}
