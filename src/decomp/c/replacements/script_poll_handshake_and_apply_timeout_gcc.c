#include "esq_types.h"

extern s16 SCRIPT_CtrlInterfaceEnabledFlag;
extern s16 SCRIPT_CtrlLineAssertedTicks;
extern s16 ESQIFF_ExternalAssetFlags;
extern s16 LADFUNC_EntryCount;

s32 SCRIPT_ReadHandshakeBit5Mask(void) __attribute__((noinline));

void SCRIPT_PollHandshakeAndApplyTimeout(void) __attribute__((noinline, used));

void SCRIPT_PollHandshakeAndApplyTimeout(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag == 0) {
        return;
    }

    if ((u8)SCRIPT_ReadHandshakeBit5Mask() == 0) {
        return;
    }

    SCRIPT_CtrlLineAssertedTicks = (s16)(SCRIPT_CtrlLineAssertedTicks + 1);
    if (SCRIPT_CtrlLineAssertedTicks >= 20) {
        ESQIFF_ExternalAssetFlags = 0;
        LADFUNC_EntryCount = 0x24;
        SCRIPT_CtrlLineAssertedTicks = 0;
    }
}
