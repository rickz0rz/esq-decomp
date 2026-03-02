#include "esq_types.h"

extern u8 *Global_ExitHookPtr;
extern u8 *Global_DosLibrary;
extern u8 *Global_SavedMsg;
extern u8 *Global_WBStartupWindowPtr;

void GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(void) __attribute__((noinline));
void GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(void) __attribute__((noinline));
void _LVOCloseLibrary(void *library) __attribute__((noinline));
void _LVOexecPrivate1(void *window_ptr) __attribute__((noinline));
void _LVOForbid(void) __attribute__((noinline));
void _LVOReplyMsg(void *msg) __attribute__((noinline));

s32 ESQ_ShutdownAndReturn(s32 exit_code) __attribute__((noinline, used));

s32 ESQ_ShutdownAndReturn(s32 exit_code)
{
    if (Global_ExitHookPtr != (u8 *)0) {
        ((void (*)(void))Global_ExitHookPtr)();
    }

    GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll();
    _LVOCloseLibrary(Global_DosLibrary);
    GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook();

    if (Global_SavedMsg != (u8 *)0) {
        if (Global_WBStartupWindowPtr != (u8 *)0) {
            _LVOexecPrivate1(Global_WBStartupWindowPtr);
        }
        _LVOForbid();
        _LVOReplyMsg(Global_SavedMsg);
    }

    return exit_code;
}
