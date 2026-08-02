    XDEF    _DOS_Delay


;------------------------------------------------------------------------------
; FUNC: _DOS_Delay   (Delay for D1 ticks.)
; ARGS:
;   stack +8: D1 = ticks
; RET:
;   D0: none observed
; CLOBBERS:
;   D1/A6
; CALLS:
;   _LVODelay
;------------------------------------------------------------------------------
_DOS_Delay:
    MOVE.L  A6,-(A7)

    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    MOVE.L  8(A7),D1
    JSR     _LVODelay(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======