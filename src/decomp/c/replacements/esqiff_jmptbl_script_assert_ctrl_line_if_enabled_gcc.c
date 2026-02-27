#include "esq_types.h"

/*
 * Target 125 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_AssertCtrlLineIfEnabled.
 */
void SCRIPT_AssertCtrlLineIfEnabled(void) __attribute__((noinline));

void ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(void)
{
    SCRIPT_AssertCtrlLineIfEnabled();
}
