/* RESTORES: CTASKS_IFFTaskCleanup
 * MODULE:   modules/groups/a/f/ctasks.s
 * STATUS:   behavioural
 *
 * 210 bytes in the original, 200 emitted, 9 differing regions.
 *
 * FIRST use of __saveds in the project, and it is load-bearing. The original
 * opens with MOVE.L A4,-(A7) / LEA <data>,A4 and closes by restoring A4 -- the
 * signature of a function entered from a context that does not have the small-
 * data base set up, i.e. a separate Task. Declaring it
 *
 *     void __saveds CTASKS_IFFTaskCleanup(void)
 *
 * reproduces the LEA exactly. Without it the prologue is simply absent and the
 * function would be wrong if it were ever really called from the IFF task.
 * Anything else in ctasks.s showing this shape should get the same treatment.
 *
 * Also reproduces: the three-way state dispatch selecting which pending brush
 * descriptor to save (with state 11 sharing state 6's descriptor), the busy-wait
 * on BRUSH_LoadInProgressFlag that all three paths converge on, the second state
 * dispatch clearing the descriptor -- note state 11 is NOT handled there, so a
 * cleanup entered in state 11 saves the IFF descriptor but does not clear it --
 * the Forbid() before the flag updates, and the task-proc deallocation.
 *
 * SASC-MISMATCH: register-zero-reuse
 *   ref:     91c8 23c8xxxxxxxx           SUBA.L A0,A0 / MOVE.L A0,(abs).L
 *   got:     42b9xxxxxxxx                CLR.L (abs).L
 *   summary: The same class as the chained-assignment rule, but here it cannot be
 *            fixed from the source: the three zeroing stores are in mutually
 *            exclusive branches, so there is no way to write them as a chain.
 *            The original still holds zero in A0 across the branch structure.
 *   scope:   zero stores spread across exclusive branches.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     48e7000e                   MOVEM only
 */
#include "esq-exec.h"

extern void GCOMMAND_SaveBrushResult(void *desc);
extern void MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern short CTASKS_IffTaskState;
extern short CTASKS_IffTaskDoneFlag;
extern void *CTASKS_PendingLogoBrushDescriptor;
extern void *CTASKS_PendingGAdsBrushDescriptor;
extern void *CTASKS_PendingIffBrushDescriptor;
extern long  BRUSH_LoadInProgressFlag;
extern void *Global_REF_LIST_IFF_TASK_PROC;
extern char  Global_STR_CTASKS_C_1[];

void __saveds CTASKS_IFFTaskCleanup(void)
{
    void *desc;

    if (CTASKS_IffTaskState == 4)
        desc = CTASKS_PendingLogoBrushDescriptor;
    else if (CTASKS_IffTaskState == 5)
        desc = CTASKS_PendingGAdsBrushDescriptor;
    else if (CTASKS_IffTaskState == 6 || CTASKS_IffTaskState == 11)
        desc = CTASKS_PendingIffBrushDescriptor;

    while (BRUSH_LoadInProgressFlag)
        ;

    GCOMMAND_SaveBrushResult(desc);

    if (CTASKS_IffTaskState == 4)
        CTASKS_PendingLogoBrushDescriptor = 0;
    else if (CTASKS_IffTaskState == 5)
        CTASKS_PendingGAdsBrushDescriptor = 0;
    else if (CTASKS_IffTaskState == 6)
        CTASKS_PendingIffBrushDescriptor = 0;

    Forbid();
    CTASKS_IffTaskDoneFlag = 1;
    CTASKS_IffTaskState = 0;
    MEMORY_DeallocateMemory(Global_STR_CTASKS_C_1, 127,
                                            Global_REF_LIST_IFF_TASK_PROC, 14);
}
