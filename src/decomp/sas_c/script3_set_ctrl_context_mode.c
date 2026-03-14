#include <exec/types.h>
typedef struct SCRIPT_CtrlContext {
    UWORD mode0;
    UWORD active2;
} SCRIPT_CtrlContext;

extern void SCRIPT_ResetCtrlContext(char *ctx);

void SCRIPT_SetCtrlContextMode(char *ctx, UWORD mode)
{
    SCRIPT_CtrlContext *ctxView = (SCRIPT_CtrlContext *)ctx;

    ctxView->mode0 = mode;
    ctxView->active2 = 1;
    SCRIPT_ResetCtrlContext(ctx);
}
