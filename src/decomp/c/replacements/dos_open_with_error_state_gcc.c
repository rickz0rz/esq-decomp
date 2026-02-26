#include "esq_types.h"

/*
 * Target 066 GCC trial function.
 * Open wrapper that tracks Global_DosIoErr and Global_AppErrorCode.
 */
extern u32 Global_SignalCallbackPtr;
extern u32 Global_DosIoErr;
extern u32 Global_AppErrorCode;

void SIGNAL_PollAndDispatch(void);
s32 DOS_Open(const char *name, s32 mode);
s32 DOS_IoErr(void);

s32 DOS_OpenWithErrorState(const char *path, s32 mode) __attribute__((noinline, used));

s32 DOS_OpenWithErrorState(const char *path, s32 mode)
{
    s32 handle;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    handle = DOS_Open(path, mode);
    if (handle == 0) {
        Global_DosIoErr = (u32)DOS_IoErr();
        Global_AppErrorCode = 2;
        return -1;
    }

    return handle;
}
