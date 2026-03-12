typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern ULONG Global_ArgCount;
extern char *Global_ArgvStorage[];
extern char **Global_ArgvPtr;
extern char *Global_SavedMsg;
extern char Global_ConsoleNameBuffer[];
extern ULONG Global_DosLibrary;

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
extern LONG ESQ_MainInitAndRun(LONG argc, char **argv);
extern LONG BUFFER_FlushAllAndCloseWithCode(LONG code);
extern LONG UNKNOWN36_ShowAbortRequester(void);

extern LONG DOS_LVO_OPEN(const char *name, LONG mode);
extern LONG DOS_LVO_INPUT(void);
extern LONG DOS_LVO_OUTPUT(void);
extern UBYTE *EXEC_FIND_TASK_NULL(void);

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
    char *p = cmdline;

    while (Global_ArgCount < 32UL) {
        while (*p == (UBYTE)' ' || *p == (UBYTE)'\t' || *p == (UBYTE)'\n') {
            ++p;
        }

        if (*p == 0) {
            break;
        }

        {
            ULONG slot = Global_ArgCount;
            Global_ArgCount = slot + 1UL;

            if (*p == (UBYTE)'"') {
                ++p;
                Global_ArgvStorage[slot] = p;

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

            Global_ArgvStorage[slot] = p;
            while (*p != 0 && *p != (UBYTE)' ' && *p != (UBYTE)'\t' && *p != (UBYTE)'\n') {
                ++p;
            }

            if (*p == 0) {
                break;
            }

            *p++ = 0;
        }
    }

    if (Global_ArgCount == 0) {
        Global_ArgvPtr = (char **)Global_SavedMsg;
    } else {
        Global_ArgvPtr = Global_ArgvStorage;
    }

    if (Global_ArgCount == 0) {
        static const char kConsolePrefix[] = "con.10/10/320/80/";
        ESQ_WBStartupMsg *saved_msg = (ESQ_WBStartupMsg *)Global_SavedMsg;
        ESQ_WBArgRecord *arg_record = saved_msg->argList36;
        char *append_src = arg_record->namePtr4;
        LONG h;
        UBYTE *task;
        UBYTE *fh_ptr;
        ULONG i = 0;

        do {
            Global_ConsoleNameBuffer[i] = kConsolePrefix[i];
        } while (kConsolePrefix[i++] != 0);

        STRING_AppendN(Global_ConsoleNameBuffer, append_src, 40UL);
        h = DOS_LVO_OPEN(Global_ConsoleNameBuffer, MODE_NEWFILE);

        Global_HandleEntry0_Ptr = h;
        Global_HandleEntry1_Ptr = h;
        Global_HandleEntry1_Flags = 16UL;
        Global_HandleEntry2_Ptr = h;
        Global_HandleEntry2_Flags = 16UL;

        fh_ptr = (UBYTE *)(((ULONG)h) << 2);
        task = EXEC_FIND_TASK_NULL();
        *(ULONG *)(task + 164) = *(ULONG *)(fh_ptr + 8);
    } else {
        Global_HandleEntry0_Ptr = DOS_LVO_INPUT();
        Global_HandleEntry1_Ptr = DOS_LVO_OUTPUT();
        Global_HandleEntry2_Ptr = DOS_LVO_OPEN("*", MODE_OLDFILE);
    }

    {
        ULONG d7 = (Global_ArgCount == 0) ? 0UL : 16UL;
        ULONG base_flags;

        Global_HandleEntry0_Flags |= (d7 | 0x8001UL);
        Global_HandleEntry1_Flags |= (d7 | 0x8002UL);
        Global_HandleEntry2_Flags |= 0x8003UL;

        if (Global_DefaultHandleFlags == 0) {
            base_flags = 0x8000UL;
        } else {
            base_flags = 0UL;
        }

        Global_PreallocHandleNode0_HandleIndex = 0UL;
        Global_PreallocHandleNode0_OpenFlags = (base_flags | 1UL);
        Global_PreallocHandleNode1_HandleIndex = 1UL;
        Global_PreallocHandleNode1_OpenFlags = (base_flags | 2UL);
        Global_PreallocHandleNode2_HandleIndex = 2UL;
        Global_PreallocHandleNode2_OpenFlags = (base_flags | 0x80UL);
    }

    Global_SignalCallbackPtr = (ULONG)(UBYTE *)&UNKNOWN36_ShowAbortRequester;
    ESQ_MainInitAndRun((LONG)Global_ArgCount, Global_ArgvPtr);
    return BUFFER_FlushAllAndCloseWithCode(0);
}
