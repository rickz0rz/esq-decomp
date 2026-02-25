#include "esq_types.h"

/*
 * Target 034 GCC trial function.
 * Seek wrapper that tracks Global_DosIoErr and Global_AppErrorCode.
 */
extern u32 Global_SignalCallbackPtr;
extern u32 Global_DosIoErr;
extern u32 Global_AppErrorCode;

void SIGNAL_PollAndDispatch(void);
s32 DOS_Seek(s32 handle, s32 offset, s32 mode);
s32 DOS_IoErr(void);

s32 DOS_SeekWithErrorState(s32 handle, s32 offset, s32 mode) __attribute__((noinline, used));

s32 DOS_SeekWithErrorState(s32 handle, s32 offset, s32 mode)
{
    s32 seek_result;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    seek_result = DOS_Seek(handle, offset, mode - 2);

    if (seek_result == -1) {
        Global_DosIoErr = (u32)DOS_IoErr();
        Global_AppErrorCode = 22;
    }

    if (mode == 2) {
        return DOS_Seek(handle, 0, 1);
    }
    if (mode == 1) {
        return seek_result + offset;
    }
    if (mode == 0) {
        return offset;
    }

    return seek_result;
}
