    XDEF    _NEWGRID_DrawGridFrameAndRows



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridFrameAndRows   (Draw grid frame and row dividers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: status from _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount, _NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength,
;   _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws the grid background/frame and row separator lines, updating layout.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridFrameAndRows:
    LINK.W  A5,#-28
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .done

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,40(A7)
    BSR.W   _NEWGRID_SetRowColor

    MOVEA.L 40(A7),A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D5
    CLR.L   -16(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(PC)

    LEA     12(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .after_header

    LEA     60(A3),A0
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(PC)

    ADDQ.W  #4,A7
    MOVE.L  #612,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_header

    ADDQ.L  #1,D1

.center_header:
    ASR.L   #1,D1
    ADD.L   D1,D5
    MOVEQ   #4,D0
    MOVE.L  D0,-16(A5)

.after_header:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    MOVEQ   #0,D6
    MOVE.L  D0,-24(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    TST.L   D6
    BNE.S   .row_flag_path

    TST.L   -24(A5)
    BEQ.S   .row_flag_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .row_half_width

    ADDQ.L  #1,D0

.row_half_width:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .row_half_width_adjust

    ADDQ.L  #1,D0

.row_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    ADDQ.L  #3,D4
    BRA.S   .draw_row_line

.row_flag_path:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .row_default_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .row_flag_half_width

    ADDQ.L  #1,D1

.row_flag_half_width:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .row_flag_half_width_adjust

    ADDQ.L  #1,D1

.row_flag_half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    MOVE.L  -16(A5),D2
    ADD.L   D2,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4
    BRA.S   .draw_row_line

.row_default_path:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .row_default_half_width

    ADDQ.L  #1,D0

.row_default_half_width:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .row_default_half_width_adjust

    ADDQ.L  #1,D0

.row_default_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  -16(A5),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4

.draw_row_line:
    LEA     60(A3),A0
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,-16(A5)
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-20(A5)
    TST.L   -24(A5)
    BEQ.S   .draw_bottom_bevel

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

    LEA     20(A7),A7

.draw_bottom_bevel:
    TST.L   -20(A5)
    BEQ.S   .draw_top_bevel

    LEA     60(A3),A0
    MOVE.L  -16(A5),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.draw_top_bevel:
    MOVE.L  -16(A5),D0
    BPL.S   .store_header_width

    ADDQ.L  #1,D0

.store_header_width:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)

.done:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======