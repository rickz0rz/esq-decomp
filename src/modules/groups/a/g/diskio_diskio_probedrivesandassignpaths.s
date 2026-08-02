    XDEF    _DISKIO_ProbeDrivesAndAssignPaths


;------------------------------------------------------------------------------
; FUNC: _DISKIO_ProbeDrivesAndAssignPaths   (Routine at _DISKIO_ProbeDrivesAndAssignPaths)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, _GROUP_AG_JMPTBL_SCRIPT_CheckPathExists, _GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal, _GROUP_AG_JMPTBL_STRUCT_AllocWithOwner, _GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField, _LVOCloseDevice, _LVODoIO, _LVOExecute, _LVOOpenDevice
; READS:
;   AbsExecBase, _Global_REF_DOS_LIBRARY_2, LAB_03D0, LAB_03D6, LAB_03D7, LAB_03DA, _DISKIO_Drive0Dh2AssignDoneFlag, _DISKIO_Drive1GfxAssignDoneFlag, _DISKIO_STR_TRACKDISK_DEVICE, _DISKIO_CMD_ASSIGN_FONTS_DH2, _DISKIO_CMD_ASSIGN_ENV_DH2, _DISKIO_CMD_ASSIGN_SYS_DH2, _DISKIO_CMD_ASSIGN_S_DH2, _DISKIO_CMD_ASSIGN_C_DH2, _DISKIO_CMD_ASSIGN_L_DH2, _DISKIO_CMD_ASSIGN_LIBS_DH2, _DISKIO_CMD_ASSIGN_DEVS_DH2, _DISKIO_PATH_DF1_G_ADS, _DISKIO_CMD_ASSIGN_GFX_DF1, _DISKIO_CMD_ASSIGN_GFX_PC1, _ESQ_MainLoopUiTickEnabledFlag, _ESQPARS2_ReadModeFlags, _DISKIO_TrackdiskMsgPortPtr, _DISKIO_TrackdiskIoReqPtr, _DISKIO_Drive0WriteProtectedCode, _DISKIO_DriveWriteProtectStatusCodeDrive1, _DISKIO_DriveMediaStatusCodeTable, df, e2, return
; WRITES:
;   _DISKIO_Drive0Dh2AssignDoneFlag, _DISKIO_Drive1GfxAssignDoneFlag, _ESQPARS2_ReadModeFlags, _GCOMMAND_DriveProbeRequestedFlag, _DISKIO_TrackdiskMsgPortPtr, _DISKIO_TrackdiskIoReqPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_ProbeDrivesAndAssignPaths:
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    CLR.L   -(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    MOVE.L  D0,_DISKIO_TrackdiskMsgPortPtr
    PEA     56.W
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_DISKIO_TrackdiskIoReqPtr
    MOVEQ   #0,D7

.lab_03D0:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.W   .lab_03D7

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     _DISKIO_Drive0WriteProtectedCode,A0
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.L  D0,(A0)
    LEA     _DISKIO_DriveMediaStatusCodeTable,A0
    ADDA.L  D1,A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    LEA     _DISKIO_STR_TRACKDISK_DEVICE,A0
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A1
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_03D1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISKIO_Drive0WriteProtectedCode,A0
    ADDA.L  D0,A0
    MOVE.L  #218,(A0)
    LEA     _DISKIO_DriveMediaStatusCodeTable,A0
    ADDA.L  D0,A0
    MOVE.L  #223,(A0)
    BRA.W   .lab_03D6

.lab_03D1:
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A0
    MOVE.W  #14,28(A0)
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVODoIO(A6)

    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A0
    TST.B   31(A0)
    BEQ.S   .lab_03D2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISKIO_Drive0WriteProtectedCode,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #113,D0
    ADD.L   D0,D0
    MOVE.L  D0,(A2)
    BRA.S   .lab_03D3

.lab_03D2:
    TST.L   32(A0)
    BEQ.S   .lab_03D3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISKIO_Drive0WriteProtectedCode,A1
    ADDA.L  D0,A1
    MOVE.L  #$e2,(A1)

.lab_03D3:
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A0
    MOVE.W  #15,28(A0)
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVODoIO(A6)

    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A0
    TST.B   31(A0)
    BEQ.S   .lab_03D4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISKIO_DriveMediaStatusCodeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D0
    NOT.B   D0
    MOVE.L  D0,(A1)
    BRA.S   .lab_03D5

.lab_03D4:
    TST.L   32(A0)
    BEQ.S   .lab_03D5

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISKIO_DriveMediaStatusCodeTable,A0
    ADDA.L  D0,A0
    MOVE.L  #$df,(A0)

.lab_03D5:
    MOVEA.L _DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVOCloseDevice(A6)

.lab_03D6:
    ADDQ.L  #1,D7
    BRA.W   .lab_03D0

.lab_03D7:
    MOVE.L  _DISKIO_TrackdiskIoReqPtr,-(A7)
    JSR     _GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(PC)

    MOVE.L  _DISKIO_TrackdiskMsgPortPtr,(A7)
    JSR     _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    ADDQ.W  #4,A7
    TST.W   _ESQ_MainLoopUiTickEnabledFlag
    BEQ.W   .return

    CLR.W   _GCOMMAND_DriveProbeRequestedFlag
    TST.L   _DISKIO_Drive0WriteProtectedCode
    BEQ.S   .lab_03D8

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_Drive0Dh2AssignDoneFlag

.lab_03D8:
    TST.L   _DISKIO_DriveWriteProtectStatusCodeDrive1
    BEQ.S   .lab_03D9

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_Drive1GfxAssignDoneFlag

.lab_03D9:
    TST.L   _DISKIO_Drive0Dh2AssignDoneFlag
    BEQ.W   .lab_03DA

    TST.L   _DISKIO_Drive0WriteProtectedCode
    BNE.W   .lab_03DA

    MOVE.W  _ESQPARS2_ReadModeFlags,D5
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    LEA     _DISKIO_CMD_ASSIGN_FONTS_DH2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_ENV_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_SYS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_S_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_C_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_L_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_LIBS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_DEVS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.W  D5,_ESQPARS2_ReadModeFlags
    MOVE.L  D2,_DISKIO_Drive0Dh2AssignDoneFlag

.lab_03DA:
    TST.L   _DISKIO_Drive1GfxAssignDoneFlag
    BEQ.S   .return

    TST.L   _DISKIO_DriveWriteProtectStatusCodeDrive1
    BNE.S   .return

    PEA     _DISKIO_PATH_DF1_G_ADS
    JSR     _GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .lab_03DB

    LEA     _DISKIO_CMD_ASSIGN_GFX_DF1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.S   .lab_03DC

.lab_03DB:
    LEA     _DISKIO_CMD_ASSIGN_GFX_PC1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.lab_03DC:
    MOVE.L  D2,_DISKIO_Drive1GfxAssignDoneFlag

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    RTS

;!======