/* RESTORES: ESQ_StartupEntry
 * MODULE:   modules/groups/_main/a/a.s   (1 of its 4 labels)
 * STATUS:   behavioural
 *
 * The program's entry point: the first byte of the CODE section, entered by the
 * OS with the command line in A0 and its length in D0. `register __a0` and
 * `register __d0` state that convention exactly, which is the whole of what
 * AGENTS.md means by "the startup entry is an __asm function".
 *
 * IT NO LONGER SAVES THE STACK POINTER, and that is the one deliberate
 * analogue in this pair. The original writes A7 into Global_SavedStackPointer
 * here so ESQ_ShutdownAndReturn can restore it from any depth; that function
 * now unwinds through dos.library Exit() instead, which needs no saved
 * pointer. The full reasoning, the two behavioural differences it costs, and
 * why setjmp/longjmp is not available, are all in
 * lib_esq_shutdown_and_return.c.
 *
 * Global_SavedStackPointer is written and read ONLY by this pair -- a grep over
 * the whole tree finds exactly two sites, both in this module -- so dropping
 * the write affects nothing else. The global keeps its bytes in the DATA image
 * and nothing reads it.
 *
 * A4 IS GONE, and that is not a loss. `LEA _Global_REF_LONG_FILE_SCRATCH,A4`
 * establishes SAS/C's near-data base, and a DATA=FAR build needs none. Every
 * `(A4)` global here is reached through esq-neardata.h, which resolves each
 * displacement to the same absolute address -- see AGENTS.md, "An (A4) symbol
 * is a NAMED ADDRESS IN OUR OWN DATA".
 *
 * TWO LVO NAMES IN THE DISASSEMBLY ARE FROM THE WRONG LIBRARY, and both are the
 * class AGENTS.md documents for EXEC_CallVector_48.
 *
 *   `_LVOSupervisor` is -30, and A6 holds DOSBase at that point, not exec. It
 *   is dos.library Open. The corroboration is the whole block: D1 comes from
 *   WBStartup+32, which is sm_ToolWindow, a name string; D2 is 1005, which is
 *   MODE_OLDFILE; the result is shifted left two and its +8 field -- fh_Type --
 *   is stored to Process+164, which is pr_ConsoleTask. That is the standard
 *   Workbench startup opening its tool window, instruction for instruction.
 *
 *   `_LVOexecPrivate1` is -36 and appears in ESQ_ShutdownAndReturn; see that
 *   file.
 *
 * THE CLI COMMAND LINE IS BUILT ON A VARIABLE-LENGTH STACK ALLOCATION, and this
 * is the one place the C cannot follow. The original computes
 * `len + nameLen + 4`, rounds it even, and does `SUBA.L D0,A7` -- an alloca.
 * SAS/C 6.51 has no such construct. The C uses a FIXED 1024-byte local instead
 * and clamps the copy to it. AmigaDOS caps a Shell command line at 512 bytes
 * and a BCPL name byte at 255, so 1024 cannot be reached in practice; but it is
 * a cap the original does not have and it is recorded here as a divergence
 * rather than buried.
 *
 * THE CLEAR LOOP RUNS 5929 TIMES, not 5930. `MOVE.L #5929,D0` then a DBF whose
 * check is entered first: the branch is taken for D0 from 5928 down to 0, which
 * is 5929 bodies. The buffer is named for that count.
 *
 * A LATENT BUG IN THE ORIGINAL IS NOT REPRODUCED, and it cannot be reached.
 * A6 is loaded with DOSBase only inside the `sm_ArgList != 0` arm, so a
 * Workbench start with a null ArgList would call Open on EXEC's base -- exec -30
 * is Supervisor. The C always calls dos Open. sm_ArgList is never null on a
 * real Workbench launch, so no reachable path differs.
 *
 * SASC-MISMATCH: stack-switch-as-dos-exit
 *   ref:     MOVE.L A7,Global_SavedStackPointer(A4) at entry
 *   got:     nothing; the shutdown unwinds through dos.library Exit()
 *   summary: itemised in full in lib_esq_shutdown_and_return.c, including the
 *            two behavioural differences it costs.
 *   scope:   this pair only.
 *   retest:  a toolchain whose setjmp/longjmp can be linked into ESQ.
 *
 * SASC-MISMATCH: alloca-as-fixed-buffer
 *   ref:     SUBA.L D0,A7 with D0 computed from the command line's length
 *   got:     a 1024-byte local
 *   summary: see above. The only observable difference is a cap AmigaDOS
 *            already enforces below.
 *   scope:   one site.
 *   retest:  a compiler with alloca.
 */
#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/tasks.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <workbench/startup.h>
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-neardata.h"

extern char ESQ_STR_DosLibrary[];
extern unsigned char BUFFER_5929_LONGWORDS[];

extern void ESQ_MainEntryNoOpHook(void);
extern void ESQ_ParseCommandLineAndRun(char *cmd);
extern void __asm ESQ_ShutdownAndReturn(register __d0 long code);

long __asm ESQ_StartupEntry(register __a0 char *cmd, register __d0 long len)
{
    char   line[1024];          /* the alloca the original does -- see header */
    struct ExecBase *sys;
    struct Process  *proc;
    struct WBStartup *msg;
    struct WBArg    *args;
    char  *name;
    long  *clear;
    long   nameLen;
    long   i;
    long   fh;

    clear = (long *)BUFFER_5929_LONGWORDS;
    for (i = 0; i < 5929; i++)
        *clear++ = 0;

    sys = SysBase;
    Global_SavedExecBase_A4 = (long)sys;
    Global_SavedMsg_A4 = 0;

    SetSignal(0L, 0x3000L);

    Global_DosLibrary_A4 = (long)OpenLibrary(ESQ_STR_DosLibrary, 0L);
    if (Global_DosLibrary_A4 == 0)
        ESQ_ShutdownAndReturn(100);

    proc = (struct Process *)sys->ThisTask;
    Global_SavedDirLock_A4 = *(long *)((char *)proc + 152);

    if (*(long *)((char *)proc + 172) != 0) {
        /* Started from a Shell: splice the program name in front of the
         * command line, the way SAS/C's startup does. */
        Global_CommandLineSize_A4 = 128;

        name = (char *)(*(long *)((char *)proc + 172) << 2);
        name = (char *)(*(long *)(name + 16) << 2);
        nameLen = (unsigned char)*name++;
        Global_ScratchPtr_592_A4 = (long)name;

        if (nameLen + len + 2 > (long)sizeof(line))
            len = (long)sizeof(line) - nameLen - 2;

        for (i = 0; i < nameLen; i++)
            line[i] = name[i];
        line[nameLen] = ' ';
        for (i = 0; i < len; i++)
            line[nameLen + 1 + i] = cmd[i];
        line[nameLen + 1 + len] = 0;

        ESQ_MainEntryNoOpHook();
        ESQ_ParseCommandLineAndRun(line);
        ESQ_ShutdownAndReturn(0);   /* never returns */
        return 0;
    }

    /* Started from Workbench: wait for the startup message. */
    Global_CommandLineSize_A4 = *(long *)((char *)proc + 58) + 128;

    WaitPort((struct MsgPort *)((char *)proc + 92));
    msg = (struct WBStartup *)GetMsg((struct MsgPort *)((char *)proc + 92));
    Global_SavedMsg_A4 = (long)msg;

    args = msg->sm_ArgList;
    if (args != 0) {
        Global_SavedDirLock_A4 = (long)args[0].wa_Lock;
        CurrentDir((BPTR)Global_SavedDirLock_A4);
    }

    if (msg->sm_ToolWindow != 0) {
        fh = (long)Open(msg->sm_ToolWindow, 1005L);
        Global_WBStartupWindowPtr_A4 = fh;
        if (fh != 0)
            *(long *)((char *)proc + 164) =
                *(long *)((char *)(fh << 2) + 8);
    }

    msg = (struct WBStartup *)Global_SavedMsg_A4;
    Global_ScratchPtr_592_A4 = (long)msg->sm_ArgList[0].wa_Name;

    ESQ_MainEntryNoOpHook();
    ESQ_ParseCommandLineAndRun((char *)&Global_WBStartupCmdBuffer_A4);
    ESQ_ShutdownAndReturn(0);   /* never returns */
    return 0;
}
