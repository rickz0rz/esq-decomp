#include "esq_types.h"

void SCRIPT_ResetCtrlContext(u8 *ctx) __attribute__((noinline));

void SCRIPT_SetCtrlContextMode(u8 *ctx, s32 mode) __attribute__((noinline, used));

void SCRIPT_SetCtrlContextMode(u8 *ctx, s32 mode)
{
    *(s16 *)(ctx + 0) = (s16)mode;
    *(s16 *)(ctx + 2) = 1;
    SCRIPT_ResetCtrlContext(ctx);
}
