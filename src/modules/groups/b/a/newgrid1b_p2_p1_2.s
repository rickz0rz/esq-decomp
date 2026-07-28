    XDEF    NEWGRID_DrawEmptyGridMessage
    XDEF    NEWGRID_DrawGridFrameAlt
    XDEF    NEWGRID_DrawGridFrameVariant2
    XDEF    _NEWGRID_DrawStatusMessage
    XDEF    _NEWGRID_FindNextEntryWithAltMarkers
    XDEF    NEWGRID_FindNextEntryWithMarkers
    XDEF    NEWGRID_HandleAltGridState
    XDEF    _NEWGRID_HandleDetailGridState
    XDEF    NEWGRID_ProcessAltEntryState


;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEmptyGridMessage   (Draw empty grid message)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +14: arg_2 (via 18(A5))
;   stack +124: arg_3 (via 128(A5))
;   stack +155: arg_4 (via 159(A5))
;   stack +188: arg_5 (via 192(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength, _LVOMove, _LVOText,
;   _NEWGRID_ValidateSelectionCode
; READS:
;   SCRIPT_PtrMovieSummaryForPrefix, _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Builds and draws the "no data" banner centered in the grid area.
;------------------------------------------------------------------------------
NEWGRID_DrawEmptyGridMessage:
    LINK.W  A5,#-172
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  18(A5),D7
    PEA     33.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    MOVEA.L SCRIPT_PtrMovieSummaryForPrefix,A0
    LEA     -128(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -159(A5)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    PEA     -159(A5)
    PEA     -128(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     76(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -128(A5),A2
    MOVEA.L A2,A6

.measure_message:
    TST.B   (A6)+
    BNE.S   .measure_message

    SUBQ.L  #1,A6
    SUBA.L  A2,A6
    MOVE.L  D0,24(A7)
    MOVE.L  D1,28(A7)
    MOVE.L  A0,20(A7)
    MOVEA.L A2,A0
    MOVE.L  A6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  28(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  24(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_y

    ADDQ.L  #1,D2

.center_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 20(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A2,A1

.draw_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A2,A1
    MOVE.L  A1,24(A7)
    MOVEA.L A0,A1
    MOVEA.L A2,A0
    MOVE.L  24(A7),D0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     65.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    MOVEM.L -192(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameAlt   (Draw alternate grid frame)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: status from _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines, _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine,
;   _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop, _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx, _DISPTEXT_ControlMarkerXOffsetPx
; DESC:
;   Draws an alternate frame layout with row separators and beveled edges.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameAlt:
    LINK.W  A5,#-24
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.L  D0,D6
    MOVEQ   #42,D1
    ADD.L   D1,D6
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7
    MOVE.L  D7,D4
    MOVE.L  D0,-20(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    TST.L   D7
    BNE.S   .alt_path

    TST.L   -20(A5)
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .half_width_round

    ADDQ.L  #1,D0

.half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .half_width_adjust

    ADDQ.L  #1,D0

.half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   .draw_row

.alt_path:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .alt_half_width_round

    ADDQ.L  #1,D1

.alt_half_width_round:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .alt_half_width_adjust

    ADDQ.L  #1,D1

.alt_half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   .draw_row

.default_path:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .default_half_width_round

    ADDQ.L  #1,D0

.default_half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .default_half_width_adjust

    ADDQ.L  #1,D0

.default_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

.draw_row:
    LEA     60(A3),A0
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-24(A5)
    TST.L   -20(A5)
    BEQ.W   .draw_bevel_bottom

    MOVEQ   #0,D4
    MOVE.W  _NEWGRID_RowHeightPx,D4
    TST.L   D0
    BEQ.S   .draw_bevel_alt

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
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

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
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     36(A7),A7
    BRA.W   .store_header_width

.draw_bevel_alt:
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     36(A7),A7
    BRA.W   .store_header_width

.draw_bevel_bottom:
    TST.L   D0
    BEQ.S   .draw_bevel_pair

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

.draw_bevel_pair:
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
    MOVE.L  -24(A5),D0
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleAltGridState   (Handle alternate grid state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = entry index
;   stack +18: D6 = selector
; RET:
;   D0: state (NEWGRID_AltGridStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, NEWGRID_DrawGridFrameAlt, NEWGRID_DrawGridCell,
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   NEWGRID_ShowtimeEntryVariantFlag, _CLOCK_DaySlotIndex
; WRITES:
;   NEWGRID_AltGridStateLatch, 32(A3)
; DESC:
;   State machine that draws a single grid entry and updates the frame.
; NOTES:
;   Uses NEWGRID_AltGridStateLatch values 4/5.
;------------------------------------------------------------------------------
NEWGRID_HandleAltGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_AltGridStateLatch
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  NEWGRID_AltGridStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_frame_only

    BRA.W   .force_state4

.state4_begin:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .have_entry_ptrs

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BEQ.S   .use_alt_entry_table

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .have_entry_ptrs

.use_alt_entry_table:
    MOVE.L  -8(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    MOVE.L  D0,D7
    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-8(A5)

.have_entry_ptrs:
    TST.L   -4(A5)
    BEQ.W   .return_state

    TST.L   -8(A5)
    BEQ.W   .return_state

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .return_state

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A0,D0.L),A0
    TST.B   (A0)
    BEQ.W   .return_state

    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    MULU    #3,D0
    MOVEQ   #12,D1
    SUB.L   D1,D0
    PEA     1.W
    PEA     20.W
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    TST.W   NEWGRID_ShowtimeEntryVariantFlag
    BEQ.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_entry_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_entry_draw:
    PEA     2.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  A3,(A7)
    BSR.W   NEWGRID_DrawGridFrameAlt

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state5_after_draw

    MOVEQ   #4,D0
    BRA.S   .store_state_and_linecount

.set_state5_after_draw:
    MOVEQ   #5,D0

.store_state_and_linecount:
    LEA     60(A3),A0
    MOVE.L  D0,NEWGRID_AltGridStateLatch
    SUBQ.L  #4,D0
    BNE.S   .set_draw_flag

    MOVEQ   #1,D0
    BRA.S   .draw_cell

.set_draw_flag:
    MOVEQ   #0,D0

.draw_cell:
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridCell

    LEA     12(A7),A7
    BRA.S   .return_state

.state5_frame_only:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAlt

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state_and_reset_linecount

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state_and_reset_linecount:
    MOVE.L  D0,NEWGRID_AltGridStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_AltGridStateLatch

.return_state:
    MOVE.L  NEWGRID_AltGridStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextEntryWithMarkers   (Find next entry meeting marker criteria)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
;   stack +18: D5 = selector/column offset used in metadata lookups
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID_ShouldOpenEditor
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward and returns the first entry that passes a stricter compound
;   eligibility gate than `_NEWGRID_FindNextEntryWithFlags`: entry flag bits,
;   marker-bitset test, editor-open veto, selector metadata bits, and payload ptr.
; NOTES:
;   Uses both entry record and selector metadata table pointers produced by
;   `NEWGRID_UpdatePresetEntry`.
;   The aux pointer is treated as a selector-indexed record where
;   `56 + (selector*4)` stores a text/source pointer used by downstream
;   rendering/selection routines.
;   Returns `-1` when no entry satisfies all gates.
;   Uses entry fields in `A0+46`, `A0+40`, `A0+27`, `A0+56` (names unknown).
;------------------------------------------------------------------------------
NEWGRID_FindNextEntryWithMarkers:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_reset

    SUBQ.L  #4,D0
    BEQ.S   .case_increment

    BRA.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D4

.check_loop:
    TST.L   D4
    BNE.W   .return

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .return

.scan_loop:
    TST.L   D4
    BNE.W   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .scan_done

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    TST.L   -4(A5)                        ; local ptr A: entry record ptr (from NEWGRID_UpdatePresetEntry out0)
    BEQ.W   .advance_index

    TST.L   -8(A5)                        ; local ptr B: entry aux/selector-metadata ptr (from NEWGRID_UpdatePresetEntry out1)
    BEQ.S   .advance_index

    MOVEA.L -4(A5),A0
    MOVE.W  Struct_PrimaryEntry__StateFlagsWord(A0),D0           ; A0+46 = entry state flags word
    BTST    #1,D0
    BEQ.S   .advance_index

    MOVE.B  Struct_PrimaryEntry__MarkerStatusByte(A0),D0         ; A0+40 = entry marker/status byte
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A0),A1      ; A0+28 = marker bitset base for _ESQ_TestBit1Based
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .advance_index

    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .advance_index

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata offset
    BTST    #1,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flags byte (bit1 alters alt-flag gate)
    BNE.S   .check_alt_flags

    MOVEA.L -4(A5),A1
    MOVE.B  Struct_PrimaryEntry__EditorFlagsByte(A1),D0          ; A1+27 = entry flags byte (bit4 required when selector bit1 clear)
    BTST    #4,D0
    BEQ.S   .advance_index

.check_alt_flags:
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata offset
    BTST    #7,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flags byte (bit7 blocks candidate)
    BNE.S   .advance_index

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A0)       ; A0+56 = selector text/source pointer slot must be non-null
    BEQ.S   .advance_index

    MOVEQ   #1,D4
    BRA.W   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.W   .scan_loop

.scan_done:
    TST.L   D4
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessAltEntryState   (Process alternate entry state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = row index
;   stack +16: D6 = selector value
; RET:
;   D0: state (NEWGRID_AltEntryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_HandleAltGridState, NEWGRID_FindNextEntryWithMarkers,
;   NEWGRID_DrawEmptyGridMessage, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_AltEntryAttemptCounter/2026/2027, CONFIG_NewgridSelectionCode35EnabledFlag
; WRITES:
;   NEWGRID_AltEntryAttemptCounter/2026/2027
; DESC:
;   State machine wrapper around alternate grid entry handling.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_ProcessAltEntryState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVEQ   #5,D0
    CMP.L   NEWGRID_AltEntryWorkflowState,D0
    BNE.S   .legacy_nullctx_reset_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleAltGridState

    LEA     12(A7),A7

.legacy_nullctx_reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVE.L  D0,NEWGRID_AltEntryCursor
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    CMPI.L  #$6,D0
    BCC.W   .clear_workflow_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1_draw_empty-.state_jumptable-2
    DC.W    .clear_workflow_state-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2

.case_state0:
    CLR.L   NEWGRID_AltEntryAttemptCounter
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_AltEntryCursor
    ADDQ.L  #1,D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState

.case_state1_draw_empty:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawEmptyGridMessage

    LEA     12(A7),A7
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    BRA.W   .return_state

.case_state3_or4:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,NEWGRID_AltEntryCursor

.case_state5:
    MOVE.L  NEWGRID_AltEntryCursor,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.S   .clear_workflow_state

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleAltGridState

    LEA     12(A7),A7
    MOVE.B  CONFIG_NewgridSelectionCode35EnabledFlag,D1
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BNE.S   .return_state

    TST.L   D5
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,NEWGRID_AltEntryAttemptCounter
    BGE.S   .update_column_adjust

    PEA     51.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_AltEntryAttemptCounter

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_AltEntryAttemptCounter
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   NEWGRID_AltEntryWorkflowState

.return_state:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FindNextEntryWithAltMarkers   (Find next entry with alt markers)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`, `6=keep start`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
;   stack +18: D5 = preset/column selector offset added into per-entry metadata
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward through primary entries and returns the first row whose entry
;   passes a compound eligibility gate: entry flags, marker-bit test result,
;   per-selector metadata bit test, and non-null row payload pointer.
; NOTES:
;   `NEWGRID_UpdatePresetEntry` materializes two pointers used for validation:
;   one to entry data and one to per-entry selector metadata.
;   The aux pointer is treated as a selector-indexed record where
;   `56 + (selector*4)` stores a text/source pointer required by consumers.
;   Scan ends when count/presence gates fail or when a qualifying entry is found.
;   If no entry matches, returns `-1`.
;   Uses entry fields `A0+46` (flags word) and `A0+40` (marker/status byte).
;------------------------------------------------------------------------------
_NEWGRID_FindNextEntryWithAltMarkers:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_reset

    SUBQ.L  #4,D0
    BEQ.S   .case_increment

    SUBQ.L  #2,D0
    BNE.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D4

.check_loop:
    TST.L   D4
    BNE.W   .return

.scan_loop:
    TST.L   D4
    BNE.W   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .scan_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .scan_done

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -14(A5)
    PEA     -10(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.W  D0,-6(A5)                     ; local cached entry index from NEWGRID_UpdatePresetEntry
    TST.L   -10(A5)                       ; local ptr A: entry record ptr (from NEWGRID_UpdatePresetEntry out0)
    BEQ.S   .advance_index

    TST.L   -14(A5)                       ; local ptr B: entry aux/selector-metadata ptr (from NEWGRID_UpdatePresetEntry out1)
    BEQ.S   .advance_index

    MOVEA.L -10(A5),A0
    MOVE.W  Struct_PrimaryEntry__StateFlagsWord(A0),D0           ; A0+46 = entry state flags word
    BTST    #3,D0
    BEQ.S   .advance_index

    MOVE.B  Struct_PrimaryEntry__MarkerStatusByte(A0),D0         ; A0+40 = entry marker/status byte
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A0),A1      ; A0+28 = marker bitset base used by _ESQ_TestBit1Based
    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .advance_index

    MOVEA.L -14(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata byte offset
    BTST    #7,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flag byte (bit7 blocks candidate)
    BNE.S   .advance_index

    MOVE.W  -6(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A0)       ; A0+56 = selector text/source pointer slot must be non-null
    BEQ.S   .advance_index

    MOVEQ   #1,D4
    BRA.W   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.W   .scan_loop

.scan_done:
    TST.L   D4
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawStatusMessage   (Draw status message banner)
; ARGS:
;   stack +4: A3 = target view/rastport context
;   stack +10: D7 = time/status value formatted into template
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry, _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _PARSEINI_JMPTBL_WDISP_SPrintf,
;   _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength, _LVOMove, _LVOText,
;   _NEWGRID_ValidateSelectionCode
; READS:
;   _GCOMMAND_MplexMessageFramePen, _GCOMMAND_MplexMessageTextPen, _GCOMMAND_MplexAtTemplatePtr, _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Formats and centers a status message within the grid.
; NOTES:
;   Uses _GCOMMAND_MplexAtTemplatePtr as a printf-style format string.
;   This callsite currently performs no local NULL guard on that pointer.
;------------------------------------------------------------------------------
_NEWGRID_DrawStatusMessage:
    LINK.W  A5,#-180
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    PEA     33.W
    MOVE.L  _GCOMMAND_MplexMessageFramePen,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -163(A5)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    PEA     -163(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ; Format string comes from _GCOMMAND_MplexAtTemplatePtr.
    MOVE.L  D0,(A7)
    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,-(A7)
    PEA     -132(A5)
    MOVE.L  D0,-168(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     80(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  _GCOMMAND_MplexMessageTextPen,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     -132(A5),A0
    MOVEA.L A0,A1

.scan_message_end:
    TST.B   (A1)+
    BNE.S   .scan_message_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6

.fit_message_width:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    MOVEQ   #12,D2
    SUB.L   D2,D1
    CMP.L   D1,D0
    BLE.S   .layout_text

    SUBQ.L  #1,D6
    BRA.S   .fit_message_width

.layout_text:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,24(A7)
    MOVE.L  A0,16(A7)
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  20(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_y

    ADDQ.L  #1,D2

.center_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 16(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     66.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    MOVEM.L -196(A5),D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameVariant2   (Draw grid frame variant)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _DISPTEXT_ControlMarkerXOffsetPx, _GCOMMAND_MplexDetailRowPen
; WRITES:
;   52(A3)
; DESC:
;   Draws a grid frame with row separators using an alternate style.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameVariant2:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    MOVE.L  _GCOMMAND_MplexDetailRowPen,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   _NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D3
    MOVEA.L -20(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D6
    MOVEQ   #0,D7
    MOVE.L  D7,D4

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .half_width_round

    ADDQ.L  #1,D0

.half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .half_width_adjust

    ADDQ.L  #1,D0

.half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   .draw_row

.alt_path:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .alt_half_width_round

    ADDQ.L  #1,D1

.alt_half_width_round:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .alt_half_width_adjust

    ADDQ.L  #1,D1

.alt_half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   .draw_row

.default_path:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .default_half_width_round

    ADDQ.L  #1,D0

.default_half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .default_half_width_adjust

    ADDQ.L  #1,D0

.default_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

.draw_row:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BEQ.S   .draw_bottom_bevel

    MOVE.L  D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.draw_bottom_bevel:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   .store_header_width

    ADDQ.L  #1,D0

.store_header_width:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleDetailGridState   (Handle detailed grid state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = entry index
;   stack +18: D6 = selector
; RET:
;   D0: state (NEWGRID_DetailGridStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID_DrawGridEntry,
;   NEWGRID_DrawGridFrameVariant2, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   _GCOMMAND_MplexDetailLayoutPen, _GCOMMAND_MplexDetailLayoutFlag, _GCOMMAND_MplexDetailInitialLineIndex
; WRITES:
;   NEWGRID_DetailGridStateLatch, 32(A3)
; DESC:
;   State machine that formats entry text and redraws the detailed grid view.
; NOTES:
;   Uses NEWGRID_DetailGridStateLatch values 4/5.
;------------------------------------------------------------------------------
_NEWGRID_HandleDetailGridState:
    LINK.W  A5,#-60
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,-8(A5)
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  NEWGRID_DetailGridStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_frame_only

    BRA.W   .force_state4

.state4_begin:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   .return_state

    TST.L   -8(A5)
    BEQ.W   .return_state

    MOVE.L  _GCOMMAND_MplexDetailLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.B  _GCOMMAND_MplexDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_draw:
    MOVE.L  _GCOMMAND_MplexDetailInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    MOVEA.L -4(A5),A0
    MOVEA.L A0,A1
    ADDA.W  #19,A1
    LEA     1(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    PEA     NEWGRID_ChannelRowFmt
    PEA     -58(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     60(A3),A0
    PEA     -58(A5)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant2

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .set_state5_after_draw

    MOVEQ   #4,D0
    BRA.S   .store_state_and_linecount

.set_state5_after_draw:
    MOVEQ   #5,D0

.store_state_and_linecount:
    PEA     2.W
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_frame_only:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant2

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state_and_reset_linecount

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state_and_reset_linecount:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_DetailGridStateLatch

.return_state:
    MOVE.L  NEWGRID_DetailGridStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======