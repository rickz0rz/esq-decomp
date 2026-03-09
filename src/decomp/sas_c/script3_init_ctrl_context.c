extern char SCRIPT_CTRL_CONTEXT[];
extern void SCRIPT_SetCtrlContextMode(char *ctx, unsigned short mode);

void SCRIPT_InitCtrlContext(void)
{
    SCRIPT_SetCtrlContextMode(SCRIPT_CTRL_CONTEXT, 1);
}
