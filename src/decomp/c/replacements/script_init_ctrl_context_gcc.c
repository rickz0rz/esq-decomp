#include "esq_types.h"

extern u8 SCRIPT_CTRL_CONTEXT[];

void SCRIPT_SetCtrlContextMode(u8 *ctx, s32 mode) __attribute__((noinline));

void SCRIPT_InitCtrlContext(void) __attribute__((noinline, used));

void SCRIPT_InitCtrlContext(void)
{
    SCRIPT_SetCtrlContextMode(SCRIPT_CTRL_CONTEXT, 1);
}
