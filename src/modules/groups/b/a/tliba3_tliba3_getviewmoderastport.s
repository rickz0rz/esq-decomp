    XDEF    _TLIBA3_GetViewModeRastPort


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_GetViewModeRastPort   (_TLIBA3_GetViewModeRastPort)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   _MATH_Mulu32
; READS:
;   _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_GetViewModeRastPort:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,D0

    MOVE.L  (A7)+,D7
    RTS

;!======