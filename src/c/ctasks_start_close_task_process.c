/* RESTORES: CTASKS_StartCloseTaskProcess
 * MODULE:   modules/groups/a/f/ctasks.s
 * STATUS:   behavioural
 *
 * The sibling of ctasks_start_iff_task_process.c and the simpler of the two: no
 * Forbid/FindTask spin, no state seeding, just the same hand-built one-node
 * AmigaDOS segment list wrapped around a different cleanup function.
 *
 *     list        = AllocateMemory(..., 14, MEMF_PUBLIC|MEMF_CLEAR)
 *     list[0..3]  = 14                 seglist length field
 *     list[4..7]  = 0                  next-segment BPTR (left zero by MEMF_CLEAR)
 *     list[8..9]  = 0x4EF9             the JMP.L opcode
 *     list[10..13]= &CTASKS_CloseTaskTeardown
 *     BPTR        = (list + 4) >> 2    points at the next-segment field
 *
 * The file handle to be closed is stashed in a global before the process starts,
 * because CreateProc() has no way to pass an argument -- the new process reads it
 * back out of CTASKS_CloseTaskFileHandle. Same reason CTASKS_CloseTaskTeardown
 * needs __saveds. See ctasks_start_iff_task_process.c for the fuller write-up of
 * the seglist trick; the two files only make sense together.
 *
 * 138 bytes of code in the original (refbytes reports 140, the last two being the
 * inter-function DC.W 0) against 136 emitted, and the instruction sequence agrees
 * one-for-one throughout. Every divergence below is same-size except the last.
 *
 * SASC-MISMATCH: a6-callee-saved
 *   ref:     48e73900 ... 2e2f0014   MOVEM.L D2-D4/D7,-(A7) / MOVE.L 20(A7),D7
 *   got:     48e73902 ... 2e2f0018   MOVEM.L D2-D4/D7/A6,-(A7) / MOVE.L 24(A7),D7
 *   summary: SAS/C treats A6 as callee-saved across a #pragma libcall and adds it
 *            to the save mask; the original loads DOSBase into A6 and leaves it
 *            clobbered. Costs no bytes (the mask is a fixed word) but shifts the
 *            argument's stack offset by 4, which is the second region.
 *   scope:   every function here that calls a library. docs/compiler-version.md:81
 *   retest:  a compiler that does not preserve A6 for #pragma libcall.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba1dcc                JSR  GROUP_AG_..._AllocateMemory(PC)
 *   got:     61000000                BSR.W _GROUP_AG_..._AllocateMemory
 *   summary: the standard call-encoding class. Both 4 bytes.
 *
 * SASC-MISMATCH: deferred-stack-cleanup
 *   ref:     4fef0010 immediately after the JSR
 *   got:     4fef0010 in the epilogue, just before the MOVEM restore
 *   summary: SAS/C carries the 16-byte argument area to the end of the function
 *            and pops it once; the original pops at the call site. Same bytes,
 *            different position, so it shows up as two regions rather than one.
 *
 * SASC-MISMATCH: constant-materialisation-8192
 *   ref:     283c00002000            MOVE.L #8192,D4                 (6 bytes)
 *   got:     7840ef8c                MOVEQ #64,D4 / LSL.L #7,D4      (4 bytes)
 *   summary: the CreateProc stack size. This is the whole -2 delta, and it is a
 *            case where 6.51 is SMALLER than the original -- a counterexample to
 *            "the original optimises harder", alongside the two already recorded
 *            in docs/compiler-version.md.
 *   tried:   8192L, 0x2000L, (1L<<13), 8192U -- all four give MOVEQ+LSL, so the
 *            choice is in the code generator and not reachable from the literal.
 *   retest:  a compiler that materialises 8192 as a plain long immediate.
 */
#include <exec/memory.h>
#include "esq-exec.h"
#include "esq-dos.h"

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  CTASKS_CloseTaskTeardown(void);
extern short CTASKS_CloseTaskCompletionFlag;
extern long  CTASKS_CloseTaskFileHandle;
extern void *Global_REF_LIST_CLOSE_TASK_PROC;
extern long  CTASKS_CloseTaskSegListBPTR;
extern void *CTASKS_CloseTaskProcPtr;
extern char  Global_STR_CTASKS_C_4[];
extern char  Global_STR_CLOSE_TASK[];

/* The stub the new process starts executing. Writing the two code fields through
 * a struct rather than as (char *)base + n is what makes SAS/C fold the offset
 * into a (d16,An) displacement, matching the original's MOVE.L A0,10(A1) instead
 * of recomputing the address into a register for each store. */
struct SegStub {
    long  length;               /* +0  seglist length field                 */
    long  next;                 /* +4  next-segment BPTR, left 0 by MEMF_CLEAR */
    short jmp;                  /* +8  the JMP.L opcode, 0x4EF9             */
    void (*target)(void);       /* +10 where it jumps                       */
};

void CTASKS_StartCloseTaskProcess(long fileHandle)
{
    CTASKS_CloseTaskCompletionFlag = 0;
    CTASKS_CloseTaskFileHandle = fileHandle;

    Global_REF_LIST_CLOSE_TASK_PROC =
        GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_CTASKS_C_4, 203, 14,
                                              MEMF_PUBLIC | MEMF_CLEAR);

    *(long *)Global_REF_LIST_CLOSE_TASK_PROC = 14;
    ((struct SegStub *)Global_REF_LIST_CLOSE_TASK_PROC)->target = CTASKS_CloseTaskTeardown;
    ((struct SegStub *)Global_REF_LIST_CLOSE_TASK_PROC)->jmp = 0x4EF9;

    CTASKS_CloseTaskSegListBPTR =
        (long)((unsigned long)((char *)Global_REF_LIST_CLOSE_TASK_PROC + 4) >> 2);

    CTASKS_CloseTaskProcPtr = CreateProc(Global_STR_CLOSE_TASK, 0L,
                                         (BPTR)CTASKS_CloseTaskSegListBPTR, 8192L);
}
