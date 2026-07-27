    XDEF    _LADFUNC2_EmitEscapedStringToScratch


;------------------------------------------------------------------------------
; FUNC: _LADFUNC2_EmitEscapedStringToScratch   (Routine at _LADFUNC2_EmitEscapedStringToScratch)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   _LADFUNC2_EmitEscapedCharToScratch
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LADFUNC2_EmitEscapedStringToScratch:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .lab_0EFB

.lab_0EFA:
    TST.B   (A3)
    BEQ.S   .lab_0EFB

    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _LADFUNC2_EmitEscapedCharToScratch

    ADDQ.W  #4,A7
    BRA.S   .lab_0EFA

.lab_0EFB:
    MOVEA.L (A7)+,A3
    RTS

;!======