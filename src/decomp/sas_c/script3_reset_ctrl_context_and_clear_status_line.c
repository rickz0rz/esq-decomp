typedef unsigned char UBYTE;

extern char SCRIPT_CTRL_CONTEXT[];
extern long TEXTDISP_HandleScriptCommand(UBYTE scriptType, UBYTE command, char *arg);
extern void SCRIPT_ResetCtrlContext(char *ctx);

void SCRIPT_ResetCtrlContextAndClearStatusLine(void)
{
    TEXTDISP_HandleScriptCommand((UBYTE)0xffu, (UBYTE)0xffu, (char *)0);
    SCRIPT_ResetCtrlContext(SCRIPT_CTRL_CONTEXT);
}
