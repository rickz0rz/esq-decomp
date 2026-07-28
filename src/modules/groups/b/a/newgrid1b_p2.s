    XDEF    NEWGRID_DrawEmptyGridMessage
    XDEF    NEWGRID_DrawGridFrameAlt
    XDEF    NEWGRID_DrawGridFrameVariant2
    XDEF    _NEWGRID_DrawStatusMessage
    XDEF    _NEWGRID_FindNextEntryWithAltMarkers
    XDEF    NEWGRID_FindNextEntryWithFlags
    XDEF    NEWGRID_FindNextEntryWithMarkers
    XDEF    NEWGRID_FindNextFlaggedEntry
    XDEF    NEWGRID_HandleAltGridState
    XDEF    _NEWGRID_HandleDetailGridState
    XDEF    _NEWGRID_HandleGridEditorState
    XDEF    NEWGRID_HandleGridSelection
    XDEF    NEWGRID_ProcessAltEntryState
    XDEF    NEWGRID_ProcessGridEntries
    XDEF    NEWGRID_ProcessSecondaryState




;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessGridEntries   (Process grid entries/state)
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
;   D0: state (NEWGRID_GridEntriesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridHeaderRows, NEWGRID_DrawSelectionMarkers,
;   NEWGRID_DrawEntryRowOrPlaceholder, NEWGRID_GetEntryStateCode,
;   NEWGRID_TestEntryState, _NEWGRID_SelectEntryPen, NEWGRID_DrawGridCell,
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths,
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   _NEWGRID_GridOperationId, NEWGRID_GridEntriesWorkflowState, _TEXTDISP_PrimaryEntryPtrTable/2236, _CLOCK_DaySlotIndex, _NEWGRID_RowHeightPx/232B/232C/232D/232E
; WRITES:
;   NEWGRID_GridEntriesWorkflowState, NEWGRID_RowLayoutCommitPenId, NEWGRID_SelectionMarkerPenState, NEWGRID_HeaderFramePenId, NEWGRID_SelectedGridEntryPtr
; DESC:
;   Main grid loop that builds row state, selects pens, and draws rows/markers.
; NOTES:
;   Uses multiple scratch slots on the stack and a row loop (0..2).
;------------------------------------------------------------------------------
NEWGRID_ProcessGridEntries:
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
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  NEWGRID_GridEntriesWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BNE.W   .force_state_4

.state5_redraw:
    MOVE.L  NEWGRID_SelectionMarkerPenState,-(A7)
    MOVE.L  NEWGRID_HeaderFramePenId,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridHeaderRows

    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState
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
    MOVE.L  D0,NEWGRID_SelectedGridEntryPtr
    MOVEQ   #5,D0
    CMP.L   _NEWGRID_GridOperationId,D0
    BNE.S   .set_header_pen

    MOVE.L  _GCOMMAND_NicheFramePen,NEWGRID_HeaderFramePenId
    BRA.S   .draw_header_frame

.set_header_pen:
    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_HeaderFramePenId

.draw_header_frame:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SelectedGridEntryPtr,-(A7)
    MOVE.L  NEWGRID_HeaderFramePenId,-(A7)
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
    MOVE.L  D2,NEWGRID_SelectionMarkerPenState
    MOVE.L  D2,NEWGRID_RowLayoutCommitPenId
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
    BSR.W   NEWGRID_GetEntryStateCode

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
    BSR.W   NEWGRID_TestEntryState

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
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

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
    BSR.W   NEWGRID_GetEntryStateCode

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
    BSR.W   NEWGRID_TestEntryState

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
    BSR.W   NEWGRID_TestEntryState

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
    MOVE.L  D0,NEWGRID_RowLayoutCommitPenId
    MOVEA.L -12(A5),A0
    MOVE.W  -20(A5),D0
    BTST    #2,7(A0,D0.W)
    BEQ.S   .set_default_color

    MOVEQ   #5,D0
    MOVE.L  D0,NEWGRID_SelectionMarkerPenState
    BRA.S   .compute_cell_height

.set_default_color:
    MOVE.L  #$ff,NEWGRID_SelectionMarkerPenState

.compute_cell_height:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BNE.S   .cell_height_default

    MOVE.B  CONFIG_NewgridPlaceholderBevelFlag,D1
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
    MOVE.L  NEWGRID_RowLayoutCommitPenId,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-42(A5)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    MOVE.L  -38(A5),(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths(PC)

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
    BSR.W   NEWGRID_DrawEntryRowOrPlaceholder

    LEA     40(A7),A7
    BRA.W   .maybe_draw_markers

.draw_simple_cell:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BGE.S   .clear_row_flag

    MOVEQ   #1,D1
    MOVE.L  #$ff,NEWGRID_SelectionMarkerPenState
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  D1,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D1,NEWGRID_RowLayoutCommitPenId
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
    BSR.W   NEWGRID_DrawEntryRowOrPlaceholder

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
    MOVE.L  #$ff,NEWGRID_SelectionMarkerPenState
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MULU    D1,D2
    MOVEQ   #12,D1
    SUB.L   D1,D2
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D0,NEWGRID_RowLayoutCommitPenId
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
    BSR.W   NEWGRID_DrawEntryRowOrPlaceholder

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
    MOVE.L  NEWGRID_SelectionMarkerPenState,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawSelectionMarkers

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

    MOVE.B  CONFIG_NewgridPlaceholderBevelFlag,D0
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
    BSR.W   NEWGRID_DrawGridCell

    LEA     12(A7),A7
    MOVEQ   #5,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   NEWGRID_SelectionMarkerPenState,D0
    BNE.S   .store_frame_state

    MOVE.L  NEWGRID_SelectedGridEntryPtr,NEWGRID_SelectionMarkerPenState
    BRA.S   .store_frame_state

.draw_empty_cell:
    LEA     60(A3),A0
    PEA     1.W
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridCell

    LEA     12(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState

.store_frame_state:
    MOVE.W  _NEWGRID_RowHeightPx,D0
    LSR.W   #1,D0
    MOVE.W  D0,52(A3)
    PEA     2.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.no_rows:
    CLR.W   52(A3)
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState
    BRA.S   .return_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState

.return_state:
    MOVE.L  NEWGRID_GridEntriesWorkflowState,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextFlaggedEntry   (Find next entry with flags)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = start index
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_PrimaryGroupEntryCount
; DESC:
;   Scans forward for an entry with matching flag bits when enabled.
; NOTES:
;   Returns -1 if no matching entry is found.
;------------------------------------------------------------------------------
NEWGRID_FindNextFlaggedEntry:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    SUBQ.L  #3,D0
    BEQ.S   .case_reset

    SUBQ.L  #1,D0
    BEQ.S   .case_increment

    BRA.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D5

.check_loop:
    TST.L   D5
    BNE.S   .return

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .return

.scan_loop:
    TST.L   D5
    BNE.S   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .advance_index

    MOVEA.L D0,A0
    BTST    #0,47(A0)
    BEQ.S   .advance_index

    BTST    #7,40(A0)
    BEQ.S   .advance_index

    MOVEQ   #1,D5
    BRA.S   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.S   .scan_loop

.scan_done:
    TST.L   D5
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleGridSelection   (Handle selection state transitions)
; ARGS:
;   (none observed)
; RET:
;   D0: selection state (NEWGRID_GridSelectionWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_UpdateGridState, NEWGRID_ProcessGridEntries, NEWGRID_FindNextFlaggedEntry,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ValidateSelectionCode, _NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_GridSelectionColumnAdjust, NEWGRID_GridSelectionEntryIndex, NEWGRID_GridSelectionWorkflowState, CONFIG_NewgridSelectionCode32EnabledFlag, CONFIG_NewgridSelectionCode48_49EnabledFlag
; WRITES:
;   NEWGRID_GridSelectionColumnAdjust, NEWGRID_GridSelectionEntryIndex, NEWGRID_GridSelectionWorkflowState
; DESC:
;   Advances selection state and triggers grid redraw/update actions.
;------------------------------------------------------------------------------
NEWGRID_HandleGridSelection:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVEQ   #5,D0
    CMP.L   NEWGRID_GridSelectionWorkflowState,D0
    BNE.S   .reset_workflow_state

    MOVE.L  NEWGRID_GridSelectionEntryIndex,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .process_entries

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .reset_workflow_state

.process_entries:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.reset_workflow_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState
    MOVE.L  D0,NEWGRID_GridSelectionEntryIndex
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  NEWGRID_GridSelectionWorkflowState,D0
    TST.L   D0
    BEQ.S   .state0_init

    SUBQ.L  #3,D0
    BEQ.S   .state3or4_find_next

    SUBQ.L  #1,D0
    BEQ.S   .state3or4_find_next

    SUBQ.L  #1,D0
    BEQ.S   .state5_process_entry

    BRA.W   .clear_workflow_state

.state0_init:
    CLR.L   NEWGRID_GridSelectionColumnAdjust
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState

.state3or4_find_next:
    MOVE.L  NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  NEWGRID_GridSelectionWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextFlaggedEntry

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,NEWGRID_GridSelectionEntryIndex

.state5_process_entry:
    MOVE.L  NEWGRID_GridSelectionEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .clear_workflow_state

    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_process_entries

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState
    BRA.S   .post_process

.state5_process_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState
    TST.L   D6
    BEQ.S   .post_process

    CMPI.L  #$1,NEWGRID_GridSelectionColumnAdjust
    BGE.S   .post_process

    SUBQ.L  #5,D0
    BNE.S   .post_process

    MOVE.B  CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .post_process

    PEA     48.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_GridSelectionColumnAdjust

.post_process:
    MOVE.B  CONFIG_NewgridSelectionCode32EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_column_adjust

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,NEWGRID_GridSelectionColumnAdjust
    BGE.S   .update_column_adjust

    PEA     32.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_GridSelectionColumnAdjust

.update_column_adjust:
    MOVE.L  NEWGRID_GridSelectionColumnAdjust,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_GridSelectionColumnAdjust
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   NEWGRID_GridSelectionWorkflowState

.return_state:
    MOVE.L  NEWGRID_GridSelectionWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleGridEditorState   (Handle editor state transitions)
; ARGS:
;   stack +4: A3 = target view/rastport context
;   stack +8: D7 = layout pen/config value
;   stack +12: D6 = row pen/config value
;   stack +16: A2 = source text/template pointer
; RET:
;   D0: state (NEWGRID_GridEditorWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridFrameAndRows, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   NEWGRID_GridEditorWorkflowState
; WRITES:
;   NEWGRID_GridEditorWorkflowState, 32(A3)
; DESC:
;   Drives a small state machine for editor-related redraw paths.
; NOTES:
;   For state 4, source text (A2) is forwarded to
;   _DISPTEXT_LayoutAndAppendToBuffer, which tolerates NULL/empty strings.
;------------------------------------------------------------------------------
_NEWGRID_HandleGridEditorState:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVEA.L 32(A7),A2
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state_dispatch_check:
    MOVE.L  NEWGRID_GridEditorWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_draw

    SUBQ.L  #1,D0
    BEQ.S   .state5_frame_only

    BRA.S   .force_state4

.state4_draw:
    MOVE.L  D7,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    ; A2 may be NULL; downstream layout helper performs NULL/empty checks.
    MOVE.L  A2,(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    CLR.L   (A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  D6,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .state4_set_state5

    MOVEQ   #4,D0
    BRA.S   .state4_store_state

.state4_set_state5:
    MOVEQ   #5,D0

.state4_store_state:
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state5_frame_only:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state:
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState

.return_state:
    MOVE.L  NEWGRID_GridEditorWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextEntryWithFlags   (Find entry with bit2/bit7 set)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans primary entries and returns the first entry index whose direct entry
;   flags satisfy both bit tests used by the secondary workflow prefilter.
;   Returns `-1` when no eligible entry exists.
; NOTES:
;   This helper does not inspect selector metadata tables; it only evaluates
;   the fetched entry record itself.
;------------------------------------------------------------------------------
NEWGRID_FindNextEntryWithFlags:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
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
    MOVEQ   #1,D5

.check_loop:
    TST.L   D5
    BNE.S   .return

.scan_loop:
    TST.L   D5
    BNE.S   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .advance_index

    MOVEA.L D0,A0
    BTST    #2,47(A0)                     ; A0+47 = entry flags byte (bit2 required)
    BEQ.S   .advance_index

    BTST    #7,40(A0)                     ; A0+40 = entry marker/status byte (bit7 required)
    BEQ.S   .advance_index

    MOVEQ   #1,D5
    BRA.S   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.S   .scan_loop

.scan_done:
    TST.L   D5
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessSecondaryState   (Process alternate state machine)
; ARGS:
;   (none observed)
; RET:
;   D0: state (NEWGRID_SecondaryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleGridEditorState, _NEWGRID_UpdateGridState,
;   NEWGRID_ProcessGridEntries, NEWGRID_FindNextEntryWithFlags,
;   _NEWGRID_ValidateSelectionCode, _NEWGRID_GetGridModeIndex,
;   _NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_SecondarySelectedEntryIndex/2022/2023, _GCOMMAND_DigitalNicheEnabledFlag/_GCOMMAND_NicheEditorLayoutPen/_GCOMMAND_NicheEditorRowPen/_GCOMMAND_NicheWorkflowMode/_GCOMMAND_DigitalNicheListingsTemplatePtr, CONFIG_NewgridSelectionCode48_49EnabledFlag
; WRITES:
;   NEWGRID_SecondarySelectedEntryIndex/2022/2023
; DESC:
;   Drives a secondary state machine for a different grid display path.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_ProcessSecondaryState:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVE.L  NEWGRID_SecondaryWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .legacy_nullctx_editor_reset

    SUBQ.L  #3,D0
    BEQ.S   .legacy_nullctx_route_by_editor_gate

    SUBQ.L  #2,D0
    BNE.S   .legacy_nullctx_clear_selection_and_state

.legacy_nullctx_editor_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    BRA.S   .legacy_nullctx_clear_selection_and_state

.legacy_nullctx_route_by_editor_gate:
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .legacy_nullctx_run_grid_entries

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .legacy_nullctx_clear_selection_and_state

.legacy_nullctx_run_grid_entries:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.legacy_nullctx_clear_selection_and_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    MOVE.L  D0,NEWGRID_SecondarySelectedEntryIndex
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  NEWGRID_SecondaryWorkflowState,D0
    CMPI.L  #$8,D0
    BCC.W   .return_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .return_state-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3-.state_jumptable-2
    DC.W    .case_state3-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2
    DC.W    .return_state-.state_jumptable-2
    DC.W    .case_state7-.state_jumptable-2

.case_state0:
    CLR.L   NEWGRID_SecondarySelectionHintCounter
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  NEWGRID_SecondaryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithFlags

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_SecondarySelectedEntryIndex
    ADDQ.L  #1,D0
    BEQ.W   .return_state

    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState

.case_state2:
    MOVE.B  _GCOMMAND_NicheWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case_state2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case_state2_force_state3

.case_state2_handle:
    MOVE.L  _GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_NicheEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_NicheEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state2_done

    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    BRA.W   .return_state

.case_state2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    BRA.W   .return_state

.case_state2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState

.case_state3:
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  NEWGRID_SecondaryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithFlags

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,NEWGRID_SecondarySelectedEntryIndex

.case_state5:
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .case_state5_no_entry

    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case_state5_process_entries

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    BRA.S   .case_state5_post

.case_state5_process_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    TST.L   D6
    BEQ.S   .case_state5_post

    CMPI.L  #$1,NEWGRID_SecondarySelectionHintCounter
    BGE.S   .case_state5_post

    SUBQ.L  #5,D0
    BNE.S   .case_state5_post

    MOVE.B  CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .case_state5_post

    PEA     49.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_SecondarySelectionHintCounter

.case_state5_post:
    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_column_adjust

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,NEWGRID_SecondarySelectionHintCounter
    BGE.S   .update_column_adjust

    PEA     33.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_SecondarySelectionHintCounter

.update_column_adjust:
    MOVE.L  NEWGRID_SecondarySelectionHintCounter,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_SecondarySelectionHintCounter
    BRA.S   .return_state

.case_state5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState

.case_state7:
    MOVE.B  _GCOMMAND_NicheWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case_state7_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_state7_clear_state

.case_state7_handle:
    MOVE.L  _GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_NicheEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_NicheEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state7_done

    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    BRA.S   .return_state

.case_state7_done:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    BRA.S   .return_state

.case_state7_clear_state:
    CLR.L   NEWGRID_SecondaryWorkflowState

.return_state:
    MOVE.L  NEWGRID_SecondaryWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

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
;   eligibility gate than `NEWGRID_FindNextEntryWithFlags`: entry flag bits,
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