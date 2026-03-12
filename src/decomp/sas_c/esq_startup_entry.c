typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    EXECBASE_THIS_TASK_OFFSET = 276,
    TASK_SAVED_DIRLOCK_OFFSET = 152,
    TASK_CLI_FLAG_OFFSET = 172,
    TASK_STACKSIZE_OFFSET = 58,
    TASK_MSGPORT_OFFSET = 92,
    TASK_WINDOWPTR_OFFSET = 164,
    WBMSG_NUMARGS_OFFSET = 32,
    WBMSG_ARGLIST_OFFSET = 36,
    WBARG_LOCK_OFFSET = 0,
    WBARG_NAME_OFFSET = 4,
    CLI_BPTR_COMMAND_OFFSET = 16
};

extern void *AbsExecBase;
extern UBYTE BUFFER_5929_LONGWORDS[];
extern void *Global_SavedStackPointer;
extern void *Global_SavedExecBase;
extern void *Global_SavedMsg;
extern void *Global_DosLibrary;
extern LONG Global_SavedDirLock;
extern LONG Global_CommandLineSize;
extern char *Global_ScratchPtr_592;
extern LONG Global_WBStartupWindowPtr;
extern char Global_WBStartupCmdBuffer[];

extern void _LVOSetSignal(void *execBase, LONG oldMask, LONG newMask);
extern void * _LVOOpenLibrary(void *execBase, const char *name, LONG version);
extern void _LVOWaitPort(void *execBase, void *port);
extern void * _LVOGetMsg(void *execBase, void *port);
extern LONG _LVOCurrentDir(void *dosBase, LONG lock);
extern LONG _LVOSupervisor(void *dosBase, LONG code);

extern void ESQ_MainEntryNoOpHook(void);
extern LONG ESQ_ParseCommandLineAndRun(char *cmdline);
extern LONG ESQ_ShutdownAndReturn(LONG exitCode);

static void ESQ_CopyCString(char *dst, const char *src)
{
    while ((*dst++ = *src++) != 0) {
    }
}

static char *ESQ_BuildCliStartupCommand(UBYTE *currentTask, char *startupCmdString, LONG startupCmdLength)
{
    ULONG cliBptr;
    ULONG tailBptr;
    char *tail;
    char *dst;
    LONG tailLength;
    LONG i;

    cliBptr = *(ULONG *)(currentTask + TASK_CLI_FLAG_OFFSET);
    if (cliBptr == 0) {
        return startupCmdString;
    }

    tailBptr = *(ULONG *)((UBYTE *)(cliBptr << 2) + CLI_BPTR_COMMAND_OFFSET);
    if (tailBptr == 0) {
        return startupCmdString;
    }

    tail = (char *)(tailBptr << 2);
    tailLength = (LONG)(UBYTE)*tail++;
    Global_ScratchPtr_592 = tail;
    Global_CommandLineSize = startupCmdLength + tailLength + 128;

    dst = BUFFER_5929_LONGWORDS;
    for (i = 0; i < tailLength; ++i) {
        dst[i] = tail[i];
    }
    dst[tailLength] = ' ';
    for (i = 0; i < startupCmdLength; ++i) {
        dst[tailLength + 1 + i] = startupCmdString[i];
    }
    dst[tailLength + 1 + startupCmdLength] = 0;
    return dst;
}

LONG ESQ_StartupEntry(UBYTE *startupCmdString, LONG startupCmdLength)
{
    UBYTE *currentTask;
    char *cmdlinePtr;
    LONG i;

    for (i = 0; i <= 5928; ++i) {
        ((LONG *)BUFFER_5929_LONGWORDS)[i] = 0;
    }

    Global_SavedStackPointer = (void *)&startupCmdString;
    Global_SavedExecBase = AbsExecBase;
    Global_SavedMsg = (void *)0;
    _LVOSetSignal(AbsExecBase, 0, 0x3000);

    Global_DosLibrary = _LVOOpenLibrary(AbsExecBase, "dos.library", 0);
    if (Global_DosLibrary == (void *)0) {
        return ESQ_ShutdownAndReturn(100);
    }

    currentTask = *(UBYTE **)((UBYTE *)AbsExecBase + EXECBASE_THIS_TASK_OFFSET);
    Global_SavedDirLock = *(LONG *)(currentTask + TASK_SAVED_DIRLOCK_OFFSET);

    if (*(LONG *)(currentTask + TASK_CLI_FLAG_OFFSET) != 0) {
        cmdlinePtr = ESQ_BuildCliStartupCommand(currentTask, startupCmdString, startupCmdLength);
    } else {
        void *savedMsg;
        UBYTE *argList;

        Global_CommandLineSize = *(LONG *)(currentTask + TASK_STACKSIZE_OFFSET) + 128;
        _LVOWaitPort(AbsExecBase, currentTask + TASK_MSGPORT_OFFSET);
        savedMsg = _LVOGetMsg(AbsExecBase, currentTask + TASK_MSGPORT_OFFSET);
        Global_SavedMsg = savedMsg;

        argList = *(UBYTE **)((UBYTE *)savedMsg + WBMSG_ARGLIST_OFFSET);
        if (argList != (UBYTE *)0) {
            Global_SavedDirLock = *(LONG *)(argList + WBARG_LOCK_OFFSET);
            _LVOCurrentDir(Global_DosLibrary, Global_SavedDirLock);
        }

        if (*(LONG *)((UBYTE *)savedMsg + WBMSG_NUMARGS_OFFSET) != 0) {
            Global_WBStartupWindowPtr = _LVOSupervisor(Global_DosLibrary, 1005);
            if (Global_WBStartupWindowPtr != 0) {
                *(LONG *)(currentTask + TASK_WINDOWPTR_OFFSET) =
                    *(LONG *)((UBYTE *)(Global_WBStartupWindowPtr << 2) + 8);
            }
        }

        if (argList != (UBYTE *)0) {
            Global_ScratchPtr_592 = *(char **)(argList + WBARG_NAME_OFFSET);
            if (Global_ScratchPtr_592 != (char *)0) {
                ESQ_CopyCString(Global_WBStartupCmdBuffer, Global_ScratchPtr_592);
            } else {
                Global_WBStartupCmdBuffer[0] = 0;
            }
        } else {
            Global_ScratchPtr_592 = (char *)0;
            Global_WBStartupCmdBuffer[0] = 0;
        }

        cmdlinePtr = Global_WBStartupCmdBuffer;
    }

    ESQ_MainEntryNoOpHook();
    ESQ_ParseCommandLineAndRun(cmdlinePtr);
    return ESQ_ShutdownAndReturn(0);
}
