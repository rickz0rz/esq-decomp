    XDEF    _TLIBA3_SetFontForAllViewModes



;------------------------------------------------------------------------------
; FUNC: _TLIBA3_SetFontForAllViewModes   (_TLIBA3_SetFontForAllViewModes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D7
; CALLS:
;   _MATH_Mulu32, _LVOSetFont
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_SetFontForAllViewModes:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.lab_1859:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L A3,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D7
    BRA.S   .lab_1859

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======