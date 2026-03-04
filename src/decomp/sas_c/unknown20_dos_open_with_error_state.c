typedef signed long LONG;

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVOOpen(void *dosBase, const char *path, LONG mode);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_OpenWithErrorState(const char *path, LONG mode)
{
    LONG handle;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    handle = _LVOOpen(Global_DosLibrary, path, mode);
    if (handle == 0) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 2;
        return -1;
    }

    return handle;
}
