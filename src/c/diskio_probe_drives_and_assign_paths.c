/* RESTORES: DISKIO_ProbeDrivesAndAssignPaths
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * Probes all four trackdisk units for write-protect and disk-change state, then
 * re-runs the DH2 assigns if drive 0 came back clean and the graphics assign if
 * drive 1 did. The fault codes it records (218, 223, 226) are what
 * ESQFUNC_UpdateDiskWarningAndRefreshTick later turns into on-screen warnings.
 *
 * ESQPARS2_ReadModeFlags is saved, forced to 0x100 across the eight DH2 assigns
 * and restored afterwards -- the assigns run Execute(), which can re-enter code
 * that reads it, so it is pinned for the duration.
 *
 * Both assign blocks clear their own "pending" flag at the end by storing the
 * register that already holds zero, which is why the flag stores read as
 * MOVE.L D2 rather than CLR.
 *
 * 642 bytes in the original, 632 emitted (630 plus one alignment NOP), itemised
 * in full by tools/casm.py. Everything structural reproduces: the four-unit probe
 * loop, both TD_ commands, the io_Error / io_Actual pair of tests after each, all
 * eight DH2 assigns in order, the flag save-and-restore, and both assign blocks.
 *
 * SASC-MISMATCH: argument-rematerialised-per-call
 *   ref:     2602 (x10)        MOVE.L D2,D3 before every Execute
 *   got:     2602 (x3)         D3 left holding zero across the run of calls
 *   summary: Execute takes its output handle in D3. The original re-copies the
 *            zero from D2 before each of the eight assigns even though nothing
 *            touches D3 in between; 6.51 emits it three times. -14 over the eight
 *            sites. This is the reload-vs-cache class applied to a register
 *            argument rather than to memory, and it is the same instinct as the
 *            library-base reloads recorded in
 *            cleanup_clear_rbf_interrupt_and_serial.c -- the original does not
 *            trust a register to survive a call.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c780004 / 2c790000d930 reloaded before each library call
 *   got:     hoisted, one load per run
 *   summary: SysBase and DOSBase, same class as above. casm shows these as +6/-6
 *            pairs -- the load moves rather than disappearing, so they are close
 *            to free.
 *
 * SASC-MISMATCH: constant-store-form
 *   ref:     7071 d080 2480       MOVEQ #113,D0 / ADD.L D0,D0 / MOVE.L D0,(A2)
 *            22bc000000e2         MOVE.L #226,(A1)
 *   summary: Not a mismatch against us -- both forms are in the ORIGINAL, for the
 *            same value 226, and again for 223 (MOVEQ #32 + NOT.B versus
 *            MOVE.L #$df). It confirms what esqdisp_allocate_highlight_bitmaps.c
 *            inferred: the four-byte short forms in the constant rule apply when
 *            the value is being materialised INTO A REGISTER. Storing straight to
 *            memory uses MOVE.L #imm, which costs the same six bytes either way.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
#include <exec/io.h>
#include <proto/exec.h>
#include <proto/dos.h>

extern void *GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(long a, long b);
extern void *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *port, long size);
extern void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *p);
extern void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
extern short GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(char *path);

extern void *DISKIO_TrackdiskMsgPortPtr;
extern struct IOStdReq *DISKIO_TrackdiskIoReqPtr;
extern long DISKIO_Drive0WriteProtectedCode;
extern long DISKIO_DriveWriteProtectStatusCodeDrive1;
extern long DISKIO_DriveMediaStatusCodeTable;
extern short ESQ_MainLoopUiTickEnabledFlag;
extern short GCOMMAND_DriveProbeRequestedFlag;
extern long DISKIO_Drive0Dh2AssignDoneFlag;
extern long DISKIO_Drive1GfxAssignDoneFlag;
extern short ESQPARS2_ReadModeFlags;

extern char DISKIO_STR_TRACKDISK_DEVICE[];
extern char DISKIO_CMD_ASSIGN_FONTS_DH2[];
extern char DISKIO_CMD_ASSIGN_ENV_DH2[];
extern char DISKIO_CMD_ASSIGN_SYS_DH2[];
extern char DISKIO_CMD_ASSIGN_S_DH2[];
extern char DISKIO_CMD_ASSIGN_C_DH2[];
extern char DISKIO_CMD_ASSIGN_L_DH2[];
extern char DISKIO_CMD_ASSIGN_LIBS_DH2[];
extern char DISKIO_CMD_ASSIGN_DEVS_DH2[];
extern char DISKIO_PATH_DF1_G_ADS[];
extern char DISKIO_CMD_ASSIGN_GFX_DF1[];
extern char DISKIO_CMD_ASSIGN_GFX_PC1[];

void DISKIO_ProbeDrivesAndAssignPaths(void)
{
    long unit;
    long err;
    short savedFlags;

    DISKIO_TrackdiskMsgPortPtr = GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(0L, 0L);
    DISKIO_TrackdiskIoReqPtr = (struct IOStdReq *)
        GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(DISKIO_TrackdiskMsgPortPtr, 56L);

    for (unit = 0; unit < 4; unit++) {
        (&DISKIO_Drive0WriteProtectedCode)[unit] = 0;
        (&DISKIO_DriveMediaStatusCodeTable)[unit] = 0;

        err = OpenDevice(DISKIO_STR_TRACKDISK_DEVICE, unit,
                         (struct IORequest *)DISKIO_TrackdiskIoReqPtr, 0L);
        if (err) {
            (&DISKIO_Drive0WriteProtectedCode)[unit] = 218;
            (&DISKIO_DriveMediaStatusCodeTable)[unit] = 223;
        } else {
            DISKIO_TrackdiskIoReqPtr->io_Command = 14;
            DoIO((struct IORequest *)DISKIO_TrackdiskIoReqPtr);
            if (DISKIO_TrackdiskIoReqPtr->io_Error)
                (&DISKIO_Drive0WriteProtectedCode)[unit] = 226;
            else if (DISKIO_TrackdiskIoReqPtr->io_Actual)
                (&DISKIO_Drive0WriteProtectedCode)[unit] = 226;

            DISKIO_TrackdiskIoReqPtr->io_Command = 15;
            DoIO((struct IORequest *)DISKIO_TrackdiskIoReqPtr);
            if (DISKIO_TrackdiskIoReqPtr->io_Error)
                (&DISKIO_DriveMediaStatusCodeTable)[unit] = 223;
            else if (DISKIO_TrackdiskIoReqPtr->io_Actual)
                (&DISKIO_DriveMediaStatusCodeTable)[unit] = 223;

            CloseDevice((struct IORequest *)DISKIO_TrackdiskIoReqPtr);
        }
    }

    GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(DISKIO_TrackdiskIoReqPtr);
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(DISKIO_TrackdiskMsgPortPtr);

    if (ESQ_MainLoopUiTickEnabledFlag == 0)
        return;

    GCOMMAND_DriveProbeRequestedFlag = 0;

    if (DISKIO_Drive0WriteProtectedCode)
        DISKIO_Drive0Dh2AssignDoneFlag = 1;
    if (DISKIO_DriveWriteProtectStatusCodeDrive1)
        DISKIO_Drive1GfxAssignDoneFlag = 1;

    if (DISKIO_Drive0Dh2AssignDoneFlag && DISKIO_Drive0WriteProtectedCode == 0) {
        savedFlags = ESQPARS2_ReadModeFlags;
        ESQPARS2_ReadModeFlags = 0x100;
        Execute(DISKIO_CMD_ASSIGN_FONTS_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_ENV_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_SYS_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_S_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_C_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_L_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_LIBS_DH2, 0L, 0L);
        Execute(DISKIO_CMD_ASSIGN_DEVS_DH2, 0L, 0L);
        ESQPARS2_ReadModeFlags = savedFlags;
        DISKIO_Drive0Dh2AssignDoneFlag = 0;
    }

    if (DISKIO_Drive1GfxAssignDoneFlag && DISKIO_DriveWriteProtectStatusCodeDrive1 == 0) {
        if (GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(DISKIO_PATH_DF1_G_ADS))
            Execute(DISKIO_CMD_ASSIGN_GFX_DF1, 0L, 0L);
        else
            Execute(DISKIO_CMD_ASSIGN_GFX_PC1, 0L, 0L);
        DISKIO_Drive1GfxAssignDoneFlag = 0;
    }
}
