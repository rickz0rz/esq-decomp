typedef short WORD;

extern WORD SCRIPT_CtrlInterfaceEnabledFlag;
extern void SCRIPT_AssertCtrlLine(void);

void SCRIPT_AssertCtrlLineIfEnabled(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag != 0) {
        SCRIPT_AssertCtrlLine();
    }
}
