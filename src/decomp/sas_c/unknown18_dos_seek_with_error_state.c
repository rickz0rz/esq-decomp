typedef signed long LONG;

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVOSeek(void *dosBase, LONG fh, LONG offset, LONG mode);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_SeekWithErrorState(LONG fileHandle, LONG offset, LONG mode)
{
    LONG seekResult;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    seekResult = _LVOSeek(Global_DosLibrary, fileHandle, offset, mode - 1);
    if (seekResult == -1) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 22;
    }

    if (mode == 2) {
        return _LVOSeek(Global_DosLibrary, fileHandle, 0, 0);
    }

    if (mode == 1) {
        return seekResult + offset;
    }

    if (mode == 0) {
        return offset;
    }

    return seekResult;
}
