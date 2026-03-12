typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void *AbsExecBase;
extern ULONG Global_ArgCount;
extern char *Global_ArgvStorage[];
extern char **Global_ArgvPtr;
extern char *Global_SavedMsg;
extern char Global_ConsoleNameBuffer[];
extern void *Global_DosLibrary;

extern LONG Global_HandleEntry0_Ptr;
extern ULONG Global_HandleEntry0_Flags;
extern LONG Global_HandleEntry1_Ptr;
extern ULONG Global_HandleEntry1_Flags;
extern LONG Global_HandleEntry2_Ptr;
extern ULONG Global_HandleEntry2_Flags;

extern ULONG Global_DefaultHandleFlags;
extern ULONG Global_PreallocHandleNode0_HandleIndex;
extern ULONG Global_PreallocHandleNode0_OpenFlags;
extern ULONG Global_PreallocHandleNode1_HandleIndex;
extern ULONG Global_PreallocHandleNode1_OpenFlags;
extern ULONG Global_PreallocHandleNode2_HandleIndex;
extern ULONG Global_PreallocHandleNode2_OpenFlags;
extern ULONG Global_SignalCallbackPtr;

extern char *STRING_AppendN(char *dst, const char *src, ULONG max_bytes);
extern LONG HANDLE_CloseAllAndReturnWithCode(LONG code);
extern LONG UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(LONG argc, char **argv);
extern LONG BUFFER_FlushAllAndCloseWithCode(LONG code);
extern LONG UNKNOWN36_ShowAbortRequester(void);

extern LONG _LVOOpen(void *dosBase, const char *name, LONG mode);
extern LONG _LVOInput(void *dosBase);
extern LONG _LVOOutput(void *dosBase);
extern UBYTE *_LVOFindTask(void *execBase, void *taskName);

#define MODE_OLDFILE 1005
#define MODE_NEWFILE 1006

typedef struct ESQ_WBArgRecord {
    ULONG lock0;
    char *namePtr4;
} ESQ_WBArgRecord;

typedef struct ESQ_WBStartupMsg {
    UBYTE pad0[36];
    ESQ_WBArgRecord *argList36;
} ESQ_WBStartupMsg;

LONG ESQ_ParseCommandLineAndRun(char *cmdline)
{
    static const char kConsolePrefix[] = "con.10/10/320/80/";
    char *p = cmdline;

    while (Global_ArgCount < 32UL) {
        char **argvSlot;

        while (*p == (UBYTE)' ' || *p == (UBYTE)'\t' || *p == (UBYTE)'\n') {
            ++p;
        }

        if (*p == 0) {
            break;
        }

        argvSlot = &Global_ArgvStorage[Global_ArgCount];
        ++Global_ArgCount;

        if (*p == (UBYTE)'"') {
            ++p;
            *argvSlot = p;

            while (*p != 0 && *p != (UBYTE)'"') {
                ++p;
            }

            if (*p == 0) {
                HANDLE_CloseAllAndReturnWithCode(1);
                continue;
            }

            *p++ = 0;
            continue;
        }

        *argvSlot = p;
        while (*p != 0 && *p != (UBYTE)' ' && *p != (UBYTE)'\t' && *p != (UBYTE)'\n') {
            ++p;
        }

        if (*p == 0) {
            break;
        }

        *p++ = 0;
    }

    if (Global_ArgCount == 0) {
        Global_ArgvPtr = (char **)Global_SavedMsg;
    } else {
        Global_ArgvPtr = Global_ArgvStorage;
    }

    if (Global_ArgCount == 0) {
        ESQ_WBStartupMsg *savedMsg = (ESQ_WBStartupMsg *)Global_SavedMsg;
        ESQ_WBArgRecord *argRecord = savedMsg->argList36;
        LONG handle;
        const char *src = kConsolePrefix;
        char *dst = Global_ConsoleNameBuffer;

        do {
            *dst++ = *src;
        } while (*src++ != '\0');

        STRING_AppendN(Global_ConsoleNameBuffer, argRecord->namePtr4, 40UL);
        handle = _LVOOpen(Global_DosLibrary, Global_ConsoleNameBuffer, MODE_NEWFILE);

        Global_HandleEntry0_Ptr = handle;
        Global_HandleEntry1_Ptr = handle;
        Global_HandleEntry1_Flags = 16UL;
        Global_HandleEntry2_Ptr = handle;
        Global_HandleEntry2_Flags = 16UL;

        *(ULONG *)((UBYTE *)_LVOFindTask(AbsExecBase, (void *)0) + 164) =
            *(ULONG *)((((ULONG)handle) << 2) + 8);
    } else {
        Global_HandleEntry0_Ptr = _LVOInput(Global_DosLibrary);
        Global_HandleEntry1_Ptr = _LVOOutput(Global_DosLibrary);
        Global_HandleEntry2_Ptr = _LVOOpen(Global_DosLibrary, "*", MODE_OLDFILE);
    }

    {
        ULONG d7;
        ULONG baseFlags;

        if (Global_ArgCount == 0) {
            d7 = 0UL;
        } else {
            d7 = 16UL;
        }

        Global_HandleEntry0_Flags |= (d7 | 0x8001UL);
        Global_HandleEntry1_Flags |= (d7 | 0x8002UL);
        Global_HandleEntry2_Flags |= 0x8003UL;

        if (Global_DefaultHandleFlags == 0) {
            baseFlags = 0x8000UL;
        } else {
            baseFlags = 0UL;
        }

        Global_PreallocHandleNode0_HandleIndex = 0UL;
        Global_PreallocHandleNode0_OpenFlags = (baseFlags | 1UL);
        Global_PreallocHandleNode1_HandleIndex = 1UL;
        Global_PreallocHandleNode1_OpenFlags = (baseFlags | 2UL);
        Global_PreallocHandleNode2_HandleIndex = 2UL;
        Global_PreallocHandleNode2_OpenFlags = (baseFlags | 0x80UL);
    }

    Global_SignalCallbackPtr = (ULONG)UNKNOWN36_ShowAbortRequester;
    UNKNOWN29_JMPTBL_ESQ_MainInitAndRun((LONG)Global_ArgCount, Global_ArgvPtr);
    return BUFFER_FlushAllAndCloseWithCode(0);
}
