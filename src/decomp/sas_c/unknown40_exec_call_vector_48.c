typedef signed long LONG;

extern void *INPUTDEVICE_LibraryBaseFromConsoleIo;
extern LONG _LVOexecPrivate3(void *base, void *arg0, void *arg1, LONG arg2, void *arg3);

LONG EXEC_CallVector_48(void *arg0, void *arg1, LONG arg2, void *arg3)
{
    return _LVOexecPrivate3(INPUTDEVICE_LibraryBaseFromConsoleIo, arg0, arg1, arg2, arg3);
}
