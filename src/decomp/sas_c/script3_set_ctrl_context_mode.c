typedef unsigned short UWORD;

extern void SCRIPT_ResetCtrlContext(void *ctx);

void SCRIPT_SetCtrlContextMode(void *ctx, UWORD mode)
{
    *(UWORD *)((unsigned char *)ctx + 0) = mode;
    *(UWORD *)((unsigned char *)ctx + 2) = 1;
    SCRIPT_ResetCtrlContext(ctx);
}
