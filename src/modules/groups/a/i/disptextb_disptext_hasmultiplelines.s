    XDEF    _DISPTEXT_HasMultipleLines

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_HasMultipleLines   (Has multiple linesuncertain)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0/D1
; CALLS:
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true when more than one line is available.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_HasMultipleLines:
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    BNE.S   .return_false

    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .return

.return_false:
    MOVEQ   #0,D0

.return:
    RTS

;!======