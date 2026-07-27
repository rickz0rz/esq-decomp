    XDEF    _LADFUNC_UpdateHighlightState



;------------------------------------------------------------------------------
; FUNC: _LADFUNC_UpdateHighlightState   (UpdateHighlightState)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   (none)
; READS:
;   _ED_DiagTextModeChar, _LADFUNC_EntryPtrTable, _CLOCK_HalfHourSlotIndex
; WRITES:
;   _WDISP_HighlightActive, _WDISP_HighlightIndex, [A3] fields
; DESC:
;   Clears highlight state and walks banner rectangles to mark the active one.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46) via compare against 46.
;------------------------------------------------------------------------------
; Mark banner rectangles that should be highlighted based on the current cursor slot.
_LADFUNC_UpdateHighlightState:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,_WDISP_HighlightActive
    MOVE.W  D0,_WDISP_HighlightIndex
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .done

    MOVEQ   #0,D7

.rect_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    CLR.W   4(A3)
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVE.W  (A3),D1
    CMP.W   D0,D1
    BGT.S   .next_rect

    MOVE.W  2(A3),D1
    CMP.W   D0,D1
    BLT.S   .next_rect

    TST.L   6(A3)
    BEQ.S   .next_rect

    MOVEQ   #1,D0
    MOVE.W  D0,4(A3)
    MOVE.W  D0,_WDISP_HighlightActive

.next_rect:
    ADDQ.L  #1,D7
    BRA.S   .rect_loop

.done:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======