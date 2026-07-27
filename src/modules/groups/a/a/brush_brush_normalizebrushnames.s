    XDEF    _BRUSH_NormalizeBrushNames


; Rewrite the brush filename strings in-place using _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator (path normaliser).
;------------------------------------------------------------------------------
; FUNC: _BRUSH_NormalizeBrushNames   (Routine at _BRUSH_NormalizeBrushNames)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +36: arg_2 (via 40(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7
; CALLS:
;   _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_NormalizeBrushNames:
    LINK.W  A5,#-40
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)

.normalize_names_loop:
    TST.L   -4(A5)
    BEQ.S   .return

    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    MOVEA.L A0,A1
    LEA     -40(A5),A2

.normalize_copy_to_scratch:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .normalize_copy_to_scratch

    PEA     -40(A5)
    JSR     _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0
    MOVEA.L -4(A5),A1

.normalize_copy_back:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .normalize_copy_back

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .normalize_names_loop

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======