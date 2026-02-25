#include "esq_types.h"

/*
 * Target 032 GCC trial function.
 * Write wrapper that tracks Global_DosIoErr and Global_AppErrorCode.
 */
extern u32 Global_SignalCallbackPtr;
extern u32 Global_DosIoErr;
extern u32 Global_AppErrorCode;

void SIGNAL_PollAndDispatch(void);
s32 DOS_Write(s32 handle, void *buffer, s32 length);
s32 DOS_IoErr(void);

s32 DOS_WriteWithErrorState(s32 handle, void *buffer, s32 length) __attribute__((noinline, used));

s32 DOS_WriteWithErrorState(s32 handle, void *buffer, s32 length)
{
    s32 result;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    result = DOS_Write(handle, buffer, length);
    if (result == -1) {
        Global_DosIoErr = (u32)DOS_IoErr();
        Global_AppErrorCode = 5;
    }

    return result;
}
