    XDEF    _DISKIO_ForceUiRefreshIfIdle


;------------------------------------------------------------------------------
; FUNC: _DISKIO_ForceUiRefreshIfIdle   (Routine at _DISKIO_ForceUiRefreshIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
; READS:
;   _Global_UIBusyFlag
; WRITES:
;   _ESQPARS2_ReadModeFlags, _Global_RefreshTickCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_ForceUiRefreshIfIdle:
    TST.W   _Global_UIBusyFlag
    BNE.S   .return

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.W  #(-1),_Global_RefreshTickCounter
    JSR     _GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    RTS

;!======