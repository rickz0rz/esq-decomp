typedef signed long LONG;
typedef LONG (*SignalCallback)(void);

extern void *AbsExecBase;
extern LONG Global_SignalCallbackPtr;

extern LONG _LVOSetSignal(void *execBase, LONG newSignals, LONG signalMask);
extern LONG HANDLE_CloseAllAndReturnWithCode(LONG code);

void SIGNAL_PollAndDispatch(void)
{
    LONG pending;

    pending = _LVOSetSignal(AbsExecBase, 0, 0x3000);
    if ((pending & 0x3000) == 0) {
        return;
    }

    if (Global_SignalCallbackPtr == 0) {
        return;
    }

    if (((SignalCallback)Global_SignalCallbackPtr)() != 0) {
        Global_SignalCallbackPtr = 0;
        (void)HANDLE_CloseAllAndReturnWithCode(20);
    }
}
