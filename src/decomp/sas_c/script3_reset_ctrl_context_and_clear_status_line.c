extern char SCRIPT_CTRL_CONTEXT[];
extern void TEXTDISP_HandleScriptCommand(long command, long mode, char *arg);
extern void SCRIPT_ResetCtrlContext(char *ctx);

void SCRIPT_ResetCtrlContextAndClearStatusLine(void)
{
    TEXTDISP_HandleScriptCommand(0xFFFFFFFFL, 0xFFFFFFFFL, (char *)0);
    SCRIPT_ResetCtrlContext(SCRIPT_CTRL_CONTEXT);
}
