    XDEF    _BRUSH_FindType3Brush


; Walk the brush list and return the first entry whose type byte (offset 32) is 3.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_FindType3Brush   (Routine at _BRUSH_FindType3Brush)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
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
_BRUSH_FindType3Brush:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)
    MOVEQ   #0,D7

.findtype3_scan_loop:
    TST.L   -4(A5)
    BEQ.S   .findtype3_after_scan

    TST.L   D7
    BNE.S   .findtype3_after_scan

    MOVEQ   #3,D0
    MOVEA.L -4(A5),A0
    CMP.B   32(A0),D0
    BNE.S   .findtype3_after_type_check

    MOVEQ   #1,D7

.findtype3_after_type_check:
    TST.L   D7
    BNE.S   .findtype3_scan_loop

    MOVE.L  368(A0),-4(A5)
    BRA.S   .findtype3_scan_loop

.findtype3_after_scan:
    TST.L   D7
    BEQ.S   .findtype3_not_found

    MOVEA.L -4(A5),A0
    BRA.S   .findtype3_return

.findtype3_not_found:
    SUBA.L  A0,A0

.findtype3_return:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======