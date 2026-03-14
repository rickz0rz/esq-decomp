#include <exec/types.h>
extern void *AbsExecBase;
extern void *Global_REF_INTUITION_LIBRARY;
extern LONG Global_REF_BACKED_UP_INTUITION_AUTOREQUEST;
extern LONG Global_REF_BACKED_UP_INTUITION_DISPLAYALERT;

extern LONG _LVOAutoRequest;
extern LONG _LVODisplayAlert;

extern LONG _LVOSetFunction(void *execBase, void *libraryBase, void *offset, LONG newFunc);

extern LONG LOCAVAIL2_AutoRequestNoOp(void);
extern LONG LOCAVAIL2_DisplayAlertDelayAndReboot(void);

void OVERRIDE_INTUITION_FUNCS(void)
{
    LONG oldFn;

    oldFn = _LVOSetFunction(
        AbsExecBase,
        Global_REF_INTUITION_LIBRARY,
        (void *)(LONG)_LVOAutoRequest,
        (LONG)LOCAVAIL2_AutoRequestNoOp);
    Global_REF_BACKED_UP_INTUITION_AUTOREQUEST = oldFn;

    oldFn = _LVOSetFunction(
        AbsExecBase,
        Global_REF_INTUITION_LIBRARY,
        (void *)(LONG)_LVODisplayAlert,
        (LONG)LOCAVAIL2_DisplayAlertDelayAndReboot);
    Global_REF_BACKED_UP_INTUITION_DISPLAYALERT = oldFn;
}
