    XDEF    LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: LADFUNC_GetPackedPenLowNibble   (Routine at LADFUNC_GetPackedPenLowNibble)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   f
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC_GetPackedPenLowNibble:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    ANDI.B  #$f,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
