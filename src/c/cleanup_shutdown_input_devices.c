/* RESTORES: CLEANUP_ShutdownInputDevices
 * MODULE:   modules/groups/a/c/cleanup.s
 * STATUS:   behavioural
 *
 * Tears down the input and console devices: sends IND_REMHANDLER (10) to the
 * input device with the handler buffer as io_Data, frees that buffer, closes both
 * devices, releases both message ports, and frees both request blocks.
 *
 * The request really is a struct IOStdReq -- io_Command lands at +28 and io_Data
 * at +40 -- so it is written as one rather than as raw offsets, which is what
 * makes SAS/C fold them into (d16,An) displacements. See AGENTS.md.
 *
 * 134 bytes against 134, in three differing regions. The size agreement is
 * checked rather than assumed and every structural count matches:
 *
 *     MOVEA.L (abs).L,An   6 : 6      JSR _LVOxxx(A6)   3 : 3
 *     MOVE.L (abs).L,(A7)  4 : 4      calls             5 : 5
 *
 * The four MOVE.L (abs).L,(A7) are the original's stack-slot reuse -- it sets up
 * the four-argument frame for DeallocateMemory once and then overwrites the top
 * word for each of the following one-argument calls, popping once at the end with
 * LEA 16(A7),A7. SAS/C reproduces that exactly; it is not a hand-written flourish
 * (same finding as coi_clear_anim_object_strings.c).
 *
 * The two divergences below cancel to the byte, which is why the total lands on
 * 134 -- worth stating explicitly, since two errors summing to zero would look
 * identical on the headline number.
 *
 * SASC-MISMATCH: a6-callee-saved
 *   ref:     (nothing)                      A6 clobbered freely
 *   got:     2f0e ... 2c5f                  MOVE.L A6,-(A7) / MOVEA.L (A7)+,A6
 *   summary: SAS/C treats A6 as callee-saved across #pragma libcall. Costs 4.
 *   scope:   every library-calling function here; docs/compiler-version.md:81
 *
 * SASC-MISMATCH: execbase-reload
 *   ref:     2c780004 twice                 MOVEA.L AbsExecBase,A6 per call site
 *   got:     2c780004 once                  loaded once and kept live
 *   summary: having saved A6, SAS/C can keep ExecBase in it across the whole
 *            function; the original, not saving it, must re-read AbsExecBase
 *            before each library call. Saves 4, exactly offsetting the above.
 *            This is the reload-vs-cache class again -- see
 *            esqiff_deallocate_ads_and_logo_lst_data.c -- but here it is forced
 *            by the A6 convention rather than being a free choice.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba61de / 4eba61ce / 4eba61c4 / 4eba03e2 / 4eba03d8
 *   got:     61000000                       BSR.W, 5 sites
 *   summary: the standard call-encoding class. Both 4 bytes.
 */
#include <exec/io.h>
#include <devices/inputevent.h>
#include "esq-exec.h"

extern void MEMORY_DeallocateMemory(char *who, long line,
                                                    void *ptr, long size);
extern void IOSTDREQ_CleanupSignalAndMsgport(void *port);
extern void IOSTDREQ_Free(void *req);

extern struct IOStdReq *Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE;
extern struct IOStdReq *Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
extern void *Global_REF_DATA_INPUT_BUFFER;
extern void *Global_REF_INPUTDEVICE_MSGPORT;
extern void *Global_REF_CONSOLEDEVICE_MSGPORT;
extern char  Global_STR_CLEANUP_C_5[];

void CLEANUP_ShutdownInputDevices(void)
{
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Command = 10;
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Data = Global_REF_DATA_INPUT_BUFFER;
    DoIO((struct IORequest *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);

    MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_5, 127,
                                            Global_REF_DATA_INPUT_BUFFER,
                                            sizeof(struct InputEvent));

    CloseDevice((struct IORequest *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);
    CloseDevice((struct IORequest *)Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE);

    IOSTDREQ_CleanupSignalAndMsgport(Global_REF_INPUTDEVICE_MSGPORT);
    IOSTDREQ_CleanupSignalAndMsgport(Global_REF_CONSOLEDEVICE_MSGPORT);

    IOSTDREQ_Free(Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);
    IOSTDREQ_Free(Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE);
}
