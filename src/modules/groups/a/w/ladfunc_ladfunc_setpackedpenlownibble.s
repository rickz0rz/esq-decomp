    XDEF    _LADFUNC_SetPackedPenLowNibble


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_SetPackedPenLowNibble   (Routine at _LADFUNC_SetPackedPenLowNibble)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D6/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LADFUNC_SetPackedPenLowNibble:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #15,D2
    AND.L   D2,D1
    OR.L    D1,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======