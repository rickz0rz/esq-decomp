    XDEF    _ED_RedrawAllRows
    XDEF    _ED_RedrawRow


;------------------------------------------------------------------------------
; FUNC: _ED_RedrawAllRows   (Redraw all rowsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ED_DrawCursorChar, _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   _ED_EditCursorOffset, _ED_BlockOffset, _ED_TextLimit, _ED_EditBufferLive
; WRITES:
;   _ED_EditCursorOffset
; DESC:
;   Redraws all rows using the current buffer contents.
; NOTES:
;   Restores _ED_EditCursorOffset to its original value after redraw.
;------------------------------------------------------------------------------
_ED_RedrawAllRows:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  _ED_EditCursorOffset,D7
    MOVEQ   #0,D0
    MOVE.B  _ED_EditBufferLive,D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  _ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #68,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CLR.L   _ED_EditCursorOffset

.redraw_loop:
    MOVE.L  _ED_EditCursorOffset,D0
    CMP.L   _ED_BlockOffset,D0
    BGE.S   .return

    BSR.W   _ED_DrawCursorChar

    ADDQ.L  #1,_ED_EditCursorOffset
    BRA.S   .redraw_loop

.return:
    MOVE.L  D7,_ED_EditCursorOffset
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_RedrawRow   (Redraw a rowuncertain)
; ARGS:
;   stack +4: u32 rowIndex
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ED_DrawCursorChar, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen
; READS:
;   _ED_EditCursorOffset, _ED_BlockOffset, _ED_TextLimit
; WRITES:
;   _ED_EditCursorOffset
; DESC:
;   Redraws a single row of text based on the given row index.
; NOTES:
;   Temporarily updates _ED_EditCursorOffset to walk the row range.
;------------------------------------------------------------------------------
_ED_RedrawRow:
    MOVEM.L D6-D7,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  _ED_EditCursorOffset,D6
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_EditCursorOffset

.row_loop:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .row_done

    BSR.W   _ED_DrawCursorChar

    ADDQ.L  #1,_ED_EditCursorOffset
    BRA.S   .row_loop

.row_done:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D6,_ED_EditCursorOffset
    MOVEM.L (A7)+,D6-D7
    RTS

;!======