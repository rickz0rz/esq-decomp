    XDEF    _ESQDISP_RefreshStatusIndicatorsFromCurrentMask

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_RefreshStatusIndicatorsFromCurrentMask   (Reapply current status mask to indicators)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Re-runs status-indicator coloring from the already stored global mask value.
; NOTES:
;   Calls _ESQDISP_ApplyStatusMaskToIndicators with sentinel mask `-1`.
;------------------------------------------------------------------------------
_ESQDISP_RefreshStatusIndicatorsFromCurrentMask:
    PEA     -1.W
    BSR.W   _ESQDISP_ApplyStatusMaskToIndicators

    ADDQ.W  #4,A7
    RTS

;!======
