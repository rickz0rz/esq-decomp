    XDEF    _NEWGRID_DrawSelectionMarkers



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawSelectionMarkers   (Draw selection glyph markers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +12: arg_4 (via 16(A5))
;   stack +14: arg_5 (via 18(A5))
;   stack +16: arg_6 (via 20(A5))
;   stack +20: arg_7 (via 24(A5))
;   stack +24: arg_8 (via 28(A5))
;   stack +28: arg_9 (via 32(A5))
;   stack +29: arg_10 (via 33(A5))
;   stack +30: arg_11 (via 34(A5))
;   stack +31: arg_12 (via 35(A5))
;   stack +32: arg_13 (via 36(A5))
; RET:
;   D0: status from _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridCellBackground, _NEWGRID_SetSelectionMarkers, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine,
;   _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _LVOMove, _LVOText, _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Lays out and draws selection marker glyphs for a row and column.
; NOTES:
;   Computes centered positions using rounding before ASR.
;------------------------------------------------------------------------------
_NEWGRID_DrawSelectionMarkers:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   _NEWGRID_DrawGridCellBackground

    PEA     -36(A5)
    PEA     -35(A5)
    PEA     -34(A5)
    PEA     -33(A5)
    MOVE.L  28(A5),-(A7)
    MOVE.L  24(A5),-(A7)
    BSR.W   _NEWGRID_SetSelectionMarkers

    LEA     40(A7),A7
    TST.B   -33(A5)
    BEQ.S   .measure_primary

    MOVEA.L -4(A5),A1
    LEA     -33(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_primary_width

.measure_primary:
    MOVEQ   #0,D0

.store_primary_width:
    MOVE.L  D0,-24(A5)
    TST.B   -35(A5)
    BEQ.S   .measure_secondary

    MOVEA.L -4(A5),A1
    LEA     -35(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_secondary_width

.measure_secondary:
    MOVEQ   #0,D0

.store_secondary_width:
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnStartXPx,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MOVE.L  D7,D3
    MULS    D2,D3
    ADD.L   D3,D1
    ADD.L   -24(A5),D1
    MOVEQ   #42,D2
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  _NEWGRID_RowHeightPx,D2
    MOVE.L  D2,D3
    TST.L   D3
    BPL.S   .round_width_half

    ADDQ.L  #1,D3

.round_width_half:
    ASR.L   #1,D3
    MOVEA.L -4(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    SUB.L   D4,D3
    SUBQ.L  #4,D3
    TST.L   D3
    BPL.S   .round_width_half_adjust

    ADDQ.L  #1,D3

.round_width_half_adjust:
    ASR.L   #1,D3
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    ADD.L   D4,D3
    ADDQ.L  #3,D3
    MOVEQ   #0,D4
    MOVE.W  D2,D4
    TST.L   D4
    BPL.S   .round_text_half

    ADDQ.L  #1,D4

.round_text_half:
    ASR.L   #1,D4
    MOVE.L  D0,-28(A5)
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    SUB.L   D0,D4
    SUBQ.L  #4,D4
    TST.L   D4
    BPL.S   .round_text_half_adjust

    ADDQ.L  #1,D4

.round_text_half_adjust:
    ASR.L   #1,D4
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D4
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    TST.L   D0
    BPL.S   .round_cell_half

    ADDQ.L  #1,D0

.round_cell_half:
    ASR.L   #1,D0
    ADD.L   D0,D4
    SUBQ.L  #1,D4
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    TST.L   D0
    BPL.S   .round_cell_half_adjust

    ADDQ.L  #1,D0

.round_cell_half_adjust:
    ASR.L   #1,D0
    MOVE.L  D4,-16(A5)
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    SUB.L   D4,D0
    TST.L   D0
    BPL.S   .round_left_half

    ADDQ.L  #1,D0

.round_left_half:
    ASR.L   #1,D0
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    ADD.L   D4,D0
    MOVEQ   #0,D4
    MOVE.W  D2,D4
    TST.L   D4
    BPL.S   .round_left_half_adjust

    ADDQ.L  #1,D4

.round_left_half_adjust:
    ASR.L   #1,D4
    ADD.L   D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-20(A5)
    MOVE.L  D1,-8(A5)
    MOVE.L  D3,-12(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .after_frame

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .choose_alt_x

    MOVE.L  -16(A5),D0
    BRA.S   .choose_default_x

.choose_alt_x:
    MOVE.L  -20(A5),D0

.choose_default_x:
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7

.after_frame:
    TST.B   -33(A5)
    BEQ.S   .draw_secondary_glyphs

    MOVE.L  -24(A5),D0
    SUB.L   D0,-8(A5)
    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -12(A5),D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -33(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -16(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -34(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

.draw_secondary_glyphs:
    TST.B   -35(A5)
    BEQ.S   .after_glyphs

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    ADD.L   D1,D0
    SUB.L   -28(A5),D0
    MOVEQ   #29,D1
    ADD.L   D1,D0
    MOVE.L  D0,-8(A5)
    MOVEA.L -4(A5),A1
    MOVE.L  -12(A5),D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -35(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -16(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -36(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

.after_glyphs:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-32(A5)
    BEQ.S   .done

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .done

    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .done

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.done:
    MOVE.L  -32(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======