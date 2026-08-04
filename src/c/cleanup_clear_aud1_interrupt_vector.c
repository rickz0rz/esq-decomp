/* RESTORES: CLEANUP_ClearAud1InterruptVector
 * MODULE:   modules/groups/a/c/cleanup2.s
 * STATUS:   behavioural
 *
 * 54 bytes against 60. casm.py itemises the whole +6: +2 for the exec base
 * form, +4 for a register SAS/C saves and the original does not.
 *
 * Reproduces: masking the AUD1 interrupt at INTENA, restoring the saved AUD1
 * interrupt vector, and freeing the 22-byte Interrupt struct that held it.
 *
 * INTENA is reached as an extern rather than a pointer cast, which is what makes
 * SAS/C emit the original's absolute MOVE.W #$100,($DFF09A).L -- see the
 * mkabsdefs note in AGENTS.md.
 *
 * SASC-MISMATCH: exec-base-form
 *   ref:     2c780004                   MOVEA.L (4).W,A6
 *   got:     2c7900000004               MOVEA.L (4).L,A6
 *   summary: esq-exec.h routes exec through a volatile SysBase so a base is
 *            never cached across a call. Here there is only one library call so
 *            the reload cannot matter, and the 2 bytes buy consistency with the
 *            rule rather than a per-file judgement about whether it is safe.
 */
#include "esq-exec.h"

#define INTB_AUD1 8

extern volatile unsigned short INTENA;
extern struct Interrupt *Global_REF_INTB_AUD1_INTERRUPT;
extern void *Global_REF_INTERRUPT_STRUCT_INTB_AUD1;
extern char  Global_STR_CLEANUP_C_2[];
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);

void CLEANUP_ClearAud1InterruptVector(void)
{
    INTENA = 0x100;
    SetIntVector((unsigned long)INTB_AUD1, Global_REF_INTB_AUD1_INTERRUPT);
    MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_2, 74,
                                            Global_REF_INTERRUPT_STRUCT_INTB_AUD1, 22);
}
