void SCRIPT_DeassertCtrlLine(void) __attribute__((noinline));

void SCRIPT_DeassertCtrlLineNow(void) __attribute__((noinline, used));

void SCRIPT_DeassertCtrlLineNow(void)
{
    SCRIPT_DeassertCtrlLine();
}
