typedef signed long LONG;

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern LONG SIGNAL_PollAndDispatch(void);
extern LONG _LVOWrite(void *dosBase, LONG fh, void *buffer, LONG len);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_WriteWithErrorState(LONG fileHandle, void *buffer, LONG length)
{
    LONG writeResult;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    writeResult = _LVOWrite(Global_DosLibrary, fileHandle, buffer, length);
    if (writeResult == -1) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 5;
    }

    return writeResult;
}
