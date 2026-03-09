typedef signed long LONG;

extern void ESQ_MainExitNoOpHook(void);
extern void ESQ_MainEntryNoOpHook(void);
extern void MEMLIST_FreeAll(void);
extern LONG ESQ_ParseCommandLineAndRun(char *cmdline);

void GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(void)
{
    ESQ_MainExitNoOpHook();
}

void GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook(void)
{
    ESQ_MainEntryNoOpHook();
}

void GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(void)
{
    MEMLIST_FreeAll();
}

LONG GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(char *cmdline)
{
    return ESQ_ParseCommandLineAndRun(cmdline);
}
