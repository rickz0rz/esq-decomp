/* RESTORES: SETUP_INTERRUPT_INTB_RBF
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Allocates and installs the RS232 receive-buffer-full interrupt handler, along
 * with the 64K receive buffer it points at. Twenty-two bytes is
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
 * 146 bytes in the original, 152 emitted (150 plus one alignment NOP). This is one of three
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
#include <proto/exec.h>

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt();

extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_RBF;
extern char Global_STR_ESQFUNC_C_3[];
extern char Global_STR_RS232_RECEIVE_HANDLER[];
extern char *Global_REF_INTB_RBF_64K_BUFFER;
extern struct Interrupt *Global_REF_INTB_RBF_INTERRUPT;
extern char Global_STR_ESQFUNC_C_4[];

void SETUP_INTERRUPT_INTB_RBF(void)
{
    Global_REF_INTERRUPT_STRUCT_INTB_RBF = (struct Interrupt *)
        ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQFUNC_C_3, 1195L,
                                            (long)sizeof(struct Interrupt),
                                            MEMF_PUBLIC);

    Global_REF_INTB_RBF_64K_BUFFER = (char *)
        ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQFUNC_C_4, 1197L, 64000L,
                                            MEMF_PUBLIC | MEMF_CLEAR);

    Global_REF_INTERRUPT_STRUCT_INTB_RBF->is_Node.ln_Type = 2;
    Global_REF_INTERRUPT_STRUCT_INTB_RBF->is_Node.ln_Pri = 0;
    Global_REF_INTERRUPT_STRUCT_INTB_RBF->is_Node.ln_Name = Global_STR_RS232_RECEIVE_HANDLER;
    Global_REF_INTERRUPT_STRUCT_INTB_RBF->is_Data = Global_REF_INTB_RBF_64K_BUFFER;
    Global_REF_INTERRUPT_STRUCT_INTB_RBF->is_Code = ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt;

    Global_REF_INTB_RBF_INTERRUPT =
        SetIntVector(11L, Global_REF_INTERRUPT_STRUCT_INTB_RBF);
}
