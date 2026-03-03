void SCRIPT_AssertCtrlLine(void) __attribute__((noinline));

void SCRIPT_AssertCtrlLineNow(void) __attribute__((noinline, used));

void SCRIPT_AssertCtrlLineNow(void)
{
    SCRIPT_AssertCtrlLine();
}
