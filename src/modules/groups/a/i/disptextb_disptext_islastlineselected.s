    XDEF    _DISPTEXT_IsLastLineSelected

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_IsLastLineSelected   (Is last line selecteduncertain)
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
;   Returns true if current line index is the last line.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
_DISPTEXT_IsLastLineSelected:
    MOVE.L  D2,-(A7)
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
    CMP.L   D0,D1
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======