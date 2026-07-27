    XDEF    _DISPTEXT_GetTotalLineCount

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_GetTotalLineCount   (Get total line count)
; ARGS:
;   (none)
; RET:
;   D0: _DISPTEXT_TargetLineIndex
; CLOBBERS:
;   D0
; CALLS:
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex
; WRITES:
;   (none observed)
; DESC:
;   Returns the total number of lines after ensuring state is current.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_GetTotalLineCount:
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    RTS

;!======