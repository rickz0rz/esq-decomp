#include "esq_types.h"

extern s16 SCRIPT_CtrlInterfaceEnabledFlag;

void SCRIPT_AssertCtrlLine(void) __attribute__((noinline));

void SCRIPT_AssertCtrlLineIfEnabled(void) __attribute__((noinline, used));

void SCRIPT_AssertCtrlLineIfEnabled(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag != 0) {
        SCRIPT_AssertCtrlLine();
    }
}
