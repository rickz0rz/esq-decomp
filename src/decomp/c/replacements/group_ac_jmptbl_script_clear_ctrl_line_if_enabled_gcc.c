#include "esq_types.h"

/*
 * Target 224 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_ClearCtrlLineIfEnabled.
 */
void SCRIPT_ClearCtrlLineIfEnabled(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled(void)
{
    SCRIPT_ClearCtrlLineIfEnabled();
}
