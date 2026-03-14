#include <exec/types.h>
extern void *AbsExecBase;
extern void *Global_ExitHookPtr;
extern void *Global_DosLibrary;
extern void *Global_SavedMsg;
extern LONG Global_WBStartupWindowPtr;
extern void *Global_SavedStackPointer;

extern void MEMLIST_FreeAll(void);
extern void ESQ_MainExitNoOpHook(void);

extern void _LVOCloseLibrary(void *execBase, void *lib);
extern void _LVOexecPrivate1(void *execBase, LONG arg);
extern void _LVOForbid(void *execBase);
extern void _LVOReplyMsg(void *execBase, void *msg);

LONG ESQ_ShutdownAndReturn(LONG exit_code)
{
    if (Global_ExitHookPtr != (void *)0) {
        ((void (*)(void))Global_ExitHookPtr)();
    }

    MEMLIST_FreeAll();
    _LVOCloseLibrary(AbsExecBase, Global_DosLibrary);
    ESQ_MainExitNoOpHook();

    if (Global_SavedMsg != (void *)0) {
        if (Global_WBStartupWindowPtr != 0) {
            _LVOexecPrivate1(AbsExecBase, Global_WBStartupWindowPtr);
        }
        _LVOForbid(AbsExecBase);
        _LVOReplyMsg(AbsExecBase, Global_SavedMsg);
    }

    /* Stack/register restoration is handled by original startup/teardown scaffolding. */
    (void)Global_SavedStackPointer;
    return exit_code;
}
