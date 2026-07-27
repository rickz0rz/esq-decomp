    XDEF    _BRUSH_AppendBrushNode


; Append brush node A2 to the tail of list A3 (tracking via offset 368).
;------------------------------------------------------------------------------
; FUNC: _BRUSH_AppendBrushNode   (Routine at _BRUSH_AppendBrushNode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0
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
_BRUSH_AppendBrushNode:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .append_node_find_tail

    MOVEA.L A2,A3
    BRA.S   .append_node_return

.append_node_find_tail:
    MOVE.L  A3,-4(A5)

.append_node_tail_loop:
    MOVEA.L -4(A5),A0
    TST.L   368(A0)
    BEQ.S   .append_node_link_tail

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .append_node_tail_loop

.append_node_link_tail:
    MOVEA.L -4(A5),A0
    MOVE.L  A2,368(A0)

.append_node_return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======