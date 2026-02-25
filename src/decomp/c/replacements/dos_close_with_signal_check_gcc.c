#include "esq_types.h"

/*
 * Target 037 GCC trial function.
 * Close wrapper with optional signal callback dispatch.
 */
extern u32 Global_SignalCallbackPtr;

void SIGNAL_PollAndDispatch(void);
s32 DOS_Close(s32 handle);

s32 DOS_CloseWithSignalCheck(s32 handle) __attribute__((noinline, used));

s32 DOS_CloseWithSignalCheck(s32 handle)
{
    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    DOS_Close(handle);
    return 0;
}
