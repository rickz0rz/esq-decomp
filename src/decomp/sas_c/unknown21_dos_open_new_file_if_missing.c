typedef signed long LONG;

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVOLock(void *dosBase, const char *name, LONG mode);
extern void _LVOUnLock(void *dosBase, LONG lock);
extern LONG _LVOOpen(void *dosBase, const char *name, LONG mode);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_OpenNewFileIfMissing(const char *filename)
{
    LONG lockHandle;
    LONG fileHandle;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;

    lockHandle = _LVOLock(Global_DosLibrary, filename, -2);
    if (lockHandle != 0) {
        _LVOUnLock(Global_DosLibrary, lockHandle);
        return -1;
    }

    fileHandle = _LVOOpen(Global_DosLibrary, filename, 1006);
    if (fileHandle == 0) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 2;
        return -1;
    }

    return fileHandle;
}
