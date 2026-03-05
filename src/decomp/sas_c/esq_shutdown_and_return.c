typedef signed long LONG;

extern void *Global_ExitHookPtr;
extern void *Global_DosLibrary;
extern void *Global_SavedMsg;
extern LONG Global_WBStartupWindowPtr;
extern void *Global_SavedStackPointer;

extern void GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(void);
extern void GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(void);

extern void CloseLibrary(void *lib);
extern void execPrivate1(LONG arg);
extern void Forbid(void);
extern void ReplyMsg(void *msg);

LONG ESQ_ShutdownAndReturn(LONG exit_code)
{
    if (Global_ExitHookPtr != (void *)0) {
        ((void (*)(void))Global_ExitHookPtr)();
    }

    GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll();
    CloseLibrary(Global_DosLibrary);
    GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook();

    if (Global_SavedMsg != (void *)0) {
        if (Global_WBStartupWindowPtr != 0) {
            execPrivate1(Global_WBStartupWindowPtr);
        }
        Forbid();
        ReplyMsg(Global_SavedMsg);
    }

    /* Stack/register restoration is handled by original startup/teardown scaffolding. */
    (void)Global_SavedStackPointer;
    return exit_code;
}
