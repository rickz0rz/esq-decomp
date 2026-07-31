    XDEF    _NEWGRID_ProcessGridEntries






;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ProcessGridEntries   (Process grid entries/state)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +18: arg_5 (via 22(A5))
;   stack +20: arg_6 (via 24(A5))
;   stack +22: arg_7 (via 26(A5))
;   stack +26: arg_8 (via 30(A5))
;   stack +30: arg_9 (via 34(A5))
;   stack +34: arg_10 (via 38(A5))
;   stack +38: arg_11 (via 42(A5))
;   stack +42: arg_12 (via 46(A5))
; RET:
;   D0: state (_NEWGRID_GridEntriesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridHeaderRows, _NEWGRID_DrawSelectionMarkers,
;   _NEWGRID_DrawEntryRowOrPlaceholder, _NEWGRID_GetEntryStateCode,
;   _NEWGRID_TestEntryState, _NEWGRID_SelectEntryPen, _NEWGRID_DrawGridCell,
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, _NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths,
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   _NEWGRID_GridOperationId, _NEWGRID_GridEntriesWorkflowState, _TEXTDISP_PrimaryEntryPtrTable/2236, _CLOCK_DaySlotIndex, _NEWGRID_RowHeightPx/232B/232C/232D/232E
; WRITES:
;   _NEWGRID_GridEntriesWorkflowState, _NEWGRID_RowLayoutCommitPenId, _NEWGRID_SelectionMarkerPenState, _NEWGRID_HeaderFramePenId, _NEWGRID_SelectedGridEntryPtr
; DESC:
;   Main grid loop that builds row state, selects pens, and draws rows/markers.
; NOTES:
;   Uses multiple scratch slots on the stack and a row loop (0..2).
;------------------------------------------------------------------------------
_NEWGRID_ProcessGridEntries:
    LINK.W  A5,#-48
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #-1,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-46(A5)
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  _NEWGRID_GridEntriesWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BNE.W   .force_state_4

.state5_redraw:
    MOVE.L  _NEWGRID_SelectionMarkerPenState,-(A7)
    MOVE.L  _NEWGRID_HeaderFramePenId,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridHeaderRows

    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState
    BRA.W   .return_state

.state4_begin:
    MOVEQ   #44,D0
    CMP.W   D0,D6
    BGT.S   .select_entry_ptr

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BEQ.S   .select_entry_ptr

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .no_entry_ptr

.select_entry_ptr:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    BRA.S   .load_entry_ptr

.no_entry_ptr:
    MOVEQ   #-1,D5

.load_entry_ptr:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _NEWGRID_SelectEntryPen

    ADDQ.W  #4,A7
    MOVE.L  D0,_NEWGRID_SelectedGridEntryPtr
    MOVEQ   #5,D0
    CMP.L   _NEWGRID_GridOperationId,D0
    BNE.S   .set_header_pen

    MOVE.L  _GCOMMAND_NicheFramePen,_NEWGRID_HeaderFramePenId
    BRA.S   .draw_header_frame

.set_header_pen:
    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_HeaderFramePenId

.draw_header_frame:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_SelectedGridEntryPtr,-(A7)
    MOVE.L  _NEWGRID_HeaderFramePenId,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    LEA     20(A7),A7
    CLR.W   -18(A5)

.row_loop:
    MOVE.W  -18(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BGE.W   .row_loop_done

    SUBA.L  A0,A0
    CLR.W   -22(A5)
    MOVEQ   #0,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVE.L  D6,D3
    EXT.L   D3
    EXT.L   D0
    ADD.L   D0,D3
    MOVE.L  D1,-34(A5)
    MOVE.L  D1,-38(A5)
    MOVE.L  D2,_NEWGRID_SelectionMarkerPenState
    MOVE.L  D2,_NEWGRID_RowLayoutCommitPenId
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-4(A5)
    MOVEQ   #48,D0
    CMP.L   D0,D3
    BGT.S   .use_second_key

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BEQ.S   .use_second_key

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .use_first_key

.use_second_key:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    ADD.L   D2,D1
    MOVE.L  D0,-12(A5)
    MOVEQ   #48,D0
    CMP.L   D0,D1
    BLE.S   .index_in_range

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    ADD.L   D2,D1
    SUB.L   D0,D1
    BRA.S   .index_wrapped

.index_in_range:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  -18(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D1

.index_wrapped:
    MOVE.W  D1,-24(A5)
    MOVE.W  D1,-20(A5)
    ADDI.W  #$30,D1
    MOVE.W  D1,-26(A5)
    BRA.S   .row_has_entries

.use_first_key:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D1
    MOVE.W  -18(A5),D2
    ADD.W   D2,D1
    MOVE.L  D0,-12(A5)
    MOVE.W  D1,-26(A5)
    MOVE.W  D1,-24(A5)
    MOVE.W  D1,-20(A5)

.row_has_entries:
    TST.L   -4(A5)
    BEQ.W   .row_missing_entry

    TST.L   -12(A5)
    BEQ.W   .row_missing_entry

    TST.W   -18(A5)
    BNE.S   .capture_first_entry

    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)

.capture_first_entry:
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _NEWGRID_GetEntryStateCode

    LEA     12(A7),A7
    MOVE.W  #1,-22(A5)
    MOVE.L  D0,-30(A5)

.scan_next_entry:
    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BGE.S   .scan_done

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   _NEWGRID_TestEntryState

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .scan_done

    ADDQ.W  #1,-22(A5)
    BRA.S   .scan_next_entry

.scan_done:
    MOVEQ   #3,D0
    CMP.L   -30(A5),D0
    BNE.S   .post_state_adjust

    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.W  D0,-20(A5)
    BNE.S   .set_state_alt

    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    BRA.S   .post_state_adjust

.set_state_alt:
    MOVEQ   #2,D1
    MOVE.L  D1,-30(A5)

.post_state_adjust:
    MOVEQ   #2,D0
    CMP.L   -30(A5),D0
    BNE.W   .draw_simple_cell

    TST.W   -18(A5)
    BNE.W   .check_trailing_pair

    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.W  -20(A5),D2
    EXT.L   D2
    SUB.L   D2,D1
    MOVEQ   #1,D2
    CMP.L   D2,D1
    BLE.S   .resolve_state_delta

    MOVE.L  D0,-34(A5)
    BRA.W   .check_trailing_pair

.resolve_state_delta:
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.W  -20(A5),D1
    EXT.L   D1
    SUB.L   D1,D0
    SUBQ.L  #1,D0
    BNE.S   .check_edge_case

    MOVE.L  D2,-34(A5)
    BRA.S   .check_trailing_pair

.check_edge_case:
    MOVEQ   #1,D0
    CMP.W   -24(A5),D0
    BNE.S   .check_special_case

    MOVEA.L -12(A5),A0
    BTST    #7,8(A0)
    BEQ.S   .check_special_case

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A1
    ADDA.L  D0,A1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A2
    ADDA.L  D0,A2
    PEA     48.W
    MOVE.L  (A2),-(A7)
    MOVE.L  (A1),-(A7)
    BSR.W   _NEWGRID_GetEntryStateCode

    LEA     12(A7),A7
    SUBQ.L  #2,D0
    BEQ.S   .set_state_from_flags

    MOVEQ   #2,D0
    MOVE.L  D0,-34(A5)
    BRA.S   .check_trailing_pair

.set_state_from_flags:
    MOVEQ   #1,D0
    MOVE.L  D0,-34(A5)
    BRA.S   .check_trailing_pair

.check_special_case:
    MOVEQ   #2,D0
    CMP.W   -24(A5),D0
    BNE.S   .check_trailing_pair

    MOVEQ   #1,D0
    CMP.W   -20(A5),D0
    BNE.S   .check_trailing_pair

    MOVEA.L -12(A5),A0
    BTST    #7,8(A0)
    BNE.S   .set_state_alt2

    MOVE.L  D2,-34(A5)
    BRA.S   .check_trailing_pair

.set_state_alt2:
    MOVEQ   #2,D0
    MOVE.L  D0,-34(A5)

.check_trailing_pair:
    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    SUBQ.L  #3,D0
    BNE.S   .update_colors

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   _NEWGRID_TestEntryState

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .update_colors

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    ADDQ.W  #1,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   _NEWGRID_TestEntryState

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .set_pair_state

    MOVEQ   #2,D0
    MOVE.L  D0,-38(A5)
    BRA.S   .update_colors

.set_pair_state:
    MOVEQ   #1,D0
    MOVE.L  D0,-38(A5)

.update_colors:
    MOVE.L  _NEWGRID_OverridePenIndex,D0
    MOVE.L  D0,_NEWGRID_RowLayoutCommitPenId
    MOVEA.L -12(A5),A0
    MOVE.W  -20(A5),D0
    BTST    #2,7(A0,D0.W)
    BEQ.S   .set_default_color

    MOVEQ   #5,D0
    MOVE.L  D0,_NEWGRID_SelectionMarkerPenState
    BRA.S   .compute_cell_height

.set_default_color:
    MOVE.L  #$ff,_NEWGRID_SelectionMarkerPenState

.compute_cell_height:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BNE.S   .cell_height_default

    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D1
    MOVEQ   #89,D2
    CMP.B   D2,D1
    BNE.S   .cell_height_default

    MOVEQ   #20,D1
    BRA.S   .draw_cell

.cell_height_default:
    MOVEQ   #2,D1

.draw_cell:
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  _NEWGRID_RowLayoutCommitPenId,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-42(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    MOVE.L  -38(A5),(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawEntryRowOrPlaceholder

    LEA     40(A7),A7
    BRA.W   .maybe_draw_markers

.draw_simple_cell:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BGE.S   .clear_row_flag

    MOVEQ   #1,D1
    MOVE.L  #$ff,_NEWGRID_SelectionMarkerPenState
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  D1,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D1,_NEWGRID_RowLayoutCommitPenId
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawEntryRowOrPlaceholder

    LEA     32(A7),A7
    BRA.S   .maybe_draw_markers

.clear_row_flag:
    CLR.L   -46(A5)
    BRA.S   .maybe_draw_markers

.row_missing_entry:
    MOVEQ   #3,D0
    MOVE.L  D0,D1
    SUB.W   -18(A5),D1
    MOVEM.W D1,-22(A5)
    CMP.W   D0,D1
    BGE.S   .row_missing_done

    MOVEQ   #1,D0
    MOVE.L  #$ff,_NEWGRID_SelectionMarkerPenState
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MULU    D1,D2
    MOVEQ   #12,D1
    SUB.L   D1,D2
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D0,_NEWGRID_RowLayoutCommitPenId
    MOVE.L  D0,-30(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawEntryRowOrPlaceholder

    LEA     32(A7),A7
    BRA.S   .maybe_draw_markers

.row_missing_done:
    MOVEQ   #0,D0
    MOVE.L  D0,-46(A5)

.maybe_draw_markers:
    TST.L   -46(A5)
    BEQ.S   .advance_row

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  _NEWGRID_SelectionMarkerPenState,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawSelectionMarkers

    LEA     24(A7),A7

.advance_row:
    MOVE.W  -22(A5),D0
    ADD.W   D0,-18(A5)
    BRA.W   .row_loop

.row_loop_done:
    TST.L   -46(A5)
    BEQ.W   .no_rows

    MOVEQ   #3,D0
    CMP.W   -22(A5),D0
    BNE.S   .draw_empty_cell

    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_empty_cell

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.S   .draw_empty_cell

    LEA     60(A3),A0
    CLR.L   -(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridCell

    LEA     12(A7),A7
    MOVEQ   #5,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   _NEWGRID_SelectionMarkerPenState,D0
    BNE.S   .store_frame_state

    MOVE.L  _NEWGRID_SelectedGridEntryPtr,_NEWGRID_SelectionMarkerPenState
    BRA.S   .store_frame_state

.draw_empty_cell:
    LEA     60(A3),A0
    PEA     1.W
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridCell

    LEA     12(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState

.store_frame_state:
    MOVE.W  _NEWGRID_RowHeightPx,D0
    LSR.W   #1,D0
    MOVE.W  D0,52(A3)
    PEA     2.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.no_rows:
    CLR.W   52(A3)
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState
    BRA.S   .return_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEntriesWorkflowState

.return_state:
    MOVE.L  _NEWGRID_GridEntriesWorkflowState,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======