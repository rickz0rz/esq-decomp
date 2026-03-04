typedef signed long LONG;

typedef void (*SignalCallbackFn)(void);

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVORead(void *dosBase, LONG fh, void *buffer, LONG len);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_ReadWithErrorState(LONG fileHandle, void *buffer, LONG length)
{
    LONG readResult;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    readResult = _LVORead(Global_DosLibrary, fileHandle, buffer, length);
    if (readResult == -1) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 5;
    }

    return readResult;
}
