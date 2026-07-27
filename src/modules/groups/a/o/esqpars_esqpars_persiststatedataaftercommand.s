    XDEF    _ESQPARS_PersistStateDataAfterCommand


;------------------------------------------------------------------------------
; FUNC: _ESQPARS_PersistStateDataAfterCommand   (Flush and persist runtime state files)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _ESQPARS_JMPTBL_DATETIME_SavePairToFile, _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded, _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile, _LOCAVAIL_SaveAvailabilityDataFile, _LADFUNC_SaveTextAdsToFile
; READS:
;   _DST_BannerWindowPrimary, _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState
; WRITES:
;   (none observed)
; DESC:
;   Flushes pending data and persists text ads, banner pair, availability state,
;   and promo-id data after control commands that mutate persistent state.
; NOTES:
;   Writes both primary/secondary availability states in one call.
;------------------------------------------------------------------------------
_ESQPARS_PersistStateDataAfterCommand:
    JSR     _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(PC)

    JSR     _LADFUNC_SaveTextAdsToFile(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     _ESQPARS_JMPTBL_DATETIME_SavePairToFile(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _LOCAVAIL_SaveAvailabilityDataFile(PC)

    JSR     _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    LEA     12(A7),A7
    RTS

;!======