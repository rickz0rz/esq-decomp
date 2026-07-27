    XDEF    _TLIBA3_ClearViewModeRastPort


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_ClearViewModeRastPort   (_TLIBA3_ClearViewModeRastPort)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   _MATH_Mulu32, _LVOSetRast
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_ClearViewModeRastPort:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  D6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======