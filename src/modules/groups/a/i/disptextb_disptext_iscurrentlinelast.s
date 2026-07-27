    XDEF    _DISPTEXT_IsCurrentLineLast

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_IsCurrentLineLast   (Is current line lastuncertain)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   A7/D0/D1/D2
; CALLS:
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true if _DISPTEXT_CurrentLineIndex equals _DISPTEXT_TargetLineIndex.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
_DISPTEXT_IsCurrentLineLast:
    MOVE.L  D2,-(A7)
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======