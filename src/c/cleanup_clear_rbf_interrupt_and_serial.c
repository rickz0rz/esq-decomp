/* RESTORES: CLEANUP_ClearRbfInterruptAndSerial
 * MODULE:   modules/groups/a/b/cleanup.s
 * STATUS:   behavioural
 *
 * Tears down everything SETUP_INTERRUPT_INTB_RBF put up, in the reverse order:
 * masks the RBF interrupt at INTENA first so nothing fires mid-teardown, closes
 * the serial device, releases the message port and the IO request, restores the
 * previous INTB_RBF vector, and frees the 64K receive buffer and the Interrupt
 * struct.
 *
 * Writing INTENA before CloseDevice is the load-bearing ordering here -- the
 * handler is freed a few lines later, so it must be unable to fire.
 *
 * INTENA is reached as an extern, not a pointer cast; see src/modules/c-exports.s
 * for why. Note it is NOT in the absolute-symbol object yet, so this file cannot
 * be linked as a replacement until it is added there and to build-split.sh.
 *
 * 114 bytes in the original, 114 emitted, and the two divergences cancel exactly:
 * +4 for preserving A6, -4 for not reloading SysBase. Everything else -- both
 * stack-slot reuses, the 64000 and 22 constants, sizeof(struct Interrupt), the
 * INTENA store, all five calls -- reproduces.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   ref:     (nothing)          A6 clobbered across the library calls
 *   got:     2f0e ... 2c5f      saved and restored
 *   summary: Third sighting today, after ed_draw_help_panels.c and the three
 *            SETUP_INTERRUPT_* siblings. +4.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c780004           MOVEA.L AbsExecBase,A6 again before SetIntVector
 *   got:     (nothing)          A6 still holds SysBase from the CloseDevice call
 *   summary: The original reloads the library base for the second exec call even
 *            though nothing has touched A6; 6.51 keeps it. -4. Same class and same
 *            direction as the GfxBase reloads in esqfunc_draw_esc_menu_version.c,
 *            which is now three separate functions showing the original reloading
 *            a library base it did not need to.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */

extern volatile unsigned short INTENA;

extern void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
extern void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *p);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                    long size);

extern struct IORequest *WDISP_SerialIoRequestPtr;
extern void *WDISP_SerialMessagePortPtr;
extern struct Interrupt *Global_REF_INTB_RBF_INTERRUPT;
extern char *Global_REF_INTB_RBF_64K_BUFFER;
extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_RBF;
extern char Global_STR_CLEANUP_C_3[];
extern char Global_STR_CLEANUP_C_4[];

#include <exec/interrupts.h>
#include <exec/io.h>
#include <proto/exec.h>

void CLEANUP_ClearRbfInterruptAndSerial(void)
{
    INTENA = 0x800;

    CloseDevice(WDISP_SerialIoRequestPtr);
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(WDISP_SerialMessagePortPtr);
    GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(WDISP_SerialIoRequestPtr);

    SetIntVector(11L, Global_REF_INTB_RBF_INTERRUPT);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_3, 113L,
                                            Global_REF_INTB_RBF_64K_BUFFER, 64000L);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_4, 118L,
                                            Global_REF_INTERRUPT_STRUCT_INTB_RBF,
                                            (long)sizeof(struct Interrupt));
}
