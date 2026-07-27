/* RESTORES: CTASKS_CloseTaskTeardown
 * MODULE:   modules/groups/a/f/ctasks.s
 * STATUS:   behavioural
 *
 * Winds up the CLOSE_TASK process: closes its file handle if one is still open,
 * forbids, frees the process descriptor and raises the completion flag the parent
 * waits on. The Forbid() is deliberately outside the handle test -- it guards the
 * deallocate and the flag, which is what the parent races against, not the close.
 *
 * The fifth __saveds function found, and the third in ctasks.s. Same signature as
 * the rest: MOVE.L A4,-(A7) followed by a LEA of the near-data base. See
 * ctasks_ifftaskcleanup.c for the full write-up of why it is load-bearing.
 *
 * 88 bytes in the original, 88 emitted -- 86 of code plus one alignment NOP, so
 * -2 real, itemised as +4, -4, -2.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   ref:     2f0c ... 285f      A4 only
 *   got:     48e7000a ... 4cdf5000   A4 and A6
 *   summary: Fourth sighting today. +4.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     4ab9 (abs) then 2239 (abs)   tested, then re-read for the argument
 *   got:     2039 (abs) then 2200         read once into D0, copied to D1
 *   summary: The file handle. -4.
 *
 * SASC-MISMATCH: zero-store-via-register
 *   ref:     7000 23c0000004a8   MOVEQ #0,D0 / MOVE.L D0,(abs).L
 *   got:     42b900000000       CLR.L (abs).L
 *   summary: -2. This sighting is the one that DISPROVED the narrowing proposed in
 *            ed1_clear_esc_menu_mode.c -- the operand here is a plain absolute
 *            with no displacement and the zero is not reused afterwards, and the
 *            original still declines CLR. That file now lists all five sightings
 *            and asserts no rule. Worth resolving eventually, since it is two
 *            bytes at every zero store in the program.
 */
#include "esq-dos.h"
#include "esq-exec.h"

extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                    long size);

extern long CTASKS_CloseTaskFileHandle;
extern void *Global_REF_LIST_CLOSE_TASK_PROC;
extern short CTASKS_CloseTaskCompletionFlag;
extern char Global_STR_CTASKS_C_3[];

void __saveds CTASKS_CloseTaskTeardown(void)
{
    if (CTASKS_CloseTaskFileHandle) {
        Close(CTASKS_CloseTaskFileHandle);
        CTASKS_CloseTaskFileHandle = 0;
    }

    Forbid();
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CTASKS_C_3, 194L,
                                            Global_REF_LIST_CLOSE_TASK_PROC, 14L);
    CTASKS_CloseTaskCompletionFlag = 1;
}
