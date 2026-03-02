#include "esq_types.h"

extern u8 SCRIPT_CTRL_CONTEXT[];

void TEXTDISP_HandleScriptCommand(s32 command, s32 arg1, s32 arg2) __attribute__((noinline));
void SCRIPT_ResetCtrlContext(u8 *ctx) __attribute__((noinline));

void SCRIPT_ResetCtrlContextAndClearStatusLine(void) __attribute__((noinline, used));

void SCRIPT_ResetCtrlContextAndClearStatusLine(void)
{
    TEXTDISP_HandleScriptCommand(-1, -1, 0);
    SCRIPT_ResetCtrlContext(SCRIPT_CTRL_CONTEXT);
}
