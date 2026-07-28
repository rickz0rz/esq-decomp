    XDEF    NEWGRID_DrawGridFrameVariant3
    XDEF    NEWGRID_DrawGridMessageAlt
    XDEF    NEWGRID_UpdateSelectionFromInput


;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateSelectionFromInput   (Advance primary selection scan and resolve next match)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: selection found flag (0/1)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_ClearEntryMarkerBits, _NEWGRID_InitSelectionWindow, NEWGRID_UpdatePresetEntry,
;   NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID_ShouldOpenEditor, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState
; READS:
;   NEWGRID_SelectionScanEntryIndex/2031, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag, _GCOMMAND_PpvSelectionWindowMinutes
; WRITES:
;   NEWGRID_SelectionScanEntryIndex/2031, selection state fields
; DESC:
;   Advances selection state and scans entries for the next matching row.
; NOTES:
;   Uses D6 as a found/stop flag during the scan.
;------------------------------------------------------------------------------
NEWGRID_UpdateSelectionFromInput:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .state0_init

    SUBQ.L  #4,D0
    BEQ.S   .state4_advance

    BRA.S   .state_unhandled_sets_stopflag

.state0_init:
    MOVE.L  12(A3),NEWGRID_SelectionScanEntryIndex
    MOVE.W  22(A3),D0
    MOVE.W  D0,NEWGRID_SelectionScanRow
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7
    BRA.S   .post_state

.state4_advance:
    ADDQ.L  #1,NEWGRID_SelectionScanEntryIndex
    BRA.S   .post_state

.state_unhandled_sets_stopflag:
    MOVEQ   #1,D6

.post_state:
    TST.L   D6
    BNE.W   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  12(A3),D1
    CMP.L   D0,D1
    BGT.S   .clamp_start_index

    TST.L   D1
    BPL.S   .clamp_start_done

.clamp_start_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,12(A3)

.clamp_start_done:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  16(A3),D1
    CMP.L   D0,D1
    BGT.S   .clamp_end_index

    TST.L   D1
    BPL.S   .clamp_end_done

.clamp_end_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,16(A3)

.clamp_end_done:
    TST.L   D6
    BNE.W   .finalize_selection

    MOVE.W  NEWGRID_SelectionScanRow,D0
    TST.W   D0
    BLE.W   .finalize_selection

    CMP.W   24(A3),D0
    BGE.W   .finalize_selection

.scan_entry_loop:
    TST.L   D6
    BNE.W   .advance_row

    MOVE.L  NEWGRID_SelectionScanEntryIndex,D0
    CMP.L   16(A3),D0
    BGE.W   .advance_row

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .advance_row

    MOVE.W  NEWGRID_SelectionScanRow,D1
    EXT.L   D1
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   .scan_entry_next

    TST.L   -8(A5)
    BEQ.W   .scan_entry_next

    MOVEA.L -4(A5),A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.W   .scan_entry_next

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.W   .scan_entry_next

    MOVE.W  NEWGRID_SelectionScanRow,D0
    CMP.W   22(A3),D0
    BNE.S   .entry_time_adjust

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

.entry_time_adjust:
    TST.W   D5
    BLE.W   .scan_entry_next

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .scan_entry_next

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #5,7(A1)
    BNE.W   .scan_entry_next

    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .check_alt_match

    MOVE.W  NEWGRID_SelectionScanRow,D0
    MOVE.W  22(A3),D1
    CMP.W   D0,D1
    BNE.S   .check_alt_entry

    MOVE.L  D5,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.L   56(A1)
    BEQ.S   .check_alt_entry

    MOVEQ   #1,D1
    BRA.S   .store_alt_entry

.check_alt_entry:
    MOVEQ   #0,D1

.store_alt_entry:
    MOVE.L  D1,D6
    BRA.S   .scan_entry_next

.check_alt_match:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   .alt_match_result

    MOVEA.L -8(A5),A0
    ADDA.W  NEWGRID_SelectionScanRow,A0
    BTST    #7,7(A0)
    BNE.S   .alt_match_result

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  _GCOMMAND_PpvSelectionToleranceMinutes,-(A7)
    MOVE.L  _GCOMMAND_PpvSelectionWindowMinutes,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .alt_match_result

    MOVEQ   #1,D1
    BRA.S   .store_match_result

.alt_match_result:
    MOVEQ   #0,D1

.store_match_result:
    MOVE.L  D1,D6

.scan_entry_next:
    TST.L   D6
    BNE.W   .scan_entry_loop

    ADDQ.L  #1,NEWGRID_SelectionScanEntryIndex
    BRA.W   .scan_entry_loop

.advance_row:
    TST.L   D6
    BNE.W   .clamp_end_done

    ADDQ.W  #1,NEWGRID_SelectionScanRow
    MOVE.L  12(A3),NEWGRID_SelectionScanEntryIndex
    BRA.W   .clamp_end_done

.finalize_selection:
    TST.L   D6
    BEQ.S   .reset_selection

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  NEWGRID_SelectionScanEntryIndex,8(A3)
    CMPI.W  #'0',NEWGRID_SelectionScanRow
    BLE.S   .set_offset_flag

    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.S   .set_offset_flag

    MOVEQ   #48,D0
    BRA.S   .apply_offset

.set_offset_flag:
    MOVEQ   #0,D0

.apply_offset:
    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,20(A3)
    MOVEA.L -8(A5),A0
    ADDA.W  D5,A0
    BSET    #5,7(A0)
    BRA.S   .return

.reset_selection:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_InitSelectionWindow

    ADDQ.W  #8,A7

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridMessageAlt   (Draw alternate grid message)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, _NEWGRID_ValidateSelectionCode
; READS:
;   _GCOMMAND_PpvMessageTextPen, _GCOMMAND_PpvMessageFramePen, _GCOMMAND_PPVPeriodTemplatePtr, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Centers a fixed message string inside the grid frame.
; NOTES:
;   Reads message text directly from _GCOMMAND_PPVPeriodTemplatePtr.
;   This routine currently assumes that pointer is non-NULL.
;------------------------------------------------------------------------------
NEWGRID_DrawGridMessageAlt:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    PEA     33.W
    MOVE.L  _GCOMMAND_PpvMessageFramePen,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

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

    LEA     60(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  _GCOMMAND_PpvMessageTextPen,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    ; Source message pointer: expected to be valid/NUL-terminated.
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0

.scan_message_end:
    TST.B   (A0)+
    BNE.S   .scan_message_end

    SUBQ.L  #1,A0
    SUBA.L  _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVE.L  A0,D7

.fit_message_width:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    MOVEQ   #12,D2
    SUB.L   D2,D1
    CMP.L   D1,D0
    BLE.S   .layout_text

    SUBQ.L  #1,D7
    BRA.S   .fit_message_width

.layout_text:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,16(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A0,12(A7)
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  20(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  16(A7),D0
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
    MOVEA.L 12(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     68.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    MOVEM.L -24(A5),D2/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameVariant3   (Draw grid frame variant)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _DISPTEXT_ControlMarkerXOffsetPx, _GCOMMAND_PpvShowtimesRowPen
; WRITES:
;   52(A3)
; DESC:
;   Draws a grid frame with row separators using an alternate palette.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameVariant3:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    MOVE.L  _GCOMMAND_PpvShowtimesRowPen,-(A7)
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
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

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
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

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
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

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
