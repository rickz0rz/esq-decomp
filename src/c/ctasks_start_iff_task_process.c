/* RESTORES: CTASKS_StartIffTaskProcess
 * MODULE:   modules/groups/a/f/ctasks.s
 * STATUS:   behavioural
 *
 * 202 bytes in the original, 192 emitted, seven differing regions.
 *
 * This file used to claim 202/202 with four regions and "unlike the six size
 * coincidences elsewhere in this directory, here the size and the structure
 * genuinely agree." That was wrong, and the way it was caught is worth keeping.
 *
 * The seglist stores were originally written as *(void **)((char *)base + 10),
 * which makes SAS/C materialise the address into a register for each store -- ten
 * bytes the original never had, since it writes through (d16,An) displacements.
 * Rewriting them as struct members (see ctasks_start_close_task_process.c, where
 * the same change is the whole story) makes SAS/C emit the original's
 * 2348000a / 337c4ef90008 verbatim. The emitted code got strictly closer to the
 * reference and the size match FELL APART, because those ten spurious bytes had
 * been silently paying for the missing A5 frame and the 8192 constant below.
 *
 * So: a size-exact restoration can be less faithful than a size-divergent one,
 * and the region count is only comparable between two candidates of the SAME
 * size -- once the lengths differ, every region after the first divergence is
 * misaligned and the count inflates on its own. Compare against the reference's
 * instruction sequence, not against the totals.
 *
 * The interesting part is what this function does, which is worth documenting
 * because it is not obvious from the assembly and is easy to reconstruct wrongly.
 * It hand-builds a one-node AmigaDOS segment list so that CreateProc() can launch
 * a plain C function as a process:
 *
 *     list        = AllocateMemory(..., 14, MEMF_PUBLIC|MEMF_CLEAR)
 *     list[0..3]  = 14                 seglist length field
 *     list[4..7]  = 0                  next-segment BPTR (left zero by MEMF_CLEAR)
 *     list[8..9]  = 0x4EF9             the JMP.L opcode
 *     list[10..13]= &CTASKS_IFFTaskCleanup
 *     BPTR        = (list + 4) >> 2    points at the next-segment field
 *
 * So the "code" the new process starts executing is a two-instruction stub that
 * immediately jumps to the cleanup function. That is why CTASKS_IFFTaskCleanup
 * needs __saveds (see ctasks_ifftaskcleanup.c) -- it really is entered as a fresh
 * process with no small-data base set up. The two files only make sense together.
 *
 * Also reproduces: the Forbid/FindTask/Permit spin that waits for any previous
 * IFF task to disappear, and the state seeding that leaves an externally-set
 * state of 6 alone while otherwise choosing 4 or 5 from ESQIFF_AssetSourceSelect.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class; the FindTask result stays in a register.
 *
 * SASC-MISMATCH: register-zero-reuse
 *   summary: MOVEQ #0,D0 then MOVE.W D0,flag against CLR.W flag, as in
 *            ctasks_ifftaskcleanup.c. Not fixable from source here either.
 *
 * SASC-MISMATCH: constant-materialisation-8192
 *   ref:     283c00002000               MOVE.L #8192,D4              (6 bytes)
 *   got:     7840ef8c                   MOVEQ #64,D4 / LSL.L #7,D4   (4 bytes)
 *   summary: the CreateProc stack size; 6.51 is smaller than the original here.
 *   tried:   8192L, 0x2000L, (1L<<13), 8192U -- all four give MOVEQ+LSL.
 *   scope:   both CTASKS_Start*Process functions, same constant, same encoding.
 *   retest:  a compiler that materialises 8192 as a plain long immediate.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba1eae                   JSR  ..._AllocateMemory(PC)
 *   got:     61000000                   BSR.W _..._AllocateMemory
 *   summary: the standard call-encoding class. Both 4 bytes.
 */
#include <exec/memory.h>
#include "esq-exec.h"
#include "esq-dos.h"

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  CTASKS_IFFTaskCleanup(void);
extern short CTASKS_IffTaskDoneFlag;
extern short CTASKS_IffTaskState;
extern short ESQIFF_AssetSourceSelect;
extern void *Global_REF_LIST_IFF_TASK_PROC;
extern long  CTASKS_IffTaskSegListBPTR;
extern void *CTASKS_IffTaskProcPtr;
extern char  Global_STR_IFF_TASK_1[];
extern char  Global_STR_IFF_TASK_2[];
extern char  Global_STR_CTASKS_C_2[];

struct SegStub {
    long  length;
    long  next;
    short jmp;
    void (*target)(void);
};

void CTASKS_StartIffTaskProcess(void)
{
    void *found;

    do {
        Forbid();
        found = FindTask(Global_STR_IFF_TASK_1);
        Permit();
    } while (found);

    CTASKS_IffTaskDoneFlag = 0;

    if (CTASKS_IffTaskState != 6) {
        if (ESQIFF_AssetSourceSelect)
            CTASKS_IffTaskState = 4;
        else
            CTASKS_IffTaskState = 5;
    }

    Global_REF_LIST_IFF_TASK_PROC =
        GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_CTASKS_C_2, 159, 14,
                                              MEMF_PUBLIC | MEMF_CLEAR);

    *(long *)Global_REF_LIST_IFF_TASK_PROC = 14;
    ((struct SegStub *)Global_REF_LIST_IFF_TASK_PROC)->target = CTASKS_IFFTaskCleanup;
    ((struct SegStub *)Global_REF_LIST_IFF_TASK_PROC)->jmp = 0x4EF9;

    CTASKS_IffTaskSegListBPTR =
        (long)((unsigned long)((char *)Global_REF_LIST_IFF_TASK_PROC + 4) >> 2);

    CTASKS_IffTaskProcPtr = CreateProc(Global_STR_IFF_TASK_2, 0L,
                                       (BPTR)CTASKS_IffTaskSegListBPTR, 8192L);
}
