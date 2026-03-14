#include <exec/types.h>
extern WORD SCRIPT_CtrlInterfaceEnabledFlag;
extern void SCRIPT_DeassertCtrlLine(void);

void SCRIPT_ClearCtrlLineIfEnabled(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag != 0) {
        SCRIPT_DeassertCtrlLine();
    }
}
