#include "esq_types.h"

/*
 * Target 596 GCC trial function.
 * Emit abort message to CLI console if available, otherwise show Intuition requester.
 */
extern u32 AbsExecBase;
extern u32 Global_DosLibrary;
extern u8 *Global_UNKNOWN36_MessagePtr;
extern u8 *Global_UNKNOWN36_RequesterOutPtr;
extern u8 Global_UNKNOWN36_RequesterText0[];
extern u8 Global_UNKNOWN36_RequesterText1[];
extern u8 Global_UNKNOWN36_RequesterText2[];

s32 EXEC_CallVector_348(void *a0, void *a1, void *a2, void *a3, s32 d0, s32 d1, s32 d2, s32 d3, void *extra) __attribute__((noinline));

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

static s32 dos_write(s32 fh, const u8 *buf, s32 len)
{
    register s32 d1_in __asm__("d1") = fh;
    register const u8 *d2_in __asm__("d2") = buf;
    register s32 d3_in __asm__("d3") = len;
    register s32 result;

    __asm__ volatile(
        "movea.l %4,%%a6\n\t"
        "jsr _LVOWrite(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result), "+r"(d1_in), "+r"(d2_in), "+r"(d3_in)
        : "g"(Global_DosLibrary)
        : "a6", "d0", "cc", "memory");

    return result;
}

static void *exec_open_library(const u8 *name, u32 ver)
{
    register const u8 *a1_in __asm__("a1") = name;
    register u32 d0_in __asm__("d0") = ver;
    register void *result;

    __asm__ volatile(
        "movea.l AbsExecBase,%%a6\n\t"
        "jsr _LVOOpenLibrary(%%a6)\n\t"
        "move.l %%d0,%0\n\t"
        : "=r"(result), "+r"(a1_in), "+r"(d0_in)
        :
        : "a6", "cc", "memory");

    return result;
}

s32 UNKNOWN36_ShowAbortRequester(void) __attribute__((noinline, used));

s32 UNKNOWN36_ShowAbortRequester(void)
{
    static const u8 kBreakPrefix[] = "*** Break: ";
    static const u8 kIntuitionLib[] = "intuition.library";

    u8 local[82];
    u8 *msg = Global_UNKNOWN36_MessagePtr;
    s32 len = (u8)msg[-1];
    s32 i;
    u8 *task;
    s32 fh = 0;

    if (len > 79) {
        len = 79;
    }

    for (i = 0; i < len; ++i) {
        local[i] = msg[i];
    }
    local[len] = 0;

    task = exec_find_task_null();
    if (*(u32 *)(task + 172) != 0) {
        u8 *cli = (u8 *)((u32)(*(u32 *)(task + 172)) << 2);
        fh = *(s32 *)(cli + 56);
    }
    if (fh == 0) {
        fh = *(s32 *)(task + 160);
    }

    if (fh != 0) {
        dos_write(fh, kBreakPrefix, 11);
        local[len] = (u8)'\n';
        dos_write(fh, local, len + 1);
        return -1;
    }

    {
        void *intuition = exec_open_library(kIntuitionLib, 0u);
        s32 rc;

        if (intuition == 0) {
            return -1;
        }

        Global_UNKNOWN36_RequesterOutPtr = local;
        rc = EXEC_CallVector_348(
            0,
            Global_UNKNOWN36_RequesterText0,
            Global_UNKNOWN36_RequesterText1,
            Global_UNKNOWN36_RequesterText2,
            0,
            0,
            250,
            60,
            intuition
        );

        if (rc == 1) {
            return 0;
        }

        return -1;
    }
}
