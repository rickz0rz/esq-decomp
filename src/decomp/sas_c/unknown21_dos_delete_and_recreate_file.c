typedef signed long LONG;

enum {
    ACCESS_READ = -2,
    MODE_NEWFILE = 1006
};

extern LONG Global_SignalCallbackPtr;
extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern void *Global_DosLibrary;

extern void SIGNAL_PollAndDispatch(void);
extern LONG _LVOLock(void *dosBase, char *name, LONG mode);
extern void _LVOUnLock(void *dosBase, LONG lock);
extern LONG _LVODeleteFile(void *dosBase, char *name);
extern LONG _LVOOpen(void *dosBase, char *name, LONG mode);
extern LONG _LVOIoErr(void *dosBase);

LONG DOS_DeleteAndRecreateFile(char *filename)
{
    LONG lock;
    LONG handle;

    if (Global_SignalCallbackPtr != 0) {
        SIGNAL_PollAndDispatch();
    }

    Global_DosIoErr = 0;
    lock = _LVOLock(Global_DosLibrary, filename, ACCESS_READ);
    if (lock != 0) {
        _LVOUnLock(Global_DosLibrary, lock);
        _LVODeleteFile(Global_DosLibrary, filename);
    }

    handle = _LVOOpen(Global_DosLibrary, filename, MODE_NEWFILE);
    if (handle == 0) {
        Global_DosIoErr = _LVOIoErr(Global_DosLibrary);
        Global_AppErrorCode = 2;
        return -1;
    }

    return handle;
}
