    XDEF    _NEWGRID_DrawClockFormatHeader


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawClockFormatHeader   (Draw clock header row)
; ARGS:
;   stack +8: A3 = base rastport/struct
;   stack +12: D7 = start index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOSetDrMd, _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry,
;   _NEWGRID_JMPTBL_MATH_Mulu32, _LVOTextLength, _LVOMove, _LVOText, _NEWGRID_ValidateSelectionCode
; READS:
;   _NEWGRID_ColumnStartXPx/232B, _NEWGRID_RowHeightPx
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the grid header bar and column labels for three day slots.
; NOTES:
;   Uses wraparound at 48 and centers text within computed column widths.
;------------------------------------------------------------------------------
_NEWGRID_DrawClockFormatHeader:
    LINK.W  A5,#-108
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    LEA     60(A3),A0
    MOVE.L  A0,-102(A5)

    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_SetRowColor(PC)

    MOVEA.L -102(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -102(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -102(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D6

.loop_columns:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.W   .finish_columns

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .use_wrapped_slot_index

    SUB.L   D1,D0
    BRA.S   .use_current_slot_index

.use_wrapped_slot_index:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.use_current_slot_index:
    MOVE.L  D0,D5
    PEA     -97(A5)
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,28(A7)
    MOVE.L  D6,D0
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  28(A7),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #36,D0
    ADD.L   D0,D4
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .compute_column_right_edge

    MOVE.L  #695,D0
    BRA.S   .draw_column_frame_bg

.compute_column_right_edge:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    ADD.L   D4,D0
    SUBQ.L  #1,D0

.draw_column_frame_bg:
    PEA     33.W
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -102(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

    MOVEA.L -102(A5),A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

.measure_label:
    TST.B   (A1)+
    BNE.S   .measure_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOTextLength(A6)

    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_label

    ADDQ.L  #1,D1

.center_label:
    ASR.L   #1,D1
    ADDQ.L  #2,D1
    ADD.L   D1,D4
    MOVEA.L -102(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_label_y

    ADDQ.L  #1,D1

.center_label_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D4,D0
    JSR     _LVOMove(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

.draw_label:
    TST.B   (A1)+
    BNE.S   .draw_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .loop_columns

.finish_columns:
    MOVE.W  #17,52(A3)
    PEA     64.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_ValidateSelectionCode(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A3),D0
    MOVE.L  D0,32(A3)

    MOVEM.L -136(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======