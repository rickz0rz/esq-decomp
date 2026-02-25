#include "esq_types.h"

/*
 * Target 044 GCC trial function.
 * If file exists, return -1; otherwise open MODE_NEWFILE.
 */
extern u32 Global_SignalCallbackPtr;
extern u32 Global_DosIoErr;
extern u32 Global_AppErrorCode;

void SIGNAL_PollAndDispatch(void);
s32 DOS_Lock(const char *name, s32 mode);
void DOS_UnLock(s32 lock);
s32 DOS_Open(const char *name, s32 mode);
s32 DOS_IoErr(void);

s32 DOS_OpenNewFileIfMissing(const char *filename) __attribute__((noinline, used));

s32 DOS_OpenNewFileIfMissing(const char *filename)
{
    s32 lock;
    s32 fh;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    lock = DOS_Lock(filename, -2);
    if (lock != 0) {
        DOS_UnLock(lock);
        return -1;
    }

    fh = DOS_Open(filename, 1006);
    if (fh == 0) {
        Global_DosIoErr = (u32)DOS_IoErr();
        Global_AppErrorCode = 2;
        return -1;
    }

    return fh;
}
