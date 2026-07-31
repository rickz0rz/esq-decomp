    XDEF    _ESQFUNC_CommitSecondaryStateAndPersist



;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_CommitSecondaryStateAndPersist   (Commit promoted state and persist secondary-derived data)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   _DATETIME_SavePairToFile, _ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup, _ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList, _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded, _ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile, _ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile, _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty, _ESQDISP_PropagatePrimaryTitleMetadataToSecondary, _ESQDISP_PromoteSecondaryGroupToPrimary, _ESQDISP_PromoteSecondaryLineHeadTailIfMarked, _ESQFUNC_UpdateDiskWarningAndRefreshTick
; READS:
;   _ESQPARS2_ReadModeFlags, _DST_BannerWindowPrimary, _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState
; WRITES:
;   _ESQDISP_PendingGridReinitFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Temporarily switches parser read mode, promotes/normalizes secondary state into
;   primary structures, persists dependent files, then restores previous read flags.
; NOTES:
;   Performs disk warning refresh after persist operations.
;------------------------------------------------------------------------------
_ESQFUNC_CommitSecondaryStateAndPersist:
    MOVE.L  D7,-(A7)
    MOVE.W  _ESQPARS2_ReadModeFlags,D7
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.W  #1,_ESQDISP_PendingGridReinitFlag
    BSR.W   _ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     _ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(PC)

    BSR.W   _ESQDISP_PromoteSecondaryGroupToPrimary

    BSR.W   _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty

    BSR.W   _ESQDISP_PromoteSecondaryLineHeadTailIfMarked

    JSR     _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(PC)

    JSR     _ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     _DATETIME_SavePairToFile(PC)

    JSR     _ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(PC)

    JSR     _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    BSR.W   _ESQFUNC_UpdateDiskWarningAndRefreshTick

    LEA     12(A7),A7
    MOVE.W  D7,_ESQPARS2_ReadModeFlags
    MOVE.L  (A7)+,D7
    RTS

;!======