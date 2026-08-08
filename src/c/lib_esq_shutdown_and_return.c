/* RESTORES: ESQ_ShutdownAndReturn,
 *           ESQ_ReturnWithStackCode
 * MODULE:   modules/groups/_main/a/a.s   (2 of its 4 labels)
 * STATUS:   behavioural
 *
 * DO-NOT-LINK: BISECTED RUNTIME FAULT (2026-08-07). See
 *   lib_esq_startup_entry.c. The two are merged into a_merged.c and the bisect
 *   names that unit, not one function. This file holds the program's one live
 *   ANALOGUE -- dos.library Exit() in place of the original's stack switch --
 *   which makes it the more likely of the two, but that is not established.
 *
 * The program's exit path. It runs the teardown, then restores the stack
 * pointer the entry saved and returns to the OS -- from whatever depth it was
 * called at.
 *
 * THE UNWIND IS AN ANALOGUE, NOT A TRANSCRIPTION, AND IT IS THE ONE PLACE IN
 * THE PROGRAM WHERE THAT IS TRUE OF SOMETHING LIVE. The original ends
 * `MOVEA.L Global_SavedStackPointer(A4),A7 / MOVEM.L (A7)+,D1-D6/A0-A6 / RTS`:
 * a stack switch and a return on the restored stack, so the program can leave
 * from any depth. No C statement expresses that.
 *
 * setjmp/longjmp IS THE OBVIOUS ANSWER AND IT IS NOT AVAILABLE. AGENTS.md
 * proposes it, and the reasoning is right -- longjmp is exactly this operation.
 * But it lives in sc.lib, which this project cannot link: AGENTS.md records
 * that sc.lib collides on nine symbols ESQ defines itself. Nor can the one
 * member be lifted out. `tools/sclib.py sc.lib --symbol ___setjmp` reports
 * setjmp.o at 176 bytes with unresolved references to `___base` and `___top`,
 * the stack-check bounds a NOSTKCHK build never defines. So the pair is out on
 * two independent counts, and this was measured rather than assumed.
 *
 * WHAT IS USED INSTEAD IS dos.library Exit(), which is the OS's own primitive
 * for the same thing: end this program and hand the code back to the CLI that
 * started it. It is what the original's saved-A7 restore accomplishes, reached
 * through the system rather than by hand.
 *
 * TWO DIFFERENCES ARE REAL AND ARE NOT PAPERED OVER.
 *
 *   The thirteen registers the entry saved are not restored. Exit() returns
 *   through the CLI's own saved context, so D1-D6 and A0-A6 hold whatever the
 *   program left in them. AmigaDOS does not require a program to preserve them
 *   and Exit() is a documented DOS call, but the original was stricter.
 *
 *   Exit() is CLI-only. A Workbench launch reaches this function through the
 *   same path and Exit() is not supported there. ESQ is launched from a Shell
 *   -- the drive's S/uv-startup runs `esq GA24005` -- so the supported case is
 *   the one that happens, but the unsupported one is now reachable where it was
 *   not before.
 *
 * THE DOS BASE IS ALREADY CLOSED WHEN Exit() IS CALLED, and that is the
 * original's own state rather than something introduced here. CloseLibrary
 * runs above and does not clear Global_REF_DOS_LIBRARY_2, so esq-dos.h's base
 * still reads the same pointer the original leaves there. The library stays
 * resident because the Shell that launched ESQ holds its own open on it.
 *
 * The teardown below runs BEFORE the unwind, which is where the original runs
 * it too.
 *
 * ESQ_ReturnWithStackCode IS THE SAME ROUTINE WITH THE CODE ON THE STACK. The
 * original reads 4(A7) and falls straight into ESQ_ShutdownAndReturn, which
 * expects it in D0. That is the only difference between the two, and it is the
 * live entry: HANDLE_CloseAllAndReturnWithCode reaches it through a jump table
 * in unknown32.s. Neither ever returns.
 *
 * `_LVOexecPrivate1` IS THE WRONG NAME AND POSSIBLY THE WRONG LIBRARY. It is
 * offset -36 and A6 holds AbsExecBase when it is called, so it really is an
 * exec vector -- but D1 holds a dos FILEHANDLE, the one Open returned for the
 * tool window in the startup, and -36 on DOS is Close. Either the original
 * closes its tool window through a stale base, or the disassembly's A6 tracking
 * is wrong. The restoration does not choose: it calls the vector at -36 on
 * SysBase with D1, through a pragma of its own, which is exactly the
 * instruction the original emits.
 *
 * THE PATH IS UNREACHABLE FOR THIS PROGRAM ANYWAY. It runs only when
 * Global_SavedMsg is non-zero, which happens only on a Workbench launch, and
 * the drive's S/uv-startup runs `esq GA24005` from a Shell. So the question
 * above cannot be settled by running it, and is recorded rather than resolved.
 *
 * THE EXIT-HOOK LABEL IN THE DISASSEMBLY IS MISLEADING. `.call_exit_hook` is
 * the branch target for a NULL hook -- the call happens above it, when the
 * pointer is non-zero.
 *
 * SASC-MISMATCH: stack-switch-as-dos-exit
 *   ref:     202f 2c6f<slot> 4cdf 7ffe 4e75   the code popped, A7 restored
 *            from the global, thirteen registers restored, RTS
 *   got:     a call to dos.library Exit()
 *   summary: NOT AN EQUIVALENT ENCODING -- a different mechanism with the same
 *            effect for a CLI-launched program. The two differences are listed
 *            in full above. This is the only live function in the program
 *            restored as an analogue rather than a transcription.
 *   tried:   setjmp/longjmp, which is what AGENTS.md proposes. sc.lib cannot
 *            be linked and its setjmp.o needs ___base and ___top. Measured,
 *            not assumed.
 *   scope:   this pair only. Global_SavedStackPointer is written and read
 *            nowhere else in the program, so nothing else depends on the
 *            representation.
 *   retest:  a toolchain whose setjmp/longjmp can be linked into ESQ restores
 *            the exact mechanism, at which point both differences go away.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   summary: the original loads AbsExecBase once and issues CloseLibrary,
 *            the -36 vector, Forbid and ReplyMsg on it. esq-exec.h's volatile
 *            base reloads before each, 6 bytes a site. That is deliberate and
 *            load-bearing -- see esq-libbase.md.
 *   scope:   program-wide.
 *   retest:  nothing to retest; the reload is the correct behaviour.
 */
#include <exec/types.h>
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-neardata.h"

/* The vector at -36 on SysBase, taking one argument in D1. There is no stock
 * name for it; see the header. 24 hex is 36 decimal, and `101` is one argument
 * in D1 -- the same spelling as `#pragma libcall SysBase FreeTrap 15c 001`. */
void ESQ_ExecVector36(long d1);
#pragma libcall SysBase ESQ_ExecVector36 24 101

extern void MEMLIST_FreeAll(void);
extern void ESQ_MainExitNoOpHook(void);

void __asm ESQ_ShutdownAndReturn(register __d0 long code)
{
    void (*hook)(void);

    hook = (void (*)(void))Global_ExitHookPtr_A4;
    if (hook != 0)
        (*hook)();

    MEMLIST_FreeAll();
    CloseLibrary((struct Library *)Global_DosLibrary_A4);
    ESQ_MainExitNoOpHook();

    if (Global_SavedMsg_A4 != 0) {
        if (Global_WBStartupWindowPtr_A4 != 0)
            ESQ_ExecVector36(Global_WBStartupWindowPtr_A4);
        Forbid();
        ReplyMsg((struct Message *)Global_SavedMsg_A4);
    }

    /* The unwind. Never returns -- see the header. */
    Exit(code);
}

void ESQ_ReturnWithStackCode(long code)
{
    ESQ_ShutdownAndReturn(code);
}
