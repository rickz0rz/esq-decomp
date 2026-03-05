extern unsigned short SCRIPT_CTRL_CONTEXT[];
extern void TEXTDISP_HandleScriptCommand(long command, long mode, long arg);
extern void SCRIPT_ResetCtrlContext(void *ctx);

void SCRIPT_ResetCtrlContextAndClearStatusLine(void)
{
    TEXTDISP_HandleScriptCommand(0xFFFFFFFFL, 0xFFFFFFFFL, 0L);
    SCRIPT_ResetCtrlContext(SCRIPT_CTRL_CONTEXT);
}
