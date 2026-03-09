typedef unsigned short UWORD;

typedef struct SCRIPT_CtrlContext {
    UWORD mode0;
    UWORD active2;
} SCRIPT_CtrlContext;

extern void SCRIPT_ResetCtrlContext(void *ctx);

void SCRIPT_SetCtrlContextMode(void *ctx, UWORD mode)
{
    SCRIPT_CtrlContext *ctxView = (SCRIPT_CtrlContext *)ctx;

    ctxView->mode0 = mode;
    ctxView->active2 = 1;
    SCRIPT_ResetCtrlContext(ctx);
}
