    XDEF    _ED1_WaitForFlagAndClearBit1


;------------------------------------------------------------------------------
; FUNC: _ED1_WaitForFlagAndClearBit1   (Wait for flag and clear bit 1)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   _ESQIFF_ReloadExternalAssetCatalogBuffers
; READS:
;   _CTASKS_IffTaskDoneFlag, _ESQIFF_ExternalAssetFlags
; WRITES:
;   _LADFUNC_EntryCount, _ESQIFF_ExternalAssetFlags
; DESC:
;   Busy-waits for _CTASKS_IffTaskDoneFlag then clears bit 1 in _ESQIFF_ExternalAssetFlags and signals.
; NOTES:
;   Passes 0 to _ESQIFF_ReloadExternalAssetCatalogBuffers.
;------------------------------------------------------------------------------
_ED1_WaitForFlagAndClearBit1:
.wait_flag:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_flag

    MOVE.W  #$2e,_LADFUNC_EntryCount
    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffd,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags
    CLR.L   -(A7)
    JSR     _ESQIFF_ReloadExternalAssetCatalogBuffers(PC)

    ADDQ.W  #4,A7
    RTS

;!======