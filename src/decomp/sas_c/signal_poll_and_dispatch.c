#include <exec/types.h>

typedef LONG (*SignalCallback)(void);

extern LONG Global_SignalCallbackPtr;
extern LONG HANDLE_CloseAllAndReturnWithCode(LONG code);
extern void *AbsExecBase;

extern LONG _LVOSetSignal(void *execBase, LONG newSignals, LONG signalMask);

LONG SIGNAL_PollAndDispatch(void)
{
    LONG pending;

    pending = _LVOSetSignal(AbsExecBase, 0, 0x3000);
    if ((pending & 0x3000) != 0) {
        if (Global_SignalCallbackPtr != 0) {
            if (((SignalCallback)Global_SignalCallbackPtr)() != 0) {
                Global_SignalCallbackPtr = 0;
                return HANDLE_CloseAllAndReturnWithCode(20);
            }
        }
    }

    return pending;
}
