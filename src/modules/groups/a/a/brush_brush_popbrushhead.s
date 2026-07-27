    XDEF    _BRUSH_PopBrushHead


; Remove the head brush from the list at 8(A5), returning the next node.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_PopBrushHead   (Routine at _BRUSH_PopBrushHead)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0
; CALLS:
;   _BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_PopBrushHead:
    LINK.W  A5,#-4

    TST.L   8(A5)
    BNE.S   .pophead_has_node

    CLR.L   -4(A5)
    BRA.S   .pophead_return

.pophead_has_node:
    MOVEA.L 8(A5),A0
    MOVE.L  368(A0),-4(A5)
    PEA     1.W
    PEA     8(A5)
    BSR.W   _BRUSH_FreeBrushList

    ADDQ.W  #8,A7

.pophead_return:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS
