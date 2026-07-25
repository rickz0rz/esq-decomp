    XDEF    _LADFUNC_GetPackedPenHighNibble

;------------------------------------------------------------------------------
; FUNC: _LADFUNC_GetPackedPenHighNibble   (Routine at _LADFUNC_GetPackedPenHighNibble)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
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
_LADFUNC_GetPackedPenHighNibble:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    ASR.L   #4,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    MOVE.L  (A7)+,D7
    RTS

;!======
