#include "esq_types.h"

/*
 * Target 221 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_UpdateCtrlStateMachine.
 */
void SCRIPT_UpdateCtrlStateMachine(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine(void)
{
    SCRIPT_UpdateCtrlStateMachine();
}
