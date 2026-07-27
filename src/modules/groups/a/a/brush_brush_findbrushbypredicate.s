    XDEF    _BRUSH_FindBrushByPredicate


; Returns the first brush node for which _STRING_CompareNoCase (predicate) reports success.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_FindBrushByPredicate   (Routine at _BRUSH_FindBrushByPredicate)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0
; CALLS:
;   _GROUP_AA_JMPTBL_STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_FindBrushByPredicate:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  (A2),-4(A5)

.findbrush_iterate_list:
    TST.L   -4(A5)
    BEQ.S   .findbrush_not_found

    MOVE.L  A3,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _GROUP_AA_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .findbrush_next_node

    MOVE.L  -4(A5),D0
    BRA.S   .return

.findbrush_next_node:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .findbrush_iterate_list

.findbrush_not_found:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======