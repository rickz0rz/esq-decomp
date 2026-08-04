/* RESTORES: SETUP_INTERRUPT_INTB_VERTB
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Allocates and installs the vertical-blank interrupt server. Twenty-two bytes is
 * sizeof(struct Interrupt), and the field offsets 8/9/10/14/18 are ln_Type,
 * ln_Pri, ln_Name, is_Data and is_Code -- so this is a plain struct Interrupt
 * filled in field by field, not an ad-hoc block.
 *
 * Nothing checks the allocation. A null return is dereferenced immediately at
 * ln_Type; that is the original's behaviour and is left alone.
 *
 * Every field store re-reads the global pointer rather than keeping it in a
 * register, which is why this is written through the global at each line instead
 * of through a local. Written through a local it would load the pointer once,
 * which is 24 bytes shorter and wrong. Note this is a source-shape requirement,
 * NOT a reload-vs-cache divergence: given the global at each store, 6.51 reloads
 * it exactly as the original does.
 *
 * 104 bytes in the original, 108 emitted. This is one of three
 * near-identical siblings -- VERTB, AUD1 and RBF -- restored together; all three
 * land within six bytes and all three have the SAME two divergences and nothing else. Every
 * field store, the PC-relative LEA of the handler, the sizeof, the memory flags
 * and the library call reproduce byte for byte.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   ref:     (nothing)          A6 loaded from AbsExecBase and left clobbered
 *   got:     2f0e ... 2c5f      MOVE.L A6,-(A7) / MOVEA.L (A7)+,A6
 *   summary: The original treats A6 as scratch across a library call; 6.51
 *            preserves it. +4. Second sighting after ed_draw_help_panels.c, where
 *            it cost nothing because a MOVEM was already there -- here there is no
 *            MOVEM, so it shows up as two whole instructions.
 *   scope:   every function that calls a library and saves no other register.
 *
 * SASC-MISMATCH: alloc-result-store-order
 *   ref:     JSR / LEA 16(A7),A7 / MOVE.L D0,(abs).L
 *   got:     BSR / MOVE.L D0,(abs).L / LEA 16(A7),A7
 *   summary: The original pops the argument frame before storing the result, 6.51
 *            stores first. Same instructions, same bytes, different order -- casm
 *            reports it as a +6 / -6 pair. Exactly the ninth region recorded in
 *            esqiff_handle_brush_ini_reload_hotkey.c, so this is that same
 *            ordering habit, now seen in four functions.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the allocator call.
 */
#include <exec/interrupts.h>
#include <exec/memory.h>
#include "esq-exec.h"

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void ESQ_TickGlobalCounters();

extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern char Global_STR_ESQFUNC_C_1[];
extern char Global_STR_VERTICAL_BLANK_INT[];
extern char ESQ_VerticalBlankInterruptUserData[];

void SETUP_INTERRUPT_INTB_VERTB(void)
{
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB = (struct Interrupt *)
        MEMORY_AllocateMemory(Global_STR_ESQFUNC_C_1, 1159L,
                                            (long)sizeof(struct Interrupt),
                                            MEMF_PUBLIC);

    Global_REF_INTERRUPT_STRUCT_INTB_VERTB->is_Node.ln_Type = 2;
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB->is_Node.ln_Pri = 0;
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB->is_Node.ln_Name = Global_STR_VERTICAL_BLANK_INT;
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB->is_Data = ESQ_VerticalBlankInterruptUserData;
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB->is_Code = ESQ_TickGlobalCounters;

    AddIntServer(5L, Global_REF_INTERRUPT_STRUCT_INTB_VERTB);
}
