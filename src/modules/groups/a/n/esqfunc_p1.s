    XDEF    ESQFUNC_CommitSecondaryStateAndPersist
    XDEF    _ESQFUNC_ProcessUiFrameTick


;------------------------------------------------------------------------------
; FUNC: ESQFUNC_CommitSecondaryStateAndPersist   (Commit promoted state and persist secondary-derived data)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   DATETIME_SavePairToFile, ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup, ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList, _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded, ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile, ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile, ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty, ESQDISP_PropagatePrimaryTitleMetadataToSecondary, ESQDISP_PromoteSecondaryGroupToPrimary, _ESQDISP_PromoteSecondaryLineHeadTailIfMarked, _ESQFUNC_UpdateDiskWarningAndRefreshTick
; READS:
;   _ESQPARS2_ReadModeFlags, _DST_BannerWindowPrimary, _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState
; WRITES:
;   ESQDISP_PendingGridReinitFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Temporarily switches parser read mode, promotes/normalizes secondary state into
;   primary structures, persists dependent files, then restores previous read flags.
; NOTES:
;   Performs disk warning refresh after persist operations.
;------------------------------------------------------------------------------
ESQFUNC_CommitSecondaryStateAndPersist:
    MOVE.L  D7,-(A7)
    MOVE.W  _ESQPARS2_ReadModeFlags,D7
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.W  #1,ESQDISP_PendingGridReinitFlag
    BSR.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(PC)

    BSR.W   ESQDISP_PromoteSecondaryGroupToPrimary

    BSR.W   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty

    BSR.W   _ESQDISP_PromoteSecondaryLineHeadTailIfMarked

    JSR     _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(PC)

    JSR     ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     DATETIME_SavePairToFile(PC)

    JSR     ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(PC)

    JSR     _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    BSR.W   _ESQFUNC_UpdateDiskWarningAndRefreshTick

    LEA     12(A7),A7
    MOVE.W  D7,_ESQPARS2_ReadModeFlags
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_ProcessUiFrameTick   (Process one UI frame tick)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   ED_DispatchEscMenuState, ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts, _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths, ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd, ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState, _ESQDISP_ProcessGridMessagesIfIdle, _ESQDISP_RefreshStatusIndicatorsFromCurrentMask, ESQDISP_PollInputModeAndRefreshSelection, ESQFUNC_CommitSecondaryStateAndPersist, ESQIFF_QueueIffBrushLoad, ESQIFF_ServiceExternalAssetSourceState, ESQIFF_PlayNextExternalAssetFrame
; READS:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_GFX_G_ADS_DATA, LAB_097C, _PARSEINI_BannerBrushResourceHead, _WDISP_WeatherStatusBrushListHead, _CTASKS_IffTaskDoneFlag, _ED_DiagGraphModeChar, ESQDISP_DisplayActiveFlag, ESQDISP_SecondaryPersistRequestFlag, _ESQDISP_StatusRefreshPendingFlag, ESQFUNC_IffTaskGateFlags, _GCOMMAND_HighlightHoldoffTickCount, _GCOMMAND_DriveProbeRequestedFlag, _Global_UIBusyFlag, CLEANUP_PendingAlertFlag, _ESQIFF_ExternalAssetFlags, fffd, fffe
; WRITES:
;   _ESQIFF_GAdsBrushListCount, _ESQIFF_LogoBrushListCount, ESQDISP_SecondaryPersistRequestFlag, _ESQDISP_StatusRefreshPendingFlag, ESQFUNC_IffTaskGateFlags, _ESQIFF_ExternalAssetFlags
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
    CMP.L   ESQDISP_DisplayActiveFlag,D0
    BNE.S   .lab_0972

    BSR.W   ESQDISP_PollInputModeAndRefreshSelection

.lab_0972:
    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0973

    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

.lab_0973:
    JSR     ED_DispatchEscMenuState(PC)

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0974

    JSR     ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd(PC)

.lab_0974:
    TST.W   CLEANUP_PendingAlertFlag
    BEQ.W   .lab_097C

    JSR     ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

    TST.L   ESQDISP_SecondaryPersistRequestFlag
    BEQ.S   .lab_0975

    CLR.L   ESQDISP_SecondaryPersistRequestFlag
    BSR.W   ESQFUNC_CommitSecondaryStateAndPersist

.lab_0975:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.W   .lab_097C

    BTST    #1,ESQFUNC_IffTaskGateFlags
    BEQ.S   .lab_0976

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0976

    BCLR    #1,ESQFUNC_IffTaskGateFlags
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .lab_0977

.lab_0976:
    BTST    #0,ESQFUNC_IffTaskGateFlags
    BEQ.S   .lab_0977

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_0977

    BCLR    #0,ESQFUNC_IffTaskGateFlags
    PEA     1.W
    JSR     ESQIFF_PlayNextExternalAssetFrame(PC)

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
    JSR     ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.lab_097A:
    CMPI.L  #$1,_ESQIFF_LogoBrushListCount
    BGE.S   .lab_097B

    CLR.L   -(A7)
    JSR     ESQIFF_ServiceExternalAssetSourceState(PC)

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
    JSR     ESQIFF_ServiceExternalAssetSourceState(PC)

    ADDQ.W  #4,A7

.lab_097C:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    TST.B   _ESQDISP_StatusRefreshPendingFlag
    BEQ.S   .return

    TST.B   _GCOMMAND_HighlightHoldoffTickCount
    BNE.S   .return

    CLR.B   _ESQDISP_StatusRefreshPendingFlag
    JSR     _ESQDISP_RefreshStatusIndicatorsFromCurrentMask(PC)

.return:
    RTS

;!======