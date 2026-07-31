    XDEF    _ED_UpdateCursorPosFromIndex


;------------------------------------------------------------------------------
; FUNC: _ED_UpdateCursorPosFromIndex   (Update cursor row/col from indexuncertain)
; ARGS:
;   stack +4: u32 index
; RET:
;   (none)
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _ESQIFF_JMPTBL_MATH_DivS32
; READS:
;   _ED_TextLimit
; WRITES:
;   _ED_CursorColumnIndex, _ED_ViewportOffset, _ED_EditCursorOffset
; DESC:
;   Computes row/column indices from a linear cursor index.
; NOTES:
;   Clamps _ED_ViewportOffset and _ED_EditCursorOffset to visible ranges.
;------------------------------------------------------------------------------
_ED_UpdateCursorPosFromIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,_ED_CursorColumnIndex
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,_ED_ViewportOffset

.clamp_cursor_loop:
    MOVE.L  _ED_ViewportOffset,D0
    CMP.L   _ED_TextLimit,D0
    BLT.S   .return

    SUBQ.L  #1,_ED_ViewportOffset
    MOVEQ   #40,D0
    SUB.L   D0,_ED_EditCursorOffset
    BRA.S   .clamp_cursor_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======