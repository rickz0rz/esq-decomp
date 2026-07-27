    XDEF    _NEWGRID_DrawGridHeaderRows


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridHeaderRows   (Draw header row separators)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: status from _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop, _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws header frame and repeated horizontal separators for the grid.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridHeaderRows:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEQ   #0,D5
    MOVE.L  D5,D4
    MOVE.L  D0,-12(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,-16(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .alt_half_width

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .half_width_round

    ADDQ.L  #1,D1

.half_width_round:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .half_width_adjust

    ADDQ.L  #1,D1

.half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,-16(A5)
    BRA.S   .draw_row

.alt_half_width:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .alt_half_width_round

    ADDQ.L  #1,D0

.alt_half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .alt_half_width_adjust

    ADDQ.L  #1,D0

.alt_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,-16(A5)

.draw_row:
    LEA     60(A3),A0
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D5
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-20(A5)
    BEQ.S   .draw_bottom_bevel

    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D4
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     36(A7),A7
    BRA.S   .store_header_width

.draw_bottom_bevel:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

    LEA     36(A7),A7

.store_header_width:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   .round_header_half

    ADDQ.L  #1,D0

.round_header_half:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======