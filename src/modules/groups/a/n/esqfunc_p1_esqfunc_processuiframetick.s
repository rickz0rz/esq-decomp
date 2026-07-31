    XDEF    _ESQFUNC_ProcessUiFrameTick


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_ProcessUiFrameTick   (Process one UI frame tick)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   _ED_DispatchEscMenuState, _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts, _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths, _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, _ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd, _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState, _ESQDISP_ProcessGridMessagesIfIdle, _ESQDISP_RefreshStatusIndicatorsFromCurrentMask, _ESQDISP_PollInputModeAndRefreshSelection, _ESQFUNC_CommitSecondaryStateAndPersist, _ESQIFF_QueueIffBrushLoad, _ESQIFF_ServiceExternalAssetSourceState, _ESQIFF_PlayNextExternalAssetFrame
; READS:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_GFX_G_ADS_DATA, LAB_097C, _PARSEINI_BannerBrushResourceHead, _WDISP_WeatherStatusBrushListHead, _CTASKS_IffTaskDoneFlag, _ED_DiagGraphModeChar, _ESQDISP_DisplayActiveFlag, _ESQDISP_SecondaryPersistRequestFlag, _ESQDISP_StatusRefreshPendingFlag, _ESQFUNC_IffTaskGateFlags, _GCOMMAND_HighlightHoldoffTickCount, _GCOMMAND_DriveProbeRequestedFlag, _Global_UIBusyFlag, _CLEANUP_PendingAlertFlag, _ESQIFF_ExternalAssetFlags, fffd, fffe
; WRITES:
;   _ESQIFF_GAdsBrushListCount, _ESQIFF_LogoBrushListCount, _ESQDISP_SecondaryPersistRequestFlag, _ESQDISP_StatusRefreshPendingFlag, _ESQFUNC_IffTaskGateFlags, _ESQIFF_ExternalAssetFlags
; DESC:
;   Runs one UI service slice: optional drive probe, input-mode polling,
;   grid/message pumping, alert processing, serial ctrl handling, brush/source
;   maintenance, and final display/status refresh checks.
; NOTES:
;   Includes multiple gating checks on UI busy flags and pending-alert/task flags.
;------------------------------------------------------------------------------
_ESQFUNC_ProcessUiFrameTick:
    TST.W   _GCOMMAND_DriveProbeRequestedFlag
    BEQ.S   .lab_0971

    JSR     _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

.lab_0971:
    MOVEQ   #1,D0
    CMP.L   _ESQDISP_DisplayActiveFlag,D0
    BNE.S   .lab_0972

    BSR.W   _ESQDISP_PollInputModeAndRefreshSelection

.lab_0972:
    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0973

    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

.lab_0973:
    JSR     _ED_DispatchEscMenuState(PC)

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0974

    JSR     _ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd(PC)

.lab_0974:
    TST.W   _CLEANUP_PendingAlertFlag
    BEQ.W   .lab_097C

    JSR     _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

    TST.L   _ESQDISP_SecondaryPersistRequestFlag
    BEQ.S   .lab_0975

    CLR.L   _ESQDISP_SecondaryPersistRequestFlag
    BSR.W   _ESQFUNC_CommitSecondaryStateAndPersist

.lab_0975:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.W   .lab_097C

    BTST    #1,_ESQFUNC_IffTaskGateFlags
    BEQ.S   .lab_0976

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0976

    BCLR    #1,_ESQFUNC_IffTaskGateFlags
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .lab_0977

.lab_0976:
    BTST    #0,_ESQFUNC_IffTaskGateFlags
    BEQ.S   .lab_0977

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0977

    BCLR    #0,_ESQFUNC_IffTaskGateFlags
    PEA     1.W
    JSR     _ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7

.lab_0977:
    TST.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    BNE.S   .lab_0978

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0978

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    MOVE.L  D0,D1
    ANDI.W  #$fffd,D1
    MOVE.W  D1,_ESQIFF_ExternalAssetFlags

.lab_0978:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0979

    TST.L   _Global_REF_LONG_GFX_G_ADS_DATA
    BNE.S   .lab_0979

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0979

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags

.lab_0979:
    TST.L   _WDISP_WeatherStatusBrushListHead
    BNE.S   .lab_097A

    TST.L   _PARSEINI_BannerBrushResourceHead
    BEQ.S   .lab_097A

    CLR.L   -(A7)
    JSR     _ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.lab_097A:
    CMPI.L  #$1,_ESQIFF_LogoBrushListCount
    BGE.S   .lab_097B

    CLR.L   -(A7)
    JSR     _ESQIFF_ServiceExternalAssetSourceState(PC)

    ADDQ.W  #4,A7
    BRA.S   .lab_097C

.lab_097B:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_097C

    CMPI.L  #$2,_ESQIFF_GAdsBrushListCount
    BGE.S   .lab_097C

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_097C

    PEA     1.W
    JSR     _ESQIFF_ServiceExternalAssetSourceState(PC)

    ADDQ.W  #4,A7

.lab_097C:
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    TST.B   _ESQDISP_StatusRefreshPendingFlag
    BEQ.S   .return

    TST.B   _GCOMMAND_HighlightHoldoffTickCount
    BNE.S   .return

    CLR.B   _ESQDISP_StatusRefreshPendingFlag
    JSR     _ESQDISP_RefreshStatusIndicatorsFromCurrentMask(PC)

.return:
    RTS

;!======