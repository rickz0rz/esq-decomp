#include "esq_types.h"

extern s16 SCRIPT_CtrlLineAssertedFlag;

s32 SCRIPT_GetCtrlLineFlag(void) __attribute__((noinline, used));

s32 SCRIPT_GetCtrlLineFlag(void)
{
    return (s32)SCRIPT_CtrlLineAssertedFlag;
}
