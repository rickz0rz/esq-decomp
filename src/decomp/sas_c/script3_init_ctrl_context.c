extern unsigned short SCRIPT_CTRL_CONTEXT[];
extern void SCRIPT_SetCtrlContextMode(void *ctx, unsigned short mode);

void SCRIPT_InitCtrlContext(void)
{
    SCRIPT_SetCtrlContextMode(SCRIPT_CTRL_CONTEXT, 1);
}
