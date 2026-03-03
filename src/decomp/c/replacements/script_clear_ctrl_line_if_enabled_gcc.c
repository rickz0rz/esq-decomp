#include "esq_types.h"

extern s16 SCRIPT_CtrlInterfaceEnabledFlag;

void SCRIPT_DeassertCtrlLine(void) __attribute__((noinline));

void SCRIPT_ClearCtrlLineIfEnabled(void) __attribute__((noinline, used));

void SCRIPT_ClearCtrlLineIfEnabled(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag != 0) {
        SCRIPT_DeassertCtrlLine();
    }
}
