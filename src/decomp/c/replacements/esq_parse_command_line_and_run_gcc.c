#include "esq_types.h"

/*
 * Target 085 GCC trial function.
 * Parse command-line tokens, initialize runtime handles, then enter main.
 */
extern u32 Global_ArgCount;
extern u8 *Global_ArgvStorage[];
extern u8 **Global_ArgvPtr;
extern u8 *Global_SavedMsg;
extern u8 Global_ConsoleNameBuffer[];
extern u32 Global_DosLibrary;

extern s32 Global_HandleEntry0_Ptr;
extern u32 Global_HandleEntry0_Flags;
extern s32 Global_HandleEntry1_Ptr;
extern u32 Global_HandleEntry1_Flags;
extern s32 Global_HandleEntry2_Ptr;
extern u32 Global_HandleEntry2_Flags;

extern u32 Global_DefaultHandleFlags;
extern u32 Global_PreallocHandleNode0_HandleIndex;
extern u32 Global_PreallocHandleNode0_OpenFlags;
extern u32 Global_PreallocHandleNode1_HandleIndex;
extern u32 Global_PreallocHandleNode1_OpenFlags;
extern u32 Global_PreallocHandleNode2_HandleIndex;
extern u32 Global_PreallocHandleNode2_OpenFlags;
extern u32 Global_SignalCallbackPtr;

u8 *STRING_AppendN(u8 *dst, const u8 *src, u32 max_bytes) __attribute__((noinline));
s32 HANDLE_CloseAllAndReturnWithCode(s32 code) __attribute__((noinline));
s32 UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(s32 argc, u8 **argv) __attribute__((noinline));
s32 BUFFER_FlushAllAndCloseWithCode(s32 code) __attribute__((noinline));
s32 UNKNOWN36_ShowAbortRequester(void) __attribute__((noinline));

#define MODE_OLDFILE 1005
#define MODE_NEWFILE 1006

static s32 dos_lvo_open(const u8 *name, s32 mode)
{
    register const u8 *d1_in __asm__("d1") = name;
    register s32 d2_in __asm__("d2") = mode;
    register s32 result;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOOpen(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result), "+r"(d1_in), "+r"(d2_in)
        : "g"(Global_DosLibrary)
        : "a6", "d0", "cc", "memory");

    return result;
}

static s32 dos_lvo_input(void)
{
    register s32 result;

    __asm__ volatile(
        "movea.l %1,%%a6\n\t"
        "jsr _LVOInput(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result)
        : "g"(Global_DosLibrary)
        : "a6", "d0", "cc", "memory");

    return result;
}

static s32 dos_lvo_output(void)
{
    register s32 result;

    __asm__ volatile(
        "movea.l %1,%%a6\n\t"
        "jsr _LVOOutput(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result)
        : "g"(Global_DosLibrary)
        : "a6", "d0", "cc", "memory");

    return result;
}

static u8 *exec_find_task_null(void)
{
    register u8 *a1_in __asm__("a1") = (u8 *)0;
    register u8 *result;

    __asm__ volatile(
        "movea.l AbsExecBase,%%a6\n\t"
        "jsr _LVOFindTask(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result), "+r"(a1_in)
        :
        : "a6", "d0", "cc", "memory");

    return result;
}

s32 ESQ_ParseCommandLineAndRun(u8 *cmdline) __attribute__((noinline, used));

s32 ESQ_ParseCommandLineAndRun(u8 *cmdline)
{
    u8 *p = cmdline;

    while (Global_ArgCount < 32u) {
        while (*p == (u8)' ' || *p == (u8)'\t' || *p == (u8)'\n') {
            ++p;
        }

        if (*p == 0) {
            break;
        }

        {
            u32 slot = Global_ArgCount;
            Global_ArgCount = slot + 1u;

            if (*p == (u8)'"') {
                ++p;
                Global_ArgvStorage[slot] = p;

                while (*p != 0 && *p != (u8)'"') {
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
            while (*p != 0 && *p != (u8)' ' && *p != (u8)'\t' && *p != (u8)'\n') {
                ++p;
            }

            if (*p == 0) {
                break;
            }

            *p++ = 0;
        }
    }

    if (Global_ArgCount == 0) {
        Global_ArgvPtr = (u8 **)Global_SavedMsg;
    } else {
        Global_ArgvPtr = Global_ArgvStorage;
    }

    if (Global_ArgCount == 0) {
        static const u8 kConsolePrefix[] = "con.10/10/320/80/";
        u8 *saved_msg = Global_SavedMsg;
        u8 *arg_record = *(u8 **)(saved_msg + 36);
        u8 *append_src = *(u8 **)(arg_record + 4);
        s32 h;
        u8 *task;
        u8 *fh_ptr;
        u32 i = 0;

        do {
            Global_ConsoleNameBuffer[i] = kConsolePrefix[i];
        } while (kConsolePrefix[i++] != 0);

        STRING_AppendN(Global_ConsoleNameBuffer, append_src, 40u);
        h = dos_lvo_open(Global_ConsoleNameBuffer, MODE_NEWFILE);

        Global_HandleEntry0_Ptr = h;
        Global_HandleEntry1_Ptr = h;
        Global_HandleEntry1_Flags = 16u;
        Global_HandleEntry2_Ptr = h;
        Global_HandleEntry2_Flags = 16u;

        fh_ptr = (u8 *)(((u32)h) << 2);
        task = exec_find_task_null();
        *(u32 *)(task + 164) = *(u32 *)(fh_ptr + 8);
    } else {
        Global_HandleEntry0_Ptr = dos_lvo_input();
        Global_HandleEntry1_Ptr = dos_lvo_output();
        Global_HandleEntry2_Ptr = dos_lvo_open((const u8 *)"*", MODE_OLDFILE);
    }

    {
        u32 d7 = (Global_ArgCount == 0) ? 0u : 16u;
        u32 base_flags;

        Global_HandleEntry0_Flags |= (d7 | 0x8001u);
        Global_HandleEntry1_Flags |= (d7 | 0x8002u);
        Global_HandleEntry2_Flags |= 0x8003u;

        if (Global_DefaultHandleFlags == 0) {
            base_flags = 0x8000u;
        } else {
            base_flags = 0u;
        }

        Global_PreallocHandleNode0_HandleIndex = 0u;
        Global_PreallocHandleNode0_OpenFlags = (base_flags | 1u);
        Global_PreallocHandleNode1_HandleIndex = 1u;
        Global_PreallocHandleNode1_OpenFlags = (base_flags | 2u);
        Global_PreallocHandleNode2_HandleIndex = 2u;
        Global_PreallocHandleNode2_OpenFlags = (base_flags | 0x80u);
    }

    Global_SignalCallbackPtr = (u32)(u8 *)&UNKNOWN36_ShowAbortRequester;
    UNKNOWN29_JMPTBL_ESQ_MainInitAndRun((s32)Global_ArgCount, Global_ArgvPtr);
    return BUFFER_FlushAllAndCloseWithCode(0);
}
