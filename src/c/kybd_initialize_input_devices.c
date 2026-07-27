/* RESTORES: KYBD_InitializeInputDevices
 * MODULE:   modules/groups/a/v/kybd.s
 * STATUS:   behavioural
 *
 * 240 bytes in the original and 240 emitted, with only NINE differing regions --
 * the closest large restoration in the project so far outside the exact set.
 * Unlike ed_handle_edit_attributes_menu.c and esqiff2_show_attention_overlay.c,
 * where equal size was coincidence, here the size and the structure agree.
 *
 * Reproduces: the two CreateMsgPortWithSignal / AllocAndInitializeIOStdReq pairs
 * with their stack-slot reuse (MOVE.L D0,(A7) feeding the port straight into the
 * next call), both OpenDevice calls including the -1 unit on the console, the
 * io_Device copy out of the console request at +20, the four-argument
 * MEMORY_AllocateMemory, the Interrupt structure fill (is_Data at +14, is_Code at
 * +18, ln_Pri at +9 set to 0x33), the io_Command = 9 / io_Data / DoIO sequence
 * and the two ring-index resets sharing one zeroed register.
 *
 * The exec struct offsets all decode as standard: struct Interrupt puts is_Data
 * at 14 and is_Code at 18 because struct Node is 14 bytes, and struct IOStdReq
 * puts io_Device at 20, io_Command at 28 and io_Data at 40.
 *
 * NOTE: needs <exec/memory.h> for MEMF_PUBLIC. The MEMF_* values were hoisted
 * into src/exec-constants.s for the assembly side, but C should take them from
 * the SAS/C headers rather than from an extern.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     (no A6 save)
 *   got:     2f0e ... 2c5f
 *   summary: SAS/C brackets the body with a MOVE.L A6,-(A7) / MOVE.L (A7)+,A6
 *            pair; the original treats A6 as scratch across OpenDevice and DoIO.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the seven cross-unit calls. Every call here
 *            was cross-unit in the original, so this function is well placed to
 *            go exact on the right compiler -- the only other divergence is A6.
 */
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/interrupts.h>
#include <proto/exec.h>

extern void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void);
extern void *GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(char *name, long sig);
extern struct IOStdReq *GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void *port);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(void);

extern void *Global_REF_INPUTDEVICE_MSGPORT;
extern void *Global_REF_CONSOLEDEVICE_MSGPORT;
extern struct IOStdReq *Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE;
extern struct IOStdReq *Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
extern struct Interrupt *Global_REF_DATA_INPUT_BUFFER;
extern void *INPUTDEVICE_LibraryBaseFromConsoleIo;
extern long INPUTDEVICE_HandlerUserDataLong;
extern long ED_StateRingWriteIndex;
extern long ED_StateRingIndex;
extern char Global_STR_INPUTDEVICE[];
extern char Global_STR_CONSOLEDEVICE[];
extern char Global_STR_INPUT_DEVICE[];
extern char Global_STR_CONSOLE_DEVICE[];
extern char Global_STR_KYBD_C[];

void KYBD_InitializeInputDevices(void)
{
    GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths();

    Global_REF_INPUTDEVICE_MSGPORT =
        GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_INPUTDEVICE, 0);
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE =
        GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_INPUTDEVICE_MSGPORT);

    Global_REF_CONSOLEDEVICE_MSGPORT =
        GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_CONSOLEDEVICE, 0);
    Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE =
        GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_CONSOLEDEVICE_MSGPORT);

    OpenDevice(Global_STR_INPUT_DEVICE, 0L,
               (struct IORequest *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, 0L);
    OpenDevice(Global_STR_CONSOLE_DEVICE, -1L,
               (struct IORequest *)Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE, 0L);

    INPUTDEVICE_LibraryBaseFromConsoleIo =
        Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE->io_Device;

    Global_REF_DATA_INPUT_BUFFER =
        NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_KYBD_C, 121, 22, MEMF_PUBLIC);
    Global_REF_DATA_INPUT_BUFFER->is_Data = &INPUTDEVICE_HandlerUserDataLong;
    Global_REF_DATA_INPUT_BUFFER->is_Code = GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit;
    Global_REF_DATA_INPUT_BUFFER->is_Node.ln_Pri = 0x33;

    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Command = 9;
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Data = Global_REF_DATA_INPUT_BUFFER;
    DoIO((struct IORequest *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);

    ED_StateRingWriteIndex = 0;
    ED_StateRingIndex = 0;
}
