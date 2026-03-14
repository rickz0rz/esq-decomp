#include <exec/types.h>
struct TrackdiskIoReqApprox {
    UBYTE pad0[28];
    UWORD io_Command;
    UBYTE io_Error;
    UBYTE pad1;
    LONG io_Actual;
};

extern void *AbsExecBase;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *DISKIO_TrackdiskMsgPortPtr;
extern struct TrackdiskIoReqApprox *DISKIO_TrackdiskIoReqPtr;

extern LONG DISKIO_Drive0WriteProtectedCode;
extern LONG DISKIO_DriveWriteProtectStatusCodeDrive1;
extern LONG DISKIO_DriveMediaStatusCodeTable[4];
extern LONG DISKIO_Drive0Dh2AssignDoneFlag;
extern LONG DISKIO_Drive1GfxAssignDoneFlag;
extern WORD ESQ_MainLoopUiTickEnabledFlag;
extern WORD GCOMMAND_DriveProbeRequestedFlag;
extern WORD ESQPARS2_ReadModeFlags;

extern const char DISKIO_STR_TRACKDISK_DEVICE[];
extern const char DISKIO_CMD_ASSIGN_FONTS_DH2[];
extern const char DISKIO_CMD_ASSIGN_ENV_DH2[];
extern const char DISKIO_CMD_ASSIGN_SYS_DH2[];
extern const char DISKIO_CMD_ASSIGN_S_DH2[];
extern const char DISKIO_CMD_ASSIGN_C_DH2[];
extern const char DISKIO_CMD_ASSIGN_L_DH2[];
extern const char DISKIO_CMD_ASSIGN_LIBS_DH2[];
extern const char DISKIO_CMD_ASSIGN_DEVS_DH2[];
extern const char DISKIO_PATH_DF1_G_ADS[];
extern const char DISKIO_CMD_ASSIGN_GFX_DF1[];
extern const char DISKIO_CMD_ASSIGN_GFX_PC1[];

extern LONG GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(LONG pri, LONG sig);
extern void *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, LONG size);
extern void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *ptr);
extern void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *msgPort);
extern WORD GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(const char *path);

extern LONG _LVOOpenDevice(void *execBase, const char *name, LONG unit, LONG flags, void *ioReq);
extern LONG _LVODoIO(void *execBase, void *ioReq);
extern LONG _LVOCloseDevice(void *execBase, void *ioReq);
extern LONG _LVOExecute(void *dosBase, const char *command, LONG in, LONG out);

void DISKIO_ProbeDrivesAndAssignPaths(void)
{
    LONG unit;

    DISKIO_TrackdiskMsgPortPtr = (void *)GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(0, 0);
    DISKIO_TrackdiskIoReqPtr = (struct TrackdiskIoReqApprox *)GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(
        DISKIO_TrackdiskMsgPortPtr, 56);

    for (unit = 0; unit < 4; unit++) {
        LONG openDeviceResult;

        ((LONG *)&DISKIO_Drive0WriteProtectedCode)[unit] = 0;
        DISKIO_DriveMediaStatusCodeTable[unit] = 0;

        openDeviceResult = _LVOOpenDevice(AbsExecBase, DISKIO_STR_TRACKDISK_DEVICE, unit, 0, DISKIO_TrackdiskIoReqPtr);
        if (openDeviceResult != 0) {
            ((LONG *)&DISKIO_Drive0WriteProtectedCode)[unit] = 218;
            DISKIO_DriveMediaStatusCodeTable[unit] = 223;
            continue;
        }

        DISKIO_TrackdiskIoReqPtr->io_Command = 14;
        _LVODoIO(AbsExecBase, DISKIO_TrackdiskIoReqPtr);
        if (DISKIO_TrackdiskIoReqPtr->io_Error != 0) {
            ((LONG *)&DISKIO_Drive0WriteProtectedCode)[unit] = 226;
        } else if (DISKIO_TrackdiskIoReqPtr->io_Actual != 0) {
            ((LONG *)&DISKIO_Drive0WriteProtectedCode)[unit] = 226;
        }

        DISKIO_TrackdiskIoReqPtr->io_Command = 15;
        _LVODoIO(AbsExecBase, DISKIO_TrackdiskIoReqPtr);
        if (DISKIO_TrackdiskIoReqPtr->io_Error != 0) {
            DISKIO_DriveMediaStatusCodeTable[unit] = 223;
        } else if (DISKIO_TrackdiskIoReqPtr->io_Actual != 0) {
            DISKIO_DriveMediaStatusCodeTable[unit] = 223;
        }

        _LVOCloseDevice(AbsExecBase, DISKIO_TrackdiskIoReqPtr);
    }

    GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(DISKIO_TrackdiskIoReqPtr);
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(DISKIO_TrackdiskMsgPortPtr);

    if (ESQ_MainLoopUiTickEnabledFlag == 0) {
        return;
    }

    GCOMMAND_DriveProbeRequestedFlag = 0;
    if (DISKIO_Drive0WriteProtectedCode != 0) {
        DISKIO_Drive0Dh2AssignDoneFlag = 1;
    }
    if (DISKIO_DriveWriteProtectStatusCodeDrive1 != 0) {
        DISKIO_Drive1GfxAssignDoneFlag = 1;
    }

    if (DISKIO_Drive0Dh2AssignDoneFlag != 0 && DISKIO_Drive0WriteProtectedCode == 0) {
        WORD savedReadModeFlags;

        savedReadModeFlags = ESQPARS2_ReadModeFlags;
        ESQPARS2_ReadModeFlags = 0x100;
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_FONTS_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_ENV_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_SYS_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_S_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_C_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_L_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_LIBS_DH2, 0, 0);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_DEVS_DH2, 0, 0);
        ESQPARS2_ReadModeFlags = savedReadModeFlags;
        DISKIO_Drive0Dh2AssignDoneFlag = 0;
    }

    if (DISKIO_Drive1GfxAssignDoneFlag != 0 && DISKIO_DriveWriteProtectStatusCodeDrive1 == 0) {
        if (GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(DISKIO_PATH_DF1_G_ADS) != 0) {
            _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_GFX_DF1, 0, 0);
        } else {
            _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_GFX_PC1, 0, 0);
        }
        DISKIO_Drive1GfxAssignDoneFlag = 0;
    }
}
