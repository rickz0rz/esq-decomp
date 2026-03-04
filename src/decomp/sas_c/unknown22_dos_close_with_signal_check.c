typedef signed long LONG;

extern LONG Global_SignalCallbackPtr;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVOClose(void *dosBase, LONG fh);

LONG DOS_CloseWithSignalCheck(LONG fileHandle)
{
    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    _LVOClose(Global_DosLibrary, fileHandle);
    return 0;
}
