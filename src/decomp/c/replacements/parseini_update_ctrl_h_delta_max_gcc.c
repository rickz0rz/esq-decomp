#include "esq_types.h"

extern u16 CTRL_H;
extern u16 CTRL_HPreviousSample;
extern u16 CTRL_HDeltaMax;

s32 PARSEINI_UpdateCtrlHDeltaMax(void) __attribute__((noinline, used));

s32 PARSEINI_UpdateCtrlHDeltaMax(void)
{
    s32 delta = (s32)(u16)CTRL_H - (s32)(u16)CTRL_HPreviousSample;
    if (delta < 0) {
        delta += 500;
    }

    if ((s32)(u16)CTRL_HDeltaMax < delta) {
        CTRL_HDeltaMax = (u16)delta;
    }

    return delta;
}
