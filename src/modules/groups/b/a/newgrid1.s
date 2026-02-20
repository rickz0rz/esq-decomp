    XDEF    NEWGRID_AddShowtimeBucketEntry
    XDEF    NEWGRID_AppendShowtimeBuckets
    XDEF    NEWGRID_AppendShowtimesForRow
    XDEF    NEWGRID_Apply24HourFormatting
    XDEF    NEWGRID_BuildShowtimesText
    XDEF    NEWGRID_ClearEntryMarkerBits
    XDEF    NEWGRID_ClearMarkersIfSelectable
    XDEF    NEWGRID_ComputeColumnIndex
    XDEF    NEWGRID_DrawEmptyGridMessage
    XDEF    NEWGRID_DrawEntryFlagBadge
    XDEF    NEWGRID_DrawEntryRowOrPlaceholder
    XDEF    NEWGRID_DrawGridCell
    XDEF    NEWGRID_DrawGridCellBackground
    XDEF    NEWGRID_DrawGridCellText
    XDEF    NEWGRID_DrawGridEntry
    XDEF    NEWGRID_DrawGridFrameAlt
    XDEF    NEWGRID_DrawGridFrameAndRows
    XDEF    NEWGRID_DrawGridFrameVariant2
    XDEF    NEWGRID_DrawGridFrameVariant3
    XDEF    NEWGRID_DrawGridFrameVariant4
    XDEF    NEWGRID_DrawGridHeaderRows
    XDEF    NEWGRID_DrawGridMessageAlt
    XDEF    NEWGRID_DrawSelectionMarkers
    XDEF    NEWGRID_DrawShowtimesPrompt
    XDEF    NEWGRID_DrawStatusMessage
    XDEF    NEWGRID_FindNextEntryWithAltMarkers
    XDEF    NEWGRID_FindNextEntryWithFlags
    XDEF    NEWGRID_FindNextEntryWithMarkers
    XDEF    NEWGRID_FindNextFlaggedEntry
    XDEF    NEWGRID_GetEntryStateCode
    XDEF    NEWGRID_GetGridModeIndex
    XDEF    NEWGRID_HandleAltGridState
    XDEF    NEWGRID_HandleDetailGridState
    XDEF    NEWGRID_HandleGridEditorState
    XDEF    NEWGRID_HandleGridSelection
    XDEF    NEWGRID_HandleShowtimesState
    XDEF    NEWGRID_InitSelectionWindow
    XDEF    NEWGRID_InitSelectionWindowAlt
    XDEF    NEWGRID_InitShowtimeBuckets
    XDEF    NEWGRID_ProcessAltEntryState
    XDEF    NEWGRID_ProcessGridEntries
    XDEF    NEWGRID_ProcessScheduleState
    XDEF    NEWGRID_ProcessSecondaryState
    XDEF    NEWGRID_ProcessShowtimesWorkflow
    XDEF    NEWGRID_RebuildIndexCache
    XDEF    NEWGRID_ResetRowTable
    XDEF    NEWGRID_ResetShowtimeBuckets
    XDEF    NEWGRID_SelectEntryPen
    XDEF    NEWGRID_SetRowColor
    XDEF    NEWGRID_SetSelectionMarkers
    XDEF    NEWGRID_TestEntrySelectable
    XDEF    NEWGRID_TestEntryState
    XDEF    NEWGRID_TestModeFlagActive
    XDEF    NEWGRID_TestPrimeTimeWindow
    XDEF    NEWGRID_UpdateGridState
    XDEF    NEWGRID_UpdatePresetEntry
    XDEF    NEWGRID_UpdateSelectionFromInput
    XDEF    NEWGRID_UpdateSelectionFromInputAlt
    XDEF    NEWGRID_ValidateSelectionCode

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ResetRowTable   (Initialize row indices and slots)
; ARGS:
;   stack +8: A3 = grid struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   none
; READS:
;   none
; WRITES:
;   55(A3) and 36(A3, index)
; DESC:
;   Initializes four row entries and clears associated slot values.
; NOTES:
;   DBF runs (D0+1) iterations (5 entries incl. zero).
;------------------------------------------------------------------------------
NEWGRID_ResetRowTable:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.init_row_slots_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return_row_table

    MOVE.L  D7,D1
    ADDQ.L  #4,D1
    MOVE.B  D1,55(A3,D7.L)
    MOVE.L  D7,D1
    ASL.L   #2,D1
    CLR.L   36(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   .init_row_slots_loop

.return_row_table:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_SetRowColor   (Set row color slot)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = selector (0..3)
;   stack +16: D6 = color index (0..16) or -1
; RET:
;   D0: selected pen index
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   none
; READS:
;   none
; WRITES:
;   55(A3, row)
; DESC:
;   Maps selector to a pen index and updates row color if D6 is in range.
; NOTES:
;   Out-of-range color defaults to 7.
;------------------------------------------------------------------------------
NEWGRID_SetRowColor:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  D7,D0
    ADDQ.W  #1,D0
    BEQ.S   .case_pen7

    SUBQ.W  #1,D0
    BEQ.S   .case_pen4

    SUBQ.W  #1,D0
    BEQ.S   .case_pen5

    SUBQ.W  #1,D0
    BEQ.S   .case_pen6

    BRA.S   .use_default_pen

.case_pen7:
    MOVEQ   #7,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen4:
    MOVEQ   #4,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen5:
    MOVEQ   #5,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen6:
    MOVEQ   #6,D5
    BRA.S   .apply_pen_and_slot_index

.use_default_pen:
    MOVEQ   #4,D5

.apply_pen_and_slot_index:
    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D0,D7
    TST.L   D6
    BMI.S   .set_default_color_value

    MOVEQ   #16,D0
    CMP.L   D0,D6
    BGT.S   .set_default_color_value

    MOVE.L  D6,D0
    MOVE.B  D0,55(A3,D7.W)
    BRA.S   .return_pen

.set_default_color_value:
    MOVE.B  #$7,55(A3,D7.W)

.return_pen:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ValidateSelectionCode   (Validate selection code against flags)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = selection code
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   DATA_CTASKS_STR_Y_1BBF/1BB2/1BB9/1BAE/1BB1/1BAF, GCOMMAND_DigitalNicheEnabledFlag/22D5/22E4
; WRITES:
;   54(A3)
; DESC:
;   Validates a selection code against feature flags and updates the active
;   selection byte when allowed.
; NOTES:
;   Long chain of comparisons over coded ranges.
;------------------------------------------------------------------------------
NEWGRID_ValidateSelectionCode:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVEQ   #0,D0
    MOVE.B  54(A3),D0
    CMP.L   D7,D0
    BGE.W   .maybe_keep_or_clear_zero

    MOVE.L  D7,D0
    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.S   .case_16

    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.W   .case_32

    SUBQ.L  #1,D0
    BEQ.W   .case_33

    SUBQ.L  #1,D0
    BEQ.W   .case_34

    SUBQ.L  #1,D0
    BEQ.W   .case_35

    SUBQ.L  #1,D0
    BEQ.W   .case_36

    SUBQ.L  #1,D0
    BEQ.W   .case_37

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.S   .case_48

    SUBQ.L  #1,D0
    BEQ.W   .case_49

    SUBQ.L  #1,D0
    BEQ.W   .case_34

    SUBQ.L  #1,D0
    BEQ.W   .case_35

    SUBQ.L  #1,D0
    BEQ.W   .case_36

    SUBQ.L  #1,D0
    BEQ.W   .case_37

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    BRA.W   .clear_active_selection

.case_16:
    MOVE.B  DATA_CTASKS_STR_Y_1BBF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_32:
    MOVE.B  DATA_CTASKS_STR_Y_1BB2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_48:
    MOVE.B  DATA_CTASKS_STR_N_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_33:
    MOVE.B  GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_49:
    MOVE.B  DATA_CTASKS_STR_N_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.B  GCOMMAND_DigitalNicheEnabledFlag,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_34:
    MOVE.B  DATA_CTASKS_STR_Y_1BAE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .case_34_alt

    MOVE.B  DATA_CTASKS_STR_N_1BB1,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

.case_34_alt:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_35:
    MOVE.B  DATA_CTASKS_STR_Y_1BAF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_36:
    MOVE.B  GCOMMAND_DigitalMplexEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_37:
    MOVE.B  GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_64:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.clear_active_selection:
    CLR.B   54(A3)
    BRA.S   .return_selection_validation

.maybe_keep_or_clear_zero:
    TST.L   D7
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)

.return_selection_validation:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridCellText   (Draw primary/secondary cell labels)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = primary string
;   stack +16: A0 = secondary string
;   stack +20: D7 = align flag
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   PARSEINI_JMPTBL_STRING_AppendAtNull, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength,
;   _LVOMove, _LVOText
; READS:
;   NEWGRID_SampleTimeTextWidthPx, NEWGRID_RowHeightPx, NEWGRID_GridOperationId,
;   GCOMMAND_NicheTextPen, DATA_CTASKS_STR_C_1BA3
; WRITES:
;   local temp strings (-26(A5))
; DESC:
;   Draws up to two strings centered within a grid cell, handling RAVESC markers.
; NOTES:
;   Uses NEWGRID_GridOperationId/DATA_CTASKS_STR_C_1BA3 to alter pen/centering behavior.
;------------------------------------------------------------------------------
NEWGRID_DrawGridCellText:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .compute_layout

    MOVEA.L 16(A5),A0
    LEA     -26(A5),A1

.copy_secondary_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_secondary_loop

    MOVE.B  #$2d,-24(A5)
    CLR.B   -23(A5)
    MOVEA.L 16(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,-(A7)
    PEA     -26(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    LEA     -26(A5),A0
    MOVE.L  A0,16(A5)

.compute_layout:
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_SampleTimeTextWidthPx,D0
    TST.L   D0
    ; adjust negative values before ASR (round toward 0)
    BPL.S   .round_height_half

    ADDQ.L  #1,D0

.round_height_half:
    ASR.L   #1,D0
    MOVE.L  D0,D5
    MOVEQ   #42,D1
    ADD.L   D1,D5
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .round_width_half

    ADDQ.L  #1,D1

.round_width_half:
    ASR.L   #1,D1
    MOVEA.L 52(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .round_width_half_adjust

    ADDQ.L  #1,D1

.round_width_half_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    MOVE.L  D1,D4
    ADDQ.L  #3,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    TST.L   D1
    BPL.S   .round_text_half

    ADDQ.L  #1,D1

.round_text_half:
    ASR.L   #1,D1
    TST.L   D7
    BNE.S   .compute_right_align

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    TST.L   D2
    BPL.S   .round_left_half

    ADDQ.L  #1,D2

.round_left_half:
    ASR.L   #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    SUB.L   D3,D2
    TST.L   D2
    BPL.S   .round_left_half_adjust

    ADDQ.L  #1,D2

.round_left_half_adjust:
    ASR.L   #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    ADD.L   D3,D2
    SUBQ.L  #1,D2
    BRA.S   .store_baselines

.compute_right_align:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    TST.L   D2
    BPL.S   .round_right_half

    ADDQ.L  #1,D2

.round_right_half:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    SUB.L   D0,D2
    SUBQ.L  #4,D2
    TST.L   D2
    BPL.S   .round_right_half_adjust

    ADDQ.L  #1,D2

.round_right_half_adjust:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    SUBQ.L  #1,D2

.store_baselines:
    ADD.L   D2,D1
    MOVEM.L D1,-16(A5)
    MOVEQ   #5,D0
    CMP.L   NEWGRID_GridOperationId,D0
    BNE.S   .use_alt_pen

    MOVEA.L A3,A1
    MOVE.L  GCOMMAND_NicheTextPen,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.S   .pen_set

.use_alt_pen:
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.pen_set:
    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A2,A0

.scan_primary_end:
    ; find primary string length
    TST.B   (A0)+
    BNE.S   .scan_primary_end

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.S   .begin_secondary_text_pass

    MOVEA.L A2,A0

.scan_primary_end_for_trim:
    TST.B   (A0)+
    BNE.S   .scan_primary_end_for_trim

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6

.trim_primary_trailing_space:
    ; trim trailing spaces
    TST.L   D6
    BLE.S   .primary_trim_done

    MOVEQ   #32,D0
    CMP.B   -1(A2,D6.L),D0
    BNE.S   .primary_trim_done

    SUBQ.L  #1,D6
    BRA.S   .trim_primary_trailing_space

.primary_trim_done:
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .primary_half_width

    ADDQ.L  #1,D0

.primary_half_width:
    ASR.L   #1,D0
    MOVE.L  D5,D1
    SUB.L   D0,D1
    MOVE.B  DATA_CTASKS_STR_C_1BA3,D0
    MOVEQ   #83,D2
    CMP.B   D2,D0
    BNE.S   .primary_use_cell_center_x

    MOVE.L  D4,D0
    BRA.S   .primary_draw

.primary_use_cell_center_x:
    MOVE.L  -16(A5),D0

.primary_draw:
    MOVE.L  D0,36(A7)
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  36(A7),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    JSR     _LVOText(A6)

.begin_secondary_text_pass:
    MOVEA.L 16(A5),A0

.scan_secondary_end:
    ; find secondary string length
    TST.B   (A0)+
    BNE.S   .scan_secondary_end

    SUBQ.L  #1,A0
    SUBA.L  16(A5),A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.S   .return_cell_text

    MOVEA.L 16(A5),A0

.scan_secondary_end_for_trim:
    TST.B   (A0)+
    BNE.S   .scan_secondary_end_for_trim

    SUBQ.L  #1,A0
    SUBA.L  16(A5),A0
    MOVE.L  A0,D6

.trim_secondary_trailing_space:
    ; trim trailing spaces
    TST.L   D6
    BLE.S   .secondary_trim_done

    MOVEQ   #32,D0
    MOVEA.L 16(A5),A0
    CMP.B   -1(A0,D6.L),D0
    BNE.S   .secondary_trim_done

    SUBQ.L  #1,D6
    BRA.S   .trim_secondary_trailing_space

.secondary_trim_done:
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L 16(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .secondary_half_width

    ADDQ.L  #1,D0

.secondary_half_width:
    ASR.L   #1,D0
    MOVE.L  D5,D1
    SUB.L   D0,D1
    MOVE.B  DATA_CTASKS_STR_C_1BA3,D0
    MOVEQ   #83,D2
    CMP.B   D2,D0
    BNE.S   .secondary_use_cell_center_x

    MOVE.L  -16(A5),D0
    BRA.S   .secondary_draw

.secondary_use_cell_center_x:
    MOVE.L  D4,D0

.secondary_draw:
    MOVE.L  D0,36(A7)
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  36(A7),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L 16(A5),A0
    JSR     _LVOText(A6)

.return_cell_text:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridCell   (Draw cell background and text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = cell struct
;   stack +16: D7 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3, NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, NEWGRID_DrawGridCellText
; READS:
;   NEWGRID_ColumnStartXPx, NEWGRID_RowHeightPx
; WRITES:
;   none
; DESC:
;   Draws the cell background (highlight or normal) and renders its labels.
; NOTES:
;   Uses two string pointers from the cell struct (1(A2), 19(A2)).
;------------------------------------------------------------------------------
NEWGRID_DrawGridCell:
    LINK.W  A5,#-8
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    LEA     1(A2),A0
    LEA     19(A2),A1
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    MOVE.L  A1,-8(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    ; choose frame style based on row flag
    TST.L   D7
    BNE.S   .draw_alternate_frame

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .draw_cell_text

.draw_alternate_frame:
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.draw_cell_text:
    MOVE.L  D7,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridCellText

    MOVEM.L -24(A5),D2/D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_Apply24HourFormatting   (Patch time string for 24h)
; ARGS:
;   stack +8: A3 = string pointer
;   stack +12: D7 = hour index
;   stack +19: D6 = minute index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_STR_FindCharPtr, NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow
; READS:
;   Global_REF_STR_USE_24_HR_CLOCK, Global_JMPTBL_HALF_HOURS_24_HR_FMT
; WRITES:
;   A3 string contents
; DESC:
;   If 24-hour clock flag is set and format matches, updates HH:MM digits in-place.
; NOTES:
;   Expects string with ':' at offset 3.
;------------------------------------------------------------------------------
NEWGRID_Apply24HourFormatting:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .done

    MOVE.L  A3,D0
    BEQ.S   .done

    PEA     40.W
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .done

    MOVEQ   #58,D0
    MOVEA.L -4(A5),A0
    CMP.B   3(A0),D0
    BNE.S   .done

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,1(A0)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    ADDQ.L  #1,A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,2(A0)

.done:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ComputeColumnIndex   (Compute column index from selection)
; ARGS:
;   stack +8: A3 = grid struct
; RET:
;   D0: column index (0..?)
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   NEWGRID_RowHeightPx, 52(A3), 54(A3)
; WRITES:
;   none
; DESC:
;   Computes a column index based on selection byte and header width.
; NOTES:
;   Returns 0 when selection >= 0x40.
;------------------------------------------------------------------------------
NEWGRID_ComputeColumnIndex:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #0,D7
    CMPI.B  #'@',54(A3)
    BCC.S   .done

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .center

    ADDQ.L  #3,D0

.center:
    ASR.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  52(A3),D1
    MOVE.L  D0,8(A7)
    MOVE.L  D1,D0
    MOVE.L  8(A7),D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7

.done:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_GetGridModeIndex   (Return grid mode index)
; ARGS:
;   (none)
; RET:
;   D0: mode index (1 or 6)
; CLOBBERS:
;   D0/D7
; CALLS:
;   none
; READS:
;   NEWGRID_ModeSelectorState
; WRITES:
;   none
; DESC:
;   Returns 1 when NEWGRID_ModeSelectorState==1, otherwise 6.
; NOTES:
;   Simple helper for mode selection.
;------------------------------------------------------------------------------
NEWGRID_GetGridModeIndex:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   NEWGRID_ModeSelectorState,D0
    BEQ.S   .done

    MOVEQ   #6,D0

.done:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_RebuildIndexCache   (Rebuild lookup cache)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   NEWGRID_SecondaryIndexCachePtr, ESQPARS2_ReadModeFlags, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_SecondaryGroupEntryCount
; WRITES:
;   NEWGRID_SecondaryIndexCachePtr, ESQPARS2_ReadModeFlags
; DESC:
;   Clears and repopulates the cache table at NEWGRID_SecondaryIndexCachePtr based on current entries.
; NOTES:
;   Temporarily sets ESQPARS2_ReadModeFlags to 0x0100 while rebuilding.
;------------------------------------------------------------------------------
NEWGRID_RebuildIndexCache:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    TST.L   NEWGRID_SecondaryIndexCachePtr
    BEQ.W   .done

    MOVE.W  ESQPARS2_ReadModeFlags,D5
    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    MOVEQ   #0,D7

.clear_cache_loop:
    CMPI.L  #$12e,D7
    BGE.S   .rebuild_start

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #-1,D1
    MOVEA.L NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D1,0(A0,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .clear_cache_loop

.rebuild_start:
    MOVEQ   #0,D7

.rebuild_loop:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .restore_flags

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-14(A5)
    TST.L   D0
    BEQ.S   .next_entry

    MOVEA.L D0,A0
    ADDA.W  #12,A0
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BLE.S   .next_entry

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .next_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D6,0(A0,D0.L)

.next_entry:
    ADDQ.L  #1,D7
    BRA.S   .rebuild_loop

.restore_flags:
    MOVE.W  D5,ESQPARS2_ReadModeFlags

.done:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdatePresetEntry   (Update preset entry mapping)
; ARGS:
;   stack +8: A3 = dst pointer
;   stack +12: A2 = src pointer
;   stack +18: D7 = index
;   stack +20: D6 = key
; RET:
;   D0: updated index
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_SecondaryEntryPtrTable, NEWGRID_SecondaryIndexCachePtr
; WRITES:
;   NEWGRID_SecondaryIndexCachePtr table entries
; DESC:
;   Updates preset entry mapping based on key/index and validates against list.
; NOTES:
;   Uses lookup table TEXTDISP_SecondaryEntryPtrTable and caches indices in NEWGRID_SecondaryIndexCachePtr.
;------------------------------------------------------------------------------
NEWGRID_UpdatePresetEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVEQ   #0,D4
    MOVE.L  (A3),-12(A5)
    MOVE.L  (A2),-16(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .normalized_index

    SUBI.W  #$30,D7
    MOVEQ   #1,D4

.normalized_index:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -12(A5)
    BEQ.W   .done

    TST.L   D0
    BEQ.W   .done

    MOVEQ   #1,D1
    CMP.W   D1,D7
    BEQ.S   .check_entry_enabled

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BEQ.S   .check_entry_enabled

    TST.L   D4
    BEQ.W   .done

.check_entry_enabled:
    TST.B   TEXTDISP_SecondaryGroupPresentFlag
    BEQ.W   .done

    TST.L   NEWGRID_SecondaryIndexCachePtr
    BEQ.S   .cache_miss

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  0(A0,D0.L),D5
    TST.L   D5
    BMI.S   .rebuild_cache_entry

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .rebuild_cache_entry

    MOVEA.L -12(A5),A0
    ADDA.W  #12,A0
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    LEA     12(A6),A1

.compare_string_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .rebuild_cache_entry

    TST.B   D0
    BNE.S   .compare_string_loop

    BEQ.S   .update_entry

.rebuild_cache_entry:
    MOVE.L  -16(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D5,0(A0,D0.L)
    BRA.S   .update_entry

.cache_miss:
    MOVE.L  -16(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5

.update_entry:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)

.done:
    MOVE.L  -12(A5),(A3)
    MOVE.L  -16(A5),(A2)
    MOVE.L  D7,D0

    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridEntry   (Draw grid entry line)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry list
;   stack +22: D7 = row index
;   stack +26: D6 = column index
;   stack +28: D5 = flags
; RET:
;   D0: none observed
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridCellText, NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex, NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   DATA_NEWGRID_STR_VALUE_2019, NEWGRID_GridOperationId, GCOMMAND_NicheTextPen
; WRITES:
;   local buffer -19(A5)
; DESC:
;   Draws a single grid entry row using text and selection state.
; NOTES:
;   Validates entry pointers and row bounds before drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawGridEntry:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    LEA     DATA_NEWGRID_STR_VALUE_2019,A0
    LEA     -19(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A2,D0
    BEQ.W   .draw_missing_entry

    TST.L   16(A5)
    BEQ.W   .draw_missing_entry

    TST.W   D7
    BLE.W   .draw_missing_entry

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   .draw_missing_entry

    MOVE.L  A0,D0
    BEQ.W   .draw_missing_entry

    TST.B   (A0)
    BEQ.W   .draw_missing_entry

    MOVE.L  32(A5),D0
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BEQ.S   .check_time_prefix

    ADDQ.L  #1,D0
    BNE.S   .no_time_prefix

.check_time_prefix:
    ; detect time prefix to skip
    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   .no_time_prefix

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BNE.S   .no_time_prefix

    MOVEQ   #8,D0
    BRA.S   .apply_prefix_offset

.no_time_prefix:
    MOVEQ   #0,D0

.apply_prefix_offset:
    ADD.L   D0,-16(A5)
    MOVEA.L -16(A5),A0
    MOVEA.L NEWGRID_EntryTextScratchPtr,A1

.copy_entry_string:
    ; copy entry text into scratch buffer
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_string

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVEA.L 16(A5),A0
    MOVE.B  498(A0),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    BSR.W   NEWGRID_Apply24HourFormatting

    LEA     12(A7),A7
    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   .check_custom_render

    BTST    #4,27(A2)
    BEQ.W   .draw_empty_entry

.check_custom_render:
    TST.L   D5
    BEQ.S   .split_primary_line

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .split_primary_line

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  32(A5),-(A7)
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(PC)

    MOVE.L  NEWGRID_EntryTextScratchPtr,(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    LEA     24(A7),A7
    BRA.W   .done

.split_primary_line:
    ; split primary line on delimiter (offset 34)
    PEA     34.W
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .after_split_search

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.after_split_search:
    TST.L   D0
    BEQ.S   .draw_primary_line

    PEA     DATA_NEWGRID_CONST_LONG_2018
    MOVE.L  D0,-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .trim_primary_leading

    MOVE.L  D0,-4(A5)

.trim_primary_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_primary

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_primary

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_primary_leading

.terminate_primary:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_primary_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_primary_line

.clear_primary_ptr:
    CLR.L   -4(A5)

.draw_primary_line:
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    TST.L   D5
    BEQ.W   .post_draw

    TST.L   -4(A5)
    BEQ.W   .post_draw

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.W   .post_draw

    PEA     40.W
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .check_subtitle

    MOVEQ   #41,D1
    MOVEA.L D0,A0
    CMP.B   5(A0),D1
    BNE.S   .check_subtitle

    LEA     6(A0),A1
    MOVE.L  A1,-4(A5)

.trim_secondary_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_secondary

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_secondary

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_secondary_leading

.terminate_secondary:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_secondary_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_secondary_line

.clear_secondary_ptr:
    CLR.L   -4(A5)

.draw_secondary_line:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .check_subtitle

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.check_subtitle:
    TST.L   -4(A5)
    BEQ.W   .post_draw

    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .after_subtitle_parse

    PEA     44.W
    MOVE.L  D0,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.S   .fallback_subtitle

    PEA     46.W
    MOVE.L  D0,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_subtitle_parse

    MOVE.L  -12(A5),-4(A5)
    CLR.L   -12(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$2e,(A0)
    BRA.S   .after_subtitle_parse

.fallback_subtitle:
    PEA     46.W
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_subtitle_parse

    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)

.after_subtitle_parse:
    TST.L   -8(A5)
    BEQ.W   .post_draw

.trim_subtitle_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_subtitle

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_subtitle

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_subtitle_leading

.terminate_subtitle:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_subtitle_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_subtitle_line

.clear_subtitle_ptr:
    CLR.L   -4(A5)

.draw_subtitle_line:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_subtitle_fallback

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .post_draw

.draw_subtitle_fallback:
    TST.L   -12(A5)
    BEQ.S   .post_draw

    MOVEA.L -12(A5),A0
    MOVE.B  #$2e,(A0)
    CLR.B   1(A0)
    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_subtitle_alt

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .post_draw

.draw_subtitle_alt:
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .post_draw

    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.post_draw:
    TST.L   -4(A5)
    BEQ.S   .post_split_draw

    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .post_split_draw

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     -19(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     PARSEINI_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.split_loop:
    TST.L   -12(A5)
    BEQ.S   .finalize_split

    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-4(A5)
    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BRA.S   .split_loop

.finalize_split:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.post_split_draw:
    MOVE.L  32(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .done

    TST.L   D5
    BEQ.S   .done

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BLE.S   .done

    MOVEA.L NEWGRID_EntryTextScratchPtr,A0
    CLR.B   (A0)
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(PC)

    MOVE.L  NEWGRID_EntryTextScratchPtr,(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    LEA     24(A7),A7
    BRA.S   .done

.draw_empty_entry:
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .done

.draw_missing_entry:
    MOVE.L  DATA_SCRIPT_CONST_LONG_2111,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEntryFlagBadge   (Draw entry flag indicator)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1, NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes, NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   27(A2)
; WRITES:
;   none
; DESC:
;   Draws a badge/flag indicator for entries with specific flags set.
; NOTES:
;   Uses cleanup/test helpers to validate the entry before drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawEntryFlagBadge:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  24(A5),D6
    MOVE.L  D6,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.L  A2,D0
    BEQ.S   .fallback_draw

    BTST    #4,27(A2)
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     5.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(PC)

    MOVE.L  20(A5),(A7)
    PEA     20.W
    MOVE.L  -4(A5),-(A7)
    PEA     19.W
    PEA     DATA_NEWGRID_FMT_PCT_C_PCT_S_PCT_C_PCT_S_201A
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(PC)

    LEA     28(A7),A7
    BRA.S   .done

.fallback_draw:
    MOVE.L  20(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameAndRows   (Draw grid frame and row dividers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: status from NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount, NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength,
;   NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws the grid background/frame and row separator lines, updating layout.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameAndRows:
    LINK.W  A5,#-28
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .done

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,40(A7)
    BSR.W   NEWGRID_SetRowColor

    MOVEA.L 40(A7),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D5
    CLR.L   -16(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(PC)

    LEA     12(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .after_header

    LEA     60(A3),A0
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    MOVEQ   #0,D6
    MOVE.L  D0,-24(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .after_rows

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    TST.L   D6
    BNE.S   .row_flag_path

    TST.L   -24(A5)
    BEQ.S   .row_flag_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .row_default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,-16(A5)
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-20(A5)
    TST.L   -24(A5)
    BEQ.S   .draw_bottom_bevel

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

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

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateGridState   (Advance grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = key/index
;   stack +18: D6 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID_DrawEntryFlagBadge,
;   NEWGRID_DrawGridFrameAndRows, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   DATA_NEWGRID_CONST_LONG_201B
; WRITES:
;   DATA_NEWGRID_CONST_LONG_201B, DATA_WDISP_BSS_LONG_2333, 32(A3)
; DESC:
;   Updates grid state, resolves the selected entry, and redraws frame content.
; NOTES:
;   State machine uses DATA_NEWGRID_CONST_LONG_201B values 4/5.
;------------------------------------------------------------------------------
NEWGRID_UpdateGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .check_state

    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_201B
    BRA.W   .done

.check_state:
    MOVE.L  DATA_NEWGRID_CONST_LONG_201B,D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BNE.S   .state_is_five

    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    BRA.W   .update_frame_state

.state_is_five:
    SUBQ.L  #4,D0
    BNE.W   .force_state_4

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
    BEQ.W   .update_frame_state

    TST.L   -8(A5)
    BEQ.W   .update_frame_state

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .update_frame_state

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D6
    MOVE.L  -4(A5),(A7)
    BSR.W   NEWGRID_SelectEntryPen

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    MOVE.L  D0,DATA_WDISP_BSS_LONG_2333
    BTST    #2,7(A1)
    BEQ.S   .set_entry_mode

    MOVEQ   #5,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_2333

.set_entry_mode:
    LEA     60(A3),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A0
    MOVE.L  NEWGRID_OverridePenIndex,-(A7)
    MOVE.L  56(A0),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   NEWGRID_DrawEntryFlagBadge

    CLR.L   (A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    LEA     20(A7),A7
    MOVE.L  D0,32(A3)
    BRA.S   .update_frame_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_201B

.update_frame_state:
    MOVE.L  DATA_WDISP_BSS_LONG_2333,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .set_state_4

    MOVEQ   #4,D0
    BRA.S   .store_state

.set_state_4:
    MOVEQ   #5,D0

.store_state:
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_201B

.done:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_SetSelectionMarkers   (Set glyph markers based on indices)
; ARGS:
;   stack +8: D7 = primary selector
;   stack +12: D6 = secondary selector
;   stack +16: A3 = primary dst byte
;   stack +20: A2 = secondary dst byte
;   stack +24: A0 = tertiary dst byte
;   stack +28: A0 = quaternary dst byte
; RET:
;   D0: none
; CLOBBERS:
;   D0/D6-D7/A0-A3
; CALLS:
;   none
; DESC:
;   Writes marker bytes based on selector values (0/1/2).
; NOTES:
;   Uses fixed byte codes 0x80..0x8B for marker glyphs.
;------------------------------------------------------------------------------
NEWGRID_SetSelectionMarkers:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_primary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_primary1

    SUBQ.L  #1,D0
    BEQ.S   .case_primary2

    BRA.S   .case_primary_default

.case_primary1:
    MOVE.B  #$80,(A3)
    MOVE.B  #$81,(A2)
    BRA.S   .after_primary

.case_primary2:
    MOVE.B  #$82,(A3)
    MOVE.B  #$83,(A2)
    BRA.S   .after_primary

.case_primary_default:
    MOVEQ   #0,D0
    MOVE.B  D0,(A3)
    MOVE.B  D0,(A2)

.after_primary:
    MOVE.L  D6,D0
    TST.L   D0
    BEQ.S   .case_secondary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary1

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary2

    BRA.S   .case_secondary_default

.case_secondary1:
    MOVEA.L 24(A5),A0
    MOVE.B  #$88,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$89,(A0)
    BRA.S   .done

.case_secondary2:
    MOVEA.L 24(A5),A0
    MOVE.B  #$8a,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$8b,(A0)
    BRA.S   .done

.case_secondary_default:
    MOVEQ   #0,D0
    MOVEA.L 24(A5),A0
    MOVE.B  D0,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  D0,(A0)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_GetEntryStateCode   (Compute entry state code)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry list
;   stack +18: D7 = row index
; RET:
;   D0: state code (1..3)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   7(A2,D7), 56(A2,index)
; DESC:
;   Computes a state code based on entry flags and availability.
; NOTES:
;   Returns 1 for invalid/out-of-range.
;------------------------------------------------------------------------------
NEWGRID_GetEntryStateCode:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  30(A7),D7
    MOVE.L  A3,D0
    BEQ.S   .invalid

    MOVE.L  A2,D0
    BEQ.S   .invalid

    TST.W   D7
    BLE.S   .invalid

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   .invalid

    LEA     28(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   .check_entry_flags

    MOVEQ   #0,D6
    BRA.S   .done

.check_entry_flags:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .set_state3

    BTST    #7,7(A2,D7.W)
    BEQ.S   .set_state2

.set_state3:
    MOVEQ   #3,D6
    BRA.S   .done

.set_state2:
    MOVEQ   #2,D6
    BRA.S   .done

.invalid:
    MOVEQ   #1,D6

.done:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestEntryState   (Test entry state against mode)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = key
;   stack +16: D5 = entry pointer
;   stack +22: D4 = selector value
; RET:
;   D0: boolean (-1/0) result
; CLOBBERS:
;   D0-D7
; CALLS:
;   NEWGRID_GetEntryStateCode, NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; DESC:
;   Determines whether an entry matches the requested selector/mode.
; NOTES:
;   Uses SNE/NEG/EXT to booleanize in mode 0.
;------------------------------------------------------------------------------
NEWGRID_TestEntryState:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.W  22(A5),D4
    CLR.L   -12(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BGT.S   .use_second_key

    MOVEQ   #1,D0
    CMP.W   D0,D4
    BNE.S   .use_first_key

.use_second_key:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.normalize_key:
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BLE.S   .compute_state

    SUBI.W  #$30,D4
    BRA.S   .normalize_key

.use_first_key:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.compute_state:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_GetEntryStateCode

    LEA     12(A7),A7
    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .mode0

    SUBQ.L  #1,D0
    BEQ.S   .mode1

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    BRA.S   .done

.mode0:
    TST.L   -16(A5)
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode1:
    MOVE.L  -16(A5),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .mode1_match

    SUBQ.L  #3,D0
    BEQ.S   .mode1_match

    MOVEQ   #0,D0
    BRA.S   .mode1_done

.mode1_match:
    MOVEQ   #1,D0

.mode1_done:
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode2:
    MOVEQ   #3,D1
    CMP.L   -16(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)

.done:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEntryRowOrPlaceholder   (Draw entry row or placeholder)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +24: arg_6 (via 28(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   DATA_NEWGRID_CONST_WORD_2015, DATA_CTASKS_STR_Y_1BB8, DATA_SCRIPT_CONST_LONG_2111, DATA_SCRIPT_CONST_LONG_2115
; DESC:
;   Draws the grid entry for a row when data is present, otherwise draws a
;   placeholder label depending on the flags.
;------------------------------------------------------------------------------
NEWGRID_DrawEntryRowOrPlaceholder:
    LINK.W  A5,#0
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   .draw_empty_placeholder

    SUBQ.L  #1,D0
    BEQ.S   .draw_missing_placeholder

    SUBQ.L  #1,D0
    BNE.S   .draw_missing_placeholder

    TST.W   DATA_NEWGRID_CONST_WORD_2015
    BEQ.S   .draw_simple_row

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D2
    MOVEQ   #89,D4
    CMP.B   D4,D2
    SEQ     D3
    NEG.B   D3
    EXT.W   D3
    EXT.L   D3
    PEA     2.W
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_simple_row:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_empty_placeholder:
    MOVE.L  DATA_SCRIPT_CONST_LONG_2115,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .done

.draw_missing_placeholder:
    MOVE.L  DATA_SCRIPT_CONST_LONG_2111,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridCellBackground   (Draw cell background/frame)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
;   stack +18: D6 = column index
;   stack +20: D5 = color selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx, DATA_CTASKS_STR_Y_1BB8
; DESC:
;   Fills a grid cell background and draws its frame based on row/column and
;   clock format flags.
;------------------------------------------------------------------------------
NEWGRID_DrawGridCellBackground:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
    MULU    D7,D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #36,D1
    ADD.L   D1,D4
    CLR.L   -8(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  A0,-20(A5)
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BLT.S   .compute_cell_right

    MOVE.L  #695,D0
    BRA.S   .store_bounds

.compute_cell_right:
    MOVE.W  NEWGRID_ColumnWidthPx,D0
    MULU    D6,D0
    MOVE.L  D4,D1
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0

.store_bounds:
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D1,-16(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D5
    BEQ.S   .skip_background_fill

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    MOVEA.L -20(A5),A1
    MOVE.L  -8(A5),D1
    MOVE.L  -12(A5),D2
    MOVE.L  -16(A5),D3
    JSR     _LVORectFill(A6)

.skip_background_fill:
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .draw_normal_frame

    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_normal_frame

    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .done

.draw_normal_frame:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.done:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridHeaderRows   (Draw header row separators)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: status from NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop, NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
; READS:
;   NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws header frame and repeated horizontal separators for the grid.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridHeaderRows:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEQ   #0,D5
    MOVE.L  D5,D4
    MOVE.L  D0,-12(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BGE.W   .after_rows

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,-16(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .alt_half_width

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D5
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-20(A5)
    BEQ.S   .draw_bottom_bevel

    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D4
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     36(A7),A7
    BRA.S   .store_header_width

.draw_bottom_bevel:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

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

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawSelectionMarkers   (Draw selection glyph markers)
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
;   D0: status from NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID_DrawGridCellBackground, NEWGRID_SetSelectionMarkers, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine,
;   NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _LVOMove, _LVOText, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
; DESC:
;   Lays out and draws selection marker glyphs for a row and column.
; NOTES:
;   Computes centered positions using rounding before ASR.
;------------------------------------------------------------------------------
NEWGRID_DrawSelectionMarkers:
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
    BSR.W   NEWGRID_DrawGridCellBackground

    PEA     -36(A5)
    PEA     -35(A5)
    PEA     -34(A5)
    PEA     -33(A5)
    MOVE.L  28(A5),-(A7)
    MOVE.L  24(A5),-(A7)
    BSR.W   NEWGRID_SetSelectionMarkers

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
    MOVE.W  NEWGRID_ColumnStartXPx,D1
    MOVE.W  NEWGRID_ColumnWidthPx,D2
    MOVE.L  D7,D3
    MULS    D2,D3
    ADD.L   D3,D1
    ADD.L   -24(A5),D1
    MOVEQ   #42,D2
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  NEWGRID_RowHeightPx,D2
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .after_frame

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-32(A5)
    BEQ.S   .done

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .done

    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .done

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_RowHeightPx,D1
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.done:
    MOVE.L  -32(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_SelectEntryPen   (Select pen index for entry)
; ARGS:
;   stack +8: A3 = entry pointer
; RET:
;   D0: pen index (0..15)
; CLOBBERS:
;   D0-D2/D7/A3
; CALLS:
;   none
; READS:
;   NEWGRID_GridOperationId, GCOMMAND_NicheTextPen/GCOMMAND_NicheFramePen/GCOMMAND_MplexDetailLayoutPen/GCOMMAND_MplexDetailRowPen, GCOMMAND_PpvShowtimesLayoutPen, GCOMMAND_PpvShowtimesRowPen, 27(A3), 41(A3), 42(A3)
; WRITES:
;   NEWGRID_OverridePenIndex
; DESC:
;   Computes a pen index based on entry flags and current selection mode.
; NOTES:
;   Uses switch/jumptable lookups for default/override pen selection.
;------------------------------------------------------------------------------
NEWGRID_SelectEntryPen:
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    MOVEQ   #0,D7
    NOT.B   D7
    MOVE.L  A3,D0
    BEQ.S   .pen_selected

    MOVEQ   #0,D0
    MOVE.B  41(A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .check_flag_bit1

    MOVEQ   #0,D7
    MOVE.B  D0,D7
    BRA.S   .pen_selected

.check_flag_bit1:
    BTST    #1,27(A3)
    BEQ.S   .check_flag_bit6

    MOVEQ   #4,D7
    BRA.S   .pen_selected

.check_flag_bit6:
    BTST    #6,27(A3)
    BEQ.S   .check_flag_bit4

    MOVEQ   #5,D7
    BRA.S   .pen_selected

.check_flag_bit4:
    BTST    #4,27(A3)
    BEQ.S   .pen_selected

    MOVEQ   #7,D7

.pen_selected:
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D7
    BNE.S   .pen_ready

    MOVE.L  NEWGRID_GridOperationId,D0
    SUBQ.L  #1,D0
    BLT.S   .out_of_range

    CMPI.L  #$7,D0
    BGE.S   .out_of_range

    ADD.W   D0,D0
    MOVE.W  .default_jumptable(PC,D0.W),D0
    JMP     .default_jumptable+2(PC,D0.W)

; switch/jumptable
.default_jumptable:
    DC.W    .out_of_range-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_pen_from_niche_frame_pen-.default_jumptable-2
    DC.W    .case_pen_from_mplex_detail_row_pen-.default_jumptable-2
    DC.W    .case_pen_from_ppv_showtimes_row_pen-.default_jumptable-2

.case_default_pen:
    MOVEQ   #6,D7
    BRA.S   .pen_ready

.case_pen_from_niche_frame_pen:
    MOVE.L  GCOMMAND_NicheFramePen,D7
    BRA.S   .pen_ready

.case_pen_from_mplex_detail_row_pen:
    MOVE.L  GCOMMAND_MplexDetailRowPen,D7
    BRA.S   .pen_ready

.case_pen_from_ppv_showtimes_row_pen:
    MOVE.L  GCOMMAND_PpvShowtimesRowPen,D7
    BRA.S   .pen_ready

.out_of_range:
    MOVEQ   #7,D7

.pen_ready:
    TST.L   D7
    BMI.S   .pen_invalid

    MOVEQ   #15,D0
    CMP.L   D0,D7
    BLE.S   .pen_clamp_done

.pen_invalid:
    MOVEQ   #7,D7

.pen_clamp_done:
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,NEWGRID_OverridePenIndex
    MOVE.L  A3,D1
    BEQ.S   .check_override

    MOVEQ   #0,D1
    MOVE.B  42(A3),D1
    CMP.L   D0,D1
    BEQ.S   .check_override

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D2,NEWGRID_OverridePenIndex

.check_override:
    CMP.L   NEWGRID_OverridePenIndex,D0
    BNE.S   .clamp_override

    MOVE.L  NEWGRID_GridOperationId,D0
    SUBQ.L  #1,D0
    BLT.S   .override_default

    CMPI.L  #$7,D0
    BGE.S   .override_default

    ADD.W   D0,D0
    MOVE.W  .override_jumptable(PC,D0.W),D0
    JMP     .override_jumptable+2(PC,D0.W)

; switch/jumptable
.override_jumptable:
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_niche_text_pen-.override_jumptable-2
    DC.W    .override_mplex_detail_layout_pen-.override_jumptable-2
    DC.W    .override_ppv_showtimes_layout_pen-.override_jumptable-2

.override_niche_text_pen:
    MOVE.L  GCOMMAND_NicheTextPen,NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_mplex_detail_layout_pen:
    MOVE.L  GCOMMAND_MplexDetailLayoutPen,NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_ppv_showtimes_layout_pen:
    MOVE.L  GCOMMAND_PpvShowtimesLayoutPen,NEWGRID_OverridePenIndex
    ; MOVE.L  Global_GCOMMAND_PpvShowtimesLayoutPen(A4),NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_default:
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_OverridePenIndex

.clamp_override:
    MOVE.L  NEWGRID_OverridePenIndex,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BLT.S   .override_clamp_default

    MOVEQ   #3,D2
    CMP.L   D2,D0
    BLE.S   .done

.override_clamp_default:
    MOVE.L  D1,NEWGRID_OverridePenIndex

.done:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    RTS

;!======

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
;   NEWGRID_DrawGridHeaderRows, NEWGRID_DrawSelectionMarkers,
;   NEWGRID_DrawEntryRowOrPlaceholder, NEWGRID_GetEntryStateCode,
;   NEWGRID_TestEntryState, NEWGRID_SelectEntryPen, NEWGRID_DrawGridCell,
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths,
;   NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   NEWGRID_GridOperationId, NEWGRID_GridEntriesWorkflowState, TEXTDISP_PrimaryEntryPtrTable/2236, CLOCK_DaySlotIndex, NEWGRID_RowHeightPx/232B/232C/232D/232E
; WRITES:
;   NEWGRID_GridEntriesWorkflowState, DATA_WDISP_BSS_LONG_232C, DATA_WDISP_BSS_LONG_232D, DATA_WDISP_BSS_LONG_232E, DATA_WDISP_BSS_LONG_2333
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
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEntriesWorkflowState
    BRA.W   .return_state

.state_check:
    MOVE.L  NEWGRID_GridEntriesWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BNE.W   .force_state_4

.state5_redraw:
    MOVE.L  DATA_WDISP_BSS_LONG_232D,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_232E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridHeaderRows

    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .no_entry_ptr

.select_entry_ptr:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    BRA.S   .load_entry_ptr

.no_entry_ptr:
    MOVEQ   #-1,D5

.load_entry_ptr:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   NEWGRID_SelectEntryPen

    ADDQ.W  #4,A7
    MOVE.L  D0,DATA_WDISP_BSS_LONG_2333
    MOVEQ   #5,D0
    CMP.L   NEWGRID_GridOperationId,D0
    BNE.S   .set_header_pen

    MOVE.L  GCOMMAND_NicheFramePen,DATA_WDISP_BSS_LONG_232E
    BRA.S   .draw_header_frame

.set_header_pen:
    MOVEQ   #7,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_232E

.draw_header_frame:
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_2333,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_232E,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

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
    MOVE.L  D2,DATA_WDISP_BSS_LONG_232D
    MOVE.L  D2,DATA_WDISP_BSS_LONG_232C
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-4(A5)
    MOVEQ   #48,D0
    CMP.L   D0,D3
    BGT.S   .use_second_key

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BEQ.S   .use_second_key

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .use_first_key

.use_second_key:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

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
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

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
    LEA     TEXTDISP_PrimaryEntryPtrTable,A1
    ADDA.L  D0,A1
    LEA     TEXTDISP_PrimaryTitlePtrTable,A2
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
    MOVE.L  NEWGRID_OverridePenIndex,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_232C
    MOVEA.L -12(A5),A0
    MOVE.W  -20(A5),D0
    BTST    #2,7(A0,D0.W)
    BEQ.S   .set_default_color

    MOVEQ   #5,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_232D
    BRA.S   .compute_cell_height

.set_default_color:
    MOVE.L  #$ff,DATA_WDISP_BSS_LONG_232D

.compute_cell_height:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BNE.S   .cell_height_default

    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D1
    MOVEQ   #89,D2
    CMP.B   D2,D1
    BNE.S   .cell_height_default

    MOVEQ   #20,D1
    BRA.S   .draw_cell

.cell_height_default:
    MOVEQ   #2,D1

.draw_cell:
    MOVE.W  NEWGRID_ColumnWidthPx,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  DATA_WDISP_BSS_LONG_232C,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-42(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

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
    MOVE.L  #$ff,DATA_WDISP_BSS_LONG_232D
    MOVE.W  NEWGRID_ColumnWidthPx,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  D1,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D1,DATA_WDISP_BSS_LONG_232C
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

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
    MOVE.L  #$ff,DATA_WDISP_BSS_LONG_232D
    MOVE.W  NEWGRID_ColumnWidthPx,D2
    MULU    D1,D2
    MOVEQ   #12,D1
    SUB.L   D1,D2
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D0,DATA_WDISP_BSS_LONG_232C
    MOVE.L  D0,-30(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

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
    MOVE.L  DATA_WDISP_BSS_LONG_232D,-(A7)
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

    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_empty_cell

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
    CMP.L   DATA_WDISP_BSS_LONG_232D,D0
    BNE.S   .store_frame_state

    MOVE.L  DATA_WDISP_BSS_LONG_2333,DATA_WDISP_BSS_LONG_232D
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_PrimaryGroupEntryCount
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

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .return

.scan_loop:
    TST.L   D5
    BNE.S   .scan_done

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

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
;   NEWGRID_UpdateGridState, NEWGRID_ProcessGridEntries, NEWGRID_FindNextFlaggedEntry,
;   NEWGRID_GetGridModeIndex, NEWGRID_ValidateSelectionCode, NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_GridSelectionColumnAdjust, NEWGRID_GridSelectionEntryIndex, NEWGRID_GridSelectionWorkflowState, DATA_CTASKS_STR_Y_1BB2, DATA_CTASKS_STR_N_1BB9
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
    BNE.S   .state_dispatch

    MOVEQ   #5,D0
    CMP.L   NEWGRID_GridSelectionWorkflowState,D0
    BNE.S   .reset_state

    MOVE.L  NEWGRID_GridSelectionEntryIndex,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .process_entries

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .reset_state

.process_entries:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState
    MOVE.L  D0,NEWGRID_GridSelectionEntryIndex
    BRA.W   .return_state

.state_dispatch:
    MOVE.L  NEWGRID_GridSelectionWorkflowState,D0
    TST.L   D0
    BEQ.S   .state_init

    SUBQ.L  #3,D0
    BEQ.S   .state_find_next

    SUBQ.L  #1,D0
    BEQ.S   .state_find_next

    SUBQ.L  #1,D0
    BEQ.S   .state_process_entry

    BRA.W   .clear_state

.state_init:
    CLR.L   NEWGRID_GridSelectionColumnAdjust
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState

.state_find_next:
    MOVE.L  NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  NEWGRID_GridSelectionWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextFlaggedEntry

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,NEWGRID_GridSelectionEntryIndex

.state_process_entry:
    MOVE.L  NEWGRID_GridSelectionEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .clear_state

    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state_process_entries

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_GridSelectionWorkflowState
    BRA.S   .post_process

.state_process_entries:
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

    MOVE.B  DATA_CTASKS_STR_N_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .post_process

    PEA     48.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_GridSelectionColumnAdjust

.post_process:
    MOVE.B  DATA_CTASKS_STR_Y_1BB2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .adjust_offset

    TST.L   D6
    BEQ.S   .adjust_offset

    CMPI.L  #$1,NEWGRID_GridSelectionColumnAdjust
    BGE.S   .adjust_offset

    PEA     32.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_GridSelectionColumnAdjust

.adjust_offset:
    MOVE.L  NEWGRID_GridSelectionColumnAdjust,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_GridSelectionColumnAdjust
    BRA.S   .return_state

.clear_state:
    CLR.L   NEWGRID_GridSelectionWorkflowState

.return_state:
    MOVE.L  NEWGRID_GridSelectionWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleGridEditorState   (Handle editor state transitions)
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
;   NEWGRID_DrawGridFrameAndRows, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   NEWGRID_GridEditorWorkflowState
; WRITES:
;   NEWGRID_GridEditorWorkflowState, 32(A3)
; DESC:
;   Drives a small state machine for editor-related redraw paths.
; NOTES:
;   For state 4, source text (A2) is forwarded to
;   DISPTEXT_LayoutAndAppendToBuffer, which tolerates NULL/empty strings.
;------------------------------------------------------------------------------
NEWGRID_HandleGridEditorState:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVEA.L 32(A7),A2
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state_check:
    MOVE.L  NEWGRID_GridEditorWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_draw

    SUBQ.L  #1,D0
    BEQ.S   .state5_draw

    BRA.S   .force_state4

.state4_draw:
    MOVE.L  D7,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    ; A2 may be NULL; downstream layout helper performs NULL/empty checks.
    MOVE.L  A2,(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    CLR.L   (A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  D6,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .state4_done

    MOVEQ   #4,D0
    BRA.S   .store_state

.state4_done:
    MOVEQ   #5,D0

.store_state:
    MOVE.L  D0,NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state5_draw:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state2

.state5_done:
    MOVEQ   #5,D0

.store_state2:
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
;   stack +8: D7 = mode selector
;   stack +12: D6 = start index
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward for entries with required flag bits set.
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .advance_index

    MOVEA.L D0,A0
    BTST    #2,47(A0)
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
; FUNC: NEWGRID_ProcessSecondaryState   (Process alternate state machine)
; ARGS:
;   (none observed)
; RET:
;   D0: state (NEWGRID_SecondaryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_HandleGridEditorState, NEWGRID_UpdateGridState,
;   NEWGRID_ProcessGridEntries, NEWGRID_FindNextEntryWithFlags,
;   NEWGRID_ValidateSelectionCode, NEWGRID_GetGridModeIndex,
;   NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_SecondarySelectedEntryIndex/2022/2023, GCOMMAND_DigitalNicheEnabledFlag/GCOMMAND_NicheEditorLayoutPen/GCOMMAND_NicheEditorRowPen/GCOMMAND_NicheWorkflowMode/GCOMMAND_DigitalNicheListingsTemplatePtr, DATA_CTASKS_STR_N_1BB9
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
    BNE.S   .state_dispatch

    MOVE.L  NEWGRID_SecondaryWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .state_reset

    SUBQ.L  #3,D0
    BEQ.S   .state_check_entry

    SUBQ.L  #2,D0
    BNE.S   .state_clear

.state_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    BRA.S   .state_clear

.state_check_entry:
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state_process_entries

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .state_clear

.state_process_entries:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.state_clear:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState
    MOVE.L  D0,NEWGRID_SecondarySelectedEntryIndex
    BRA.W   .return_state

.state_dispatch:
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
    CLR.L   DATA_NEWGRID_BSS_LONG_2023
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
    MOVE.B  GCOMMAND_NicheWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case_state2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case_state2_default

.case_state2_handle:
    MOVE.L  GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_NicheEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_NicheEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

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

.case_state2_default:
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
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case_state5_process_entries

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

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

    CMPI.L  #$1,DATA_NEWGRID_BSS_LONG_2023
    BGE.S   .case_state5_post

    SUBQ.L  #5,D0
    BNE.S   .case_state5_post

    MOVE.B  DATA_CTASKS_STR_N_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .case_state5_post

    PEA     49.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2023

.case_state5_post:
    MOVE.B  GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .case_state5_adjust

    TST.L   D6
    BEQ.S   .case_state5_adjust

    CMPI.L  #$1,DATA_NEWGRID_BSS_LONG_2023
    BGE.S   .case_state5_adjust

    PEA     33.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2023

.case_state5_adjust:
    MOVE.L  DATA_NEWGRID_BSS_LONG_2023,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,DATA_NEWGRID_BSS_LONG_2023
    BRA.S   .return_state

.case_state5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_SecondaryWorkflowState

.case_state7:
    MOVE.B  GCOMMAND_NicheWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case_state7_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_state7_default

.case_state7_handle:
    MOVE.L  GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_NicheEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_NicheEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

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

.case_state7_default:
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
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength, _LVOMove, _LVOText,
;   NEWGRID_ValidateSelectionCode
; READS:
;   DATA_SCRIPT_CONST_LONG_210B, NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
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
    JSR     NEWGRID_DrawGridFrame(PC)

    MOVEA.L DATA_SCRIPT_CONST_LONG_210B,A0
    LEA     -128(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -159(A5)
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    PEA     -159(A5)
    PEA     -128(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    BSR.W   NEWGRID_ValidateSelectionCode

    MOVEM.L -192(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameAlt   (Draw alternate grid frame)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: status from NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine,
;   NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop, NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
; READS:
;   NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx, DISPTEXT_ControlMarkerXOffsetPx
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
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    TST.L   D7
    BNE.S   .alt_path

    TST.L   -20(A5)
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-24(A5)
    TST.L   -20(A5)
    BEQ.W   .draw_bevel_bottom

    MOVEQ   #0,D4
    MOVE.W  NEWGRID_RowHeightPx,D4
    TST.L   D0
    BEQ.S   .draw_bevel_alt

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     36(A7),A7
    BRA.W   .store_header_width

.draw_bevel_alt:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(PC)

    LEA     36(A7),A7
    BRA.S   .store_header_width

.draw_bevel_pair:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(PC)

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
;   D0: state (DATA_NEWGRID_CONST_LONG_2024)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, NEWGRID_DrawGridFrameAlt, NEWGRID_DrawGridCell,
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex, NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   DATA_NEWGRID_BSS_WORD_2017, CLOCK_DaySlotIndex
; WRITES:
;   DATA_NEWGRID_CONST_LONG_2024, 32(A3)
; DESC:
;   State machine that draws a single grid entry and updates the frame.
; NOTES:
;   Uses DATA_NEWGRID_CONST_LONG_2024 values 4/5.
;------------------------------------------------------------------------------
NEWGRID_HandleAltGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2024
    BRA.W   .return_state

.state_check:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2024,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_reset

    BRA.W   .force_state4

.state4_begin:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .have_entry_ptrs

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BEQ.S   .use_alt_entry_table

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .have_entry_ptrs

.use_alt_entry_table:
    MOVE.L  -8(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    MOVE.L  D0,D7
    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

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

    MOVE.W  NEWGRID_ColumnWidthPx,D0
    MULU    #3,D0
    MOVEQ   #12,D1
    SUB.L   D1,D0
    PEA     1.W
    PEA     20.W
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    TST.W   DATA_NEWGRID_BSS_WORD_2017
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
    BEQ.S   .state5_draw

    MOVEQ   #4,D0
    BRA.S   .store_state

.state5_draw:
    MOVEQ   #5,D0

.store_state:
    LEA     60(A3),A0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2024
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

.state5_reset:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAlt

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state2

.state5_done:
    MOVEQ   #5,D0

.store_state2:
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2024
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2024

.return_state:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2024,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextEntryWithMarkers   (Find next entry meeting marker criteria)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = start index
;   stack +18: D5 = selector value
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID_ShouldOpenEditor
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans entries to find the next candidate with required marker/flag bits set.
; NOTES:
;   Uses entry flags in 46(A0) and 40(A0).
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

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .return

.scan_loop:
    TST.L   D4
    BNE.W   .scan_done

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
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
    TST.L   -4(A5)
    BEQ.W   .advance_index

    TST.L   -8(A5)
    BEQ.S   .advance_index

    MOVEA.L -4(A5),A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   .advance_index

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     28(A0),A1
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .advance_index

    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .advance_index

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #1,7(A1)
    BNE.S   .check_alt_flags

    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    BTST    #4,D0
    BEQ.S   .advance_index

.check_alt_flags:
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #7,7(A1)
    BNE.S   .advance_index

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
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
;   NEWGRID_DrawEmptyGridMessage, NEWGRID_ValidateSelectionCode,
;   NEWGRID_GetGridModeIndex, NEWGRID_ComputeColumnIndex
; READS:
;   DATA_NEWGRID_BSS_LONG_2025/2026/2027, DATA_CTASKS_STR_Y_1BAF
; WRITES:
;   DATA_NEWGRID_BSS_LONG_2025/2026/2027
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
    BNE.S   .state_dispatch

    MOVEQ   #5,D0
    CMP.L   NEWGRID_AltEntryWorkflowState,D0
    BNE.S   .reset_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleAltGridState

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2026
    BRA.W   .return_state

.state_dispatch:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    CMPI.L  #$6,D0
    BCC.W   .clear_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1_draw_empty-.state_jumptable-2
    DC.W    .clear_state-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2

.case_state0:
    CLR.L   DATA_NEWGRID_BSS_LONG_2025
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_NEWGRID_BSS_LONG_2026,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2026
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
    MOVE.L  DATA_NEWGRID_BSS_LONG_2026,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2026

.case_state5:
    MOVE.L  DATA_NEWGRID_BSS_LONG_2026,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.S   .clear_state

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleAltGridState

    LEA     12(A7),A7
    MOVE.B  DATA_CTASKS_STR_Y_1BAF,D1
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BNE.S   .return_state

    TST.L   D5
    BEQ.S   .adjust_offset

    CMPI.L  #$1,DATA_NEWGRID_BSS_LONG_2025
    BGE.S   .adjust_offset

    PEA     51.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_2025

.adjust_offset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,DATA_NEWGRID_BSS_LONG_2025
    BRA.S   .return_state

.clear_state:
    CLR.L   NEWGRID_AltEntryWorkflowState

.return_state:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextEntryWithAltMarkers   (Find next entry with alt markers)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = start index
;   stack +18: D5 = selector value
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans entries for a different marker/flag combination.
; NOTES:
;   Uses entry flags in 46(A0) and 40(A0).
;------------------------------------------------------------------------------
NEWGRID_FindNextEntryWithAltMarkers:
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .scan_done

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .scan_done

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -14(A5)
    PEA     -10(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.W  D0,-6(A5)
    TST.L   -10(A5)
    BEQ.S   .advance_index

    TST.L   -14(A5)
    BEQ.S   .advance_index

    MOVEA.L -10(A5),A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   .advance_index

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     28(A0),A1
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
    ADDA.W  D5,A1
    BTST    #7,7(A1)
    BNE.S   .advance_index

    MOVE.W  -6(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
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
; FUNC: NEWGRID_DrawStatusMessage   (Draw status message banner)
; ARGS:
;   stack +4: A3 = target view/rastport context
;   stack +10: D7 = time/status value formatted into template
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry, NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3, PARSEINI_JMPTBL_WDISP_SPrintf,
;   NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength, _LVOMove, _LVOText,
;   NEWGRID_ValidateSelectionCode
; READS:
;   GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexMessageTextPen, GCOMMAND_MplexAtTemplatePtr, NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
; DESC:
;   Formats and centers a status message within the grid.
; NOTES:
;   Uses GCOMMAND_MplexAtTemplatePtr as a printf-style format string.
;   This callsite currently performs no local NULL guard on that pointer.
;------------------------------------------------------------------------------
NEWGRID_DrawStatusMessage:
    LINK.W  A5,#-180
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    PEA     33.W
    MOVE.L  GCOMMAND_MplexMessageFramePen,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -163(A5)
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    PEA     -163(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    ; Format string comes from GCOMMAND_MplexAtTemplatePtr.
    MOVE.L  D0,(A7)
    MOVE.L  GCOMMAND_MplexAtTemplatePtr,-(A7)
    PEA     -132(A5)
    MOVE.L  D0,-168(A5)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     80(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  GCOMMAND_MplexMessageTextPen,D0
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

    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    BSR.W   NEWGRID_ValidateSelectionCode

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
;   NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, DISPTEXT_ControlMarkerXOffsetPx, GCOMMAND_MplexDetailRowPen
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
    MOVE.L  GCOMMAND_MplexDetailRowPen,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleDetailGridState   (Handle detailed grid state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = entry index
;   stack +18: D6 = selector
; RET:
;   D0: state (DATA_NEWGRID_CONST_LONG_2028)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID_DrawGridEntry,
;   NEWGRID_DrawGridFrameVariant2, NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   GCOMMAND_MplexDetailLayoutPen, GCOMMAND_MplexDetailLayoutFlag, GCOMMAND_MplexDetailInitialLineIndex
; WRITES:
;   DATA_NEWGRID_CONST_LONG_2028, 32(A3)
; DESC:
;   State machine that formats entry text and redraws the detailed grid view.
; NOTES:
;   Uses DATA_NEWGRID_CONST_LONG_2028 values 4/5.
;------------------------------------------------------------------------------
NEWGRID_HandleDetailGridState:
    LINK.W  A5,#-60
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,-8(A5)
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2028
    BRA.W   .return_state

.state_check:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2028,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_reset

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

    MOVE.L  GCOMMAND_MplexDetailLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.B  GCOMMAND_MplexDetailLayoutFlag,D0
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
    MOVE.L  GCOMMAND_MplexDetailInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    MOVEA.L -4(A5),A0
    MOVEA.L A0,A1
    ADDA.W  #19,A1
    LEA     1(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    PEA     DATA_NEWGRID_FMT_PCT_S_CH_DOT_PCT_S_2029
    PEA     -58(A5)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     60(A3),A0
    PEA     -58(A5)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant2

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .state5_draw

    MOVEQ   #4,D0
    BRA.S   .store_state

.state5_draw:
    MOVEQ   #5,D0

.store_state:
    PEA     2.W
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2028
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_reset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant2

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state2

.state5_done:
    MOVEQ   #5,D0

.store_state2:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2028
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2028

.return_state:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2028,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessScheduleState   (Process schedule/detail state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = row index
;   stack +16: D6 = selector value
; RET:
;   D0: state (NEWGRID_ScheduleWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_HandleGridEditorState, NEWGRID_UpdateGridState,
;   NEWGRID_HandleDetailGridState, NEWGRID_FindNextEntryWithAltMarkers,
;   NEWGRID_DrawStatusMessage, NEWGRID_ValidateSelectionCode,
;   NEWGRID_GetGridModeIndex, NEWGRID_ComputeColumnIndex
; READS:
;   DATA_NEWGRID_BSS_LONG_202A/202B/202C/202D/202E/202F, GCOMMAND_DigitalMplexEnabledFlag/GCOMMAND_MplexSearchRowLimit/GCOMMAND_MplexEditorLayoutPen/GCOMMAND_MplexEditorRowPen/GCOMMAND_MplexWorkflowMode/GCOMMAND_MplexDetailLayoutFlag/GCOMMAND_MplexListingsTemplatePtr
; WRITES:
;   DATA_NEWGRID_BSS_LONG_202A/202B/202C/202D/202E/202F
; DESC:
;   Drives a multi-state schedule/detail workflow using a jump table.
; NOTES:
;   Uses NEWGRID_ScheduleWorkflowState as a 0..7 state index.
;------------------------------------------------------------------------------
NEWGRID_ProcessScheduleState:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  34(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .state_dispatch

    MOVE.L  NEWGRID_ScheduleWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .state_reset

    SUBQ.L  #3,D0
    BEQ.S   .state_check_entry

    SUBQ.L  #2,D0
    BNE.S   .state_clear

.state_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    BRA.S   .state_clear

.state_check_entry:
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state_process_detail

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .state_clear

.state_process_detail:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleDetailGridState

    LEA     12(A7),A7

.state_clear:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    MOVE.L  D0,NEWGRID_SelectedPrimaryEntryIndex
    BRA.W   .return_state

.state_dispatch:
    MOVE.L  NEWGRID_ScheduleWorkflowState,D0
    CMPI.L  #$8,D0
    BCC.W   .state_clear2

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2
    DC.W    .case_state6-.state_jumptable-2
    DC.W    .case_state7-.state_jumptable-2

.case_state0:
    MOVE.B  GCOMMAND_MplexWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .set_mode_flag

    MOVEQ   #70,D2
    CMP.B   D2,D0
    BEQ.S   .set_mode_flag

    MOVEQ   #0,D2
    BRA.S   .store_mode_flag

.set_mode_flag:
    MOVEQ   #1,D2

.store_mode_flag:
    MOVE.L  D2,DATA_NEWGRID_BSS_LONG_202B
    CMP.B   D1,D0
    BEQ.S   .set_alt_flag

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BEQ.S   .set_alt_flag

    MOVEQ   #0,D0
    BRA.S   .store_alt_flag

.set_alt_flag:
    MOVEQ   #1,D0

.store_alt_flag:
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  NEWGRID_ScheduleWorkflowState,-(A7)
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_202C
    BSR.W   NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    CLR.W   NEWGRID_ScheduleRowOffset
    MOVE.L  D0,NEWGRID_SelectedPrimaryEntryIndex

.search_loop:
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .search_done

    MOVE.W  NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    CMP.L   GCOMMAND_MplexSearchRowLimit,D1
    BGE.S   .search_done

    ADDQ.W  #1,NEWGRID_ScheduleRowOffset
    MOVE.L  D7,D1
    ADD.W   NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_SelectedPrimaryEntryIndex
    BRA.S   .search_loop

.search_done:
    MOVEQ   #-1,D0
    CMP.L   NEWGRID_SelectedPrimaryEntryIndex,D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState

.case_state1:
    MOVE.L  D6,D0
    ADD.W   NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawStatusMessage

    ADDQ.W  #8,A7
    CLR.L   DATA_NEWGRID_BSS_LONG_202A
    TST.L   DATA_NEWGRID_BSS_LONG_202B
    BEQ.S   .case_state1_select

    MOVEQ   #2,D0
    BRA.S   .case_state1_store

.case_state1_select:
    MOVEQ   #3,D0

.case_state1_store:
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2:
    TST.L   DATA_NEWGRID_BSS_LONG_202B
    BEQ.S   .case_state2_default

    MOVE.L  GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_MplexEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_MplexEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state2_done

    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2_done:
    CLR.L   DATA_NEWGRID_BSS_LONG_202B
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2_default:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState

.case_state3_or4:
    MOVE.L  D7,D0
    ADD.W   NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,NEWGRID_SelectedPrimaryEntryIndex

.case_state5:
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .case_state5_no_entry

    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case_state5_process_detail

    MOVE.L  D7,D0
    ADD.W   NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.S   .case_state5_post

.case_state5_process_detail:
    MOVE.L  D7,D0
    ADD.W   NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleDetailGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState

.case_state5_post:
    MOVE.B  GCOMMAND_DigitalMplexEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D5
    BEQ.S   .adjust_offset

    CMPI.L  #$1,DATA_NEWGRID_BSS_LONG_202A
    BGE.S   .adjust_offset

    MOVE.B  GCOMMAND_MplexDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .set_selection_code

    MOVEQ   #36,D0
    BRA.S   .store_selection_code

.set_selection_code:
    MOVEQ   #52,D0

.store_selection_code:
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_202A

.adjust_offset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,DATA_NEWGRID_BSS_LONG_202A
    BRA.W   .return_state

.case_state5_no_entry:
    MOVEQ   #6,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState

.case_state6:
    MOVE.L  NEWGRID_SelectedPrimaryEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .case_state6_done

    MOVE.W  NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    CMP.L   GCOMMAND_MplexSearchRowLimit,D1
    BGE.S   .case_state6_done

    ADDQ.W  #1,NEWGRID_ScheduleRowOffset
    MOVE.L  D7,D1
    ADD.W   NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_SelectedPrimaryEntryIndex
    BRA.S   .case_state6

.case_state6_done:
    MOVEQ   #-1,D0
    CMP.L   NEWGRID_SelectedPrimaryEntryIndex,D0
    BNE.S   .case_state6_store

    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.S   .case_state7

.case_state6_store:
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.case_state7:
    TST.L   DATA_NEWGRID_BSS_LONG_202C
    BEQ.S   .case_state7_clear

    MOVE.L  GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_MplexEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_MplexEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state7_done

    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.case_state7_done:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ScheduleWorkflowState
    MOVE.L  D0,DATA_NEWGRID_BSS_LONG_202C
    BRA.S   .return_state

.case_state7_clear:
    CLR.L   NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.state_clear2:
    CLR.L   NEWGRID_ScheduleWorkflowState

.return_state:
    MOVE.L  NEWGRID_ScheduleWorkflowState,D0
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ClearEntryMarkerBits   (Clear entry marker bits uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_SecondaryGroupPresentFlag
; WRITES:
;   entry flag bytes (bit #5 cleared)
; DESC:
;   Walks entry lists and clears marker bits when entries are active.
;------------------------------------------------------------------------------
NEWGRID_ClearEntryMarkerBits:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLE.S   .list2_init

    MOVEQ   #0,D6

.list1_loop:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .list2_init

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list2_init

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .list1_next

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

.list1_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   .list1_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   .list1_clear_flags

.list1_next:
    ADDQ.L  #1,D6
    BRA.S   .list1_loop

.list2_init:
    MOVEQ   #0,D6

.list2_loop:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .return

    TST.B   TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .list2_next

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

.list2_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   .list2_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   .list2_clear_flags

.list2_next:
    ADDQ.L  #1,D6
    BRA.S   .list2_loop

.return:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_InitSelectionWindow   (Init selection window uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, SCRIPT3_JMPTBL_MATH_DivS32
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, CLOCK_DaySlotIndex, GCOMMAND_PpvSelectionWindowMinutes
; WRITES:
;   0(A3)..24(A3)
; DESC:
;   Initializes selection bounds and visible window values.
; NOTES:
;   Scans entries for bit #4 to seed min/max indices.
;------------------------------------------------------------------------------
NEWGRID_InitSelectionWindow:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  A3,D0
    BEQ.W   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)
    TST.W   D7
    BEQ.S   .default_bounds

    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,12(A3)
    MOVE.L  D0,D6

.scan_forward:
    CMP.L   12(A3),D6
    BGE.S   .scan_forward_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .scan_forward_next

    MOVE.L  D6,12(A3)

.scan_forward_next:
    ADDQ.L  #1,D6
    BRA.S   .scan_forward

.scan_forward_done:
    MOVE.L  12(A3),16(A3)
    MOVEQ   #0,D6
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D6

.scan_reverse:
    CMP.L   16(A3),D6
    BLE.S   .store_row

    MOVE.L  D6,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .scan_reverse_next

    MOVE.L  D6,16(A3)

.scan_reverse_next:
    SUBQ.L  #1,D6
    BRA.S   .scan_reverse

.default_bounds:
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,16(A3)

.store_row:
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   .store_window

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   .offset_row

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .store_window

.offset_row:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

.store_window:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    MOVEQ   #29,D0
    ADD.L   GCOMMAND_PpvSelectionWindowMinutes,D0
    MOVEQ   #30,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  20(A3),D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,24(A3)
    MOVEQ   #96,D0
    CMP.W   D0,D1
    BLE.S   .clamp_done

    MOVE.W  D0,24(A3)

.clamp_done:
    ADDQ.W  #1,24(A3)

.return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateSelectionFromInput   (Update selection from input uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: selection found flag (0/1)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_ClearEntryMarkerBits, NEWGRID_InitSelectionWindow, NEWGRID_UpdatePresetEntry,
;   NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID_ShouldOpenEditor, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState
; READS:
;   NEWGRID_SelectionScanEntryIndex/2031, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag, GCOMMAND_PpvSelectionWindowMinutes
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

    BRA.S   .state_unknown

.state0_init:
    MOVE.L  12(A3),NEWGRID_SelectionScanEntryIndex
    MOVE.W  22(A3),D0
    MOVE.W  D0,NEWGRID_SelectionScanRow
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7
    BRA.S   .post_state

.state4_advance:
    ADDQ.L  #1,NEWGRID_SelectionScanEntryIndex
    BRA.S   .post_state

.state_unknown:
    MOVEQ   #1,D6

.post_state:
    TST.L   D6
    BNE.W   .return

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
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

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
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
    JSR     NEWGRID_ShouldOpenEditor(PC)

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
    MOVE.L  GCOMMAND_PpvSelectionToleranceMinutes,-(A7)
    MOVE.L  GCOMMAND_PpvSelectionWindowMinutes,-(A7)
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
    BSR.W   NEWGRID_InitSelectionWindow

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
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, NEWGRID_ValidateSelectionCode
; READS:
;   GCOMMAND_PpvMessageTextPen, GCOMMAND_PpvMessageFramePen, GCOMMAND_PPVPeriodTemplatePtr, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
; DESC:
;   Centers a fixed message string inside the grid frame.
; NOTES:
;   Reads message text directly from GCOMMAND_PPVPeriodTemplatePtr.
;   This routine currently assumes that pointer is non-NULL.
;------------------------------------------------------------------------------
NEWGRID_DrawGridMessageAlt:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    PEA     33.W
    MOVE.L  GCOMMAND_PpvMessageFramePen,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  GCOMMAND_PpvMessageTextPen,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    ; Source message pointer: expected to be valid/NUL-terminated.
    MOVEA.L GCOMMAND_PPVPeriodTemplatePtr,A0

.scan_message_end:
    TST.B   (A0)+
    BNE.S   .scan_message_end

    SUBQ.L  #1,A0
    SUBA.L  GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVE.L  A0,D7

.fit_message_width:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,16(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A0,12(A7)
    MOVE.L  D7,D0
    MOVEA.L GCOMMAND_PPVPeriodTemplatePtr,A0
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
    MOVEA.L GCOMMAND_PPVPeriodTemplatePtr,A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     68.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

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
;   NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, DISPTEXT_ControlMarkerXOffsetPx, GCOMMAND_PpvShowtimesRowPen
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
    MOVE.L  GCOMMAND_PpvShowtimesRowPen,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_InitShowtimeBuckets   (Init showtime buckets uncertain)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   none
; READS:
;   NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Initializes pointer tables for showtime bucket storage.
;------------------------------------------------------------------------------
NEWGRID_InitShowtimeBuckets:
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

.bucket_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     NEWGRID_ShowtimeBucketEntryTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  A2,(A0)
    ADDA.L  D0,A1
    CLR.L   4(A1)
    ADDQ.L  #1,D7
    BRA.S   .bucket_loop

.return:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ResetShowtimeBuckets   (Reset showtime buckets)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   NEWGRID_ShowtimeBucketCount, NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Clears bucket count and reinitializes bucket records.
;------------------------------------------------------------------------------
NEWGRID_ResetShowtimeBuckets:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimeBucketCount
    MOVE.L  D0,D7

.init_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #$3100,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    CLR.L   -(A7)
    MOVE.L  A1,16(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,4(A0)
    ADDQ.L  #1,D7
    BRA.S   .init_loop

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AddShowtimeBucketEntry   (Insert showtime bucket entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: 1 if inserted, 0 if not
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_STR_FindCharPtr, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   NEWGRID_ShowtimeBucketEntryTable, NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount
; WRITES:
;   NEWGRID_ShowtimeBucketEntryTable, NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount
; DESC:
;   Adds an entry into the sorted bucket list if capacity allows.
; NOTES:
;   Uses insertion-style shifting to keep buckets sorted.
;------------------------------------------------------------------------------
NEWGRID_AddShowtimeBucketEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    CLR.L   -20(A5)
    PEA     58.W
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    MOVEA.L D0,A0
    LEA     1(A0),A1
    MOVE.L  A1,(A7)
    MOVE.L  A1,-4(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    MOVE.L  D7,D0
    ASL.L   #8,D0
    ADD.L   D0,D6
    MOVE.L  NEWGRID_ShowtimeBucketCount,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.W   .return

    ASL.L   #3,D0
    LEA     NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,32(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,4(A0)
    MOVE.L  NEWGRID_ShowtimeBucketCount,D5

.find_insert_pos:
    TST.L   D5
    BLE.S   .check_insert

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_2337,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BGE.S   .check_insert

    SUBQ.L  #1,D5
    BRA.S   .find_insert_pos

.check_insert:
    TST.L   D5
    BEQ.S   .shift_needed

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_2337,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BEQ.S   .return

.shift_needed:
    MOVE.L  NEWGRID_ShowtimeBucketCount,D4

.shift_loop:
    CMP.L   D5,D4
    BLE.S   .store_bucket

    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_2337,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),(A0)
    SUBQ.L  #1,D4
    BRA.S   .shift_loop

.store_bucket:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  NEWGRID_ShowtimeBucketCount,D0
    MOVE.L  D0,D1
    ASL.L   #3,D1
    LEA     NEWGRID_ShowtimeBucketEntryTable,A1
    ADDA.L  D1,A1
    MOVE.L  A1,(A0)
    ADDQ.L  #1,NEWGRID_ShowtimeBucketCount
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.return:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AppendShowtimeBuckets   (Append showtime buckets to buffer)
; ARGS:
;   stack +8: A3 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount, DATA_NEWGRID_STR_VALUE_2032
; WRITES:
;   output buffer contents
; DESC:
;   Appends each bucket’s data into the output buffer.
;------------------------------------------------------------------------------
NEWGRID_AppendShowtimeBuckets:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L NEWGRID_ShowtimeBucketPtrTable,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D7

.append_loop:
    CMP.L   NEWGRID_ShowtimeBucketCount,D7
    BGE.S   .return

    PEA     DATA_NEWGRID_STR_VALUE_2032
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .append_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_BuildShowtimesText   (Build showtimes text uncertain)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
;   stack +16: A1 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, TEXTDISP_FormatEntryTimeForIndex, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3,
;   NEWGRID_ResetShowtimeBuckets, NEWGRID_AddShowtimeBucketEntry,
;   NEWGRID_AppendShowtimeBuckets, PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_PrimaryGroupEntryCount, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvShowtimesRowSpan, NEWGRID_ShowtimeBucketEntryTable..2339
; WRITES:
;   output buffer contents, NEWGRID_ShowtimeBucketCount
; DESC:
;   Scans entries and builds a formatted showtimes string.
; NOTES:
;   Performs multiple string comparisons to coalesce matching showtime entries.
;------------------------------------------------------------------------------
NEWGRID_BuildShowtimesText:
    LINK.W  A5,#-108
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   (A2)
    BEQ.W   .return

    TST.L   4(A2)
    BEQ.W   .return

    MOVEA.L (A2),A0
    BTST    #4,47(A0)
    BEQ.W   .return

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .return

    TST.L   16(A5)
    BEQ.W   .return

    MOVEA.L 16(A5),A1
    CLR.B   (A1)
    MOVE.W  20(A2),D6
    MOVE.L  D6,D5
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .adjust_row

    SUBI.W  #$30,D6

.adjust_row:
    MOVEA.L 4(A2),A0
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-54(A5)
    MOVE.L  A6,D0
    BEQ.S   .clear_time_ptr

    TST.B   (A6)
    BEQ.S   .clear_time_ptr

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .check_time_prefix

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .check_time_prefix

    MOVEQ   #8,D0
    BRA.S   .store_time_offset

.check_time_prefix:
    MOVEQ   #0,D0

.store_time_offset:
    ADD.L   D0,-54(A5)
    BRA.S   .fetch_fields

.clear_time_ptr:
    CLR.L   -54(A5)

.fetch_fields:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-58(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  4(A2),(A7)
    MOVE.L  D1,-(A7)
    PEA     -49(A5)
    MOVE.L  D0,-70(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     56(A7),A7
    MOVE.L  #$264,-16(A5)
    TST.L   -62(A5)
    BEQ.S   .measure_comma_space

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   .measure_comma_space

    LEA     60(A3),A1

.scan_suffix_end:
    TST.B   (A0)+
    BNE.S   .scan_suffix_end

    SUBQ.L  #1,A0
    SUBA.L  -62(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -62(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    LEA     60(A3),A0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    LEA     Global_STR_SINGLE_SPACE_3,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

.measure_comma_space:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    LEA     Global_STR_COMMA_AND_SINGLE_SPACE_1,A0
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-20(A5)
    TST.L   -54(A5)
    BEQ.W   .return

    BSR.W   NEWGRID_ResetShowtimeBuckets

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  12(A2),D1
    CMP.L   D0,D1
    BGT.S   .clamp_start_index

    TST.L   D1
    BPL.S   .clamp_start_done

.clamp_start_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,12(A2)

.clamp_start_done:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  16(A2),D1
    CMP.L   D0,D1
    BGT.S   .clamp_end_index

    TST.L   D1
    BPL.S   .clamp_end_done

.clamp_end_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,16(A2)

.clamp_end_done:
    MOVE.W  22(A2),D0
    EXT.L   D0
    ADD.L   GCOMMAND_PpvShowtimesRowSpan,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,-8(A5)
    MOVEQ   #97,D1
    CMP.W   D1,D0
    BLE.S   .setup_row_range

    MOVE.W  D1,-8(A5)

.setup_row_range:
    MOVE.W  22(A2),D6

.row_loop:
    CMP.W   -8(A5),D6
    BGE.W   .ensure_showing_at_prefix

    MOVE.L  -16(A5),D0
    TST.L   D0
    BPL.S   .row_check_width

    CMP.W   24(A2),D6
    BGE.W   .ensure_showing_at_prefix

.row_check_width:
    MOVE.L  12(A2),-12(A5)

.col_loop:
    MOVE.L  -12(A5),D0
    CMP.L   16(A2),D0
    BGE.W   .row_next

    MOVE.L  -16(A5),D1
    TST.L   D1
    BPL.S   .col_check_width

    CMP.W   24(A2),D6
    BGE.W   .row_next

.col_check_width:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -98(A5)
    PEA     -94(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D7
    TST.L   -94(A5)
    BEQ.W   .col_next

    TST.L   -98(A5)
    BEQ.W   .col_next

    MOVEA.L -94(A5),A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.W   .col_next

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.W   .col_next

    CMP.W   22(A2),D6
    BNE.S   .match_adjust

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  GCOMMAND_PpvSelectionToleranceMinutes,(A7)
    MOVE.L  GCOMMAND_PpvSelectionWindowMinutes,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  -94(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

    LEA     28(A7),A7
    TST.L   D0
    BNE.S   .match_adjust

    SUBA.L  A0,A0
    MOVE.L  A0,-98(A5)

.match_adjust:
    TST.L   -98(A5)
    BEQ.W   .col_next

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.W   .col_next

    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    MOVEQ   #-96,D0
    AND.B   7(A0),D0
    TST.B   D0
    BNE.W   .col_next

    MOVEA.L -94(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .col_next

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A0,A6
    ADDA.L  D0,A6
    MOVEA.L 56(A6),A6
    MOVEQ   #40,D1
    CMP.B   (A6),D1
    BNE.S   .time_prefix_check

    ADDA.L  D0,A0
    MOVEA.L 56(A0),A6
    ADDQ.L  #3,A6
    MOVEQ   #58,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_check

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done

.time_prefix_check:
    MOVEQ   #0,D0

.time_prefix_done:
    MOVEA.L 56(A1),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  A0,-74(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-78(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-82(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-86(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-90(A5)
    TST.L   -74(A5)
    BEQ.W   .col_next

    MOVEA.L -54(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.W   .col_next

.compare_title:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_title

    BNE.W   .col_next

    MOVEA.L -58(A5),A0
    MOVEA.L -78(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_subtitle

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_title_loop

    BNE.W   .col_next

.compare_subtitle:
    MOVEA.L -62(A5),A0
    MOVEA.L -82(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_genre

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_subtitle_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_subtitle_loop

    BNE.W   .col_next

.compare_genre:
    MOVEA.L -66(A5),A0
    MOVEA.L -86(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_rating

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_genre_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_genre_loop

    BNE.W   .col_next

.compare_rating:
    MOVEA.L -70(A5),A0
    MOVEA.L -90(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .mark_and_append

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_rating_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_rating_loop

    BNE.W   .col_next

.mark_and_append:
    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    BSET    #5,7(A0)
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.W   .col_next

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   .append_entry_text

    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-28(A5)
    BSR.W   NEWGRID_AddShowtimeBucketEntry

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A1
    MOVEA.L A1,A6

.measure_showtimes_prefix:
    TST.B   (A6)+
    BNE.S   .measure_showtimes_prefix

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

.measure_entry_text:
    TST.B   (A1)+
    BNE.S   .measure_entry_text

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)

.append_entry_text:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  -98(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -49(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    LEA     16(A7),A7
    LEA     60(A3),A0
    MOVEA.L D0,A1

.measure_entry_text2:
    TST.B   (A1)+
    BNE.S   .measure_entry_text2

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  D0,-28(A5)
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L D0,A0
    MOVE.L  28(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    MOVEM.L D1,-24(A5)
    MOVE.L  -16(A5),D0
    CMP.L   D1,D0
    BLT.S   .measure_showtime_text

    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .append_showtime_entry

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #48,D1
    ADD.L   D1,D0
    BRA.S   .append_showtime_entry2

.append_showtime_entry:
    MOVE.L  D7,D0
    EXT.L   D0

.append_showtime_entry2:
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    BSR.W   NEWGRID_AddShowtimeBucketEntry

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .col_next

.measure_showtime_text:
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

.measure_showtime_text2:
    TST.B   (A1)+
    BNE.S   .measure_showtime_text2

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

.col_next:
    ADDQ.L  #1,-12(A5)
    BRA.W   .col_loop

.row_next:
    ADDQ.W  #1,D6
    BRA.W   .row_loop

.ensure_showing_at_prefix:
    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   .append_showing_at

    LEA     Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  D0,(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  D0,-28(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_genre

.append_showing_at:
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_AppendShowtimeBuckets

    ADDQ.W  #4,A7

.append_genre:
    TST.L   -62(A5)
    BEQ.S   .return

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    PEA     DATA_NEWGRID_SPACE_VALUE_2035
    MOVE.L  16(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -62(A5),(A7)
    MOVE.L  16(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleShowtimesState   (Handle showtimes grid state uncertain)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
; RET:
;   D0: state (DATA_NEWGRID_CONST_LONG_2036)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_BuildShowtimesText, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   NEWGRID_DrawGridFrameVariant3, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   DATA_NEWGRID_CONST_LONG_2036, GCOMMAND_PpvShowtimesLayoutPen, GCOMMAND_PpvShowtimesInitialLineIndex, GCOMMAND_PpvDetailLayoutFlag
; WRITES:
;   DATA_NEWGRID_CONST_LONG_2036, 32(A3)
; DESC:
;   State machine that draws showtimes/details in a grid view.
;------------------------------------------------------------------------------
NEWGRID_HandleShowtimesState:
    LINK.W  A5,#-132
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2036
    BRA.W   .return_state

.state_check:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2036,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_reset

    BRA.W   .force_state4

.state4_begin:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    MOVE.L  GCOMMAND_PpvShowtimesLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D7
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .adjust_row

    SUBI.W  #$30,D7

.adjust_row:
    MOVE.B  GCOMMAND_PpvDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_draw:
    MOVE.L  GCOMMAND_PpvShowtimesInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    PEA     -130(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_BuildShowtimesText

    LEA     60(A3),A0
    PEA     -130(A5)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant3

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .store_state

    MOVEQ   #4,D0
    BRA.S   .store_state2

.store_state:
    MOVEQ   #5,D0

.store_state2:
    PEA     2.W
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2036
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_reset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant3

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state3

.state5_done:
    MOVEQ   #5,D0

.store_state3:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2036
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_2036

.return_state:
    MOVE.L  DATA_NEWGRID_CONST_LONG_2036,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessShowtimesWorkflow   (Process showtimes workflow uncertain)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
; RET:
;   D0: state (NEWGRID_ShowtimesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_HandleGridEditorState, NEWGRID_UpdateGridState,
;   NEWGRID_HandleShowtimesState, NEWGRID_InitSelectionWindow,
;   NEWGRID_UpdateSelectionFromInput, NEWGRID_DrawGridMessageAlt,
;   NEWGRID_ClearEntryMarkerBits, NEWGRID_ValidateSelectionCode,
;   NEWGRID_GetGridModeIndex, NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_ShowtimesWorkflowState/2038, DATA_WDISP_BSS_LONG_232F, GCOMMAND_DigitalPpvEnabledFlag, GCOMMAND_PpvShowtimesWorkflowMode, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen
; WRITES:
;   NEWGRID_ShowtimesWorkflowState/2038
; DESC:
;   Multi-state handler for showtimes selection and detail views.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_ProcessShowtimesWorkflow:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.W   .state_dispatch

    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .state_reset

    SUBQ.L  #3,D0
    BEQ.S   .state_check_entry

    SUBQ.L  #2,D0
    BNE.S   .state_clear

.state_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .state_clear

.state_check_entry:
    MOVE.L  DATA_WDISP_BSS_LONG_232F,-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state_process_detail

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .state_clear

.state_process_detail:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.state_clear:
    CLR.L   -(A7)
    PEA     DATA_WDISP_BSS_LONG_232F
    BSR.W   NEWGRID_InitSelectionWindow

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.state_dispatch:
    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
    CMPI.L  #$8,D0
    BCC.W   .state_clear2

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2
    DC.W    .state_clear2-.state_jumptable-2
    DC.W    .case_state6-.state_jumptable-2

.case_state0:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     DATA_WDISP_BSS_LONG_232F
    BSR.W   NEWGRID_InitSelectionWindow

    PEA     DATA_WDISP_BSS_LONG_232F
    MOVE.L  NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInput

    LEA     16(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state1:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridMessageAlt

    ADDQ.W  #4,A7
    CLR.L   NEWGRID_ShowtimesColumnAdjust
    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case_state2:
    MOVE.B  GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case2_default

.case2_handle:
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case2_done

    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_default:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state3_or4:
    PEA     DATA_WDISP_BSS_LONG_232F
    MOVE.L  NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInput

    ADDQ.W  #8,A7
    MOVEQ   #1,D6

.case_state5:
    TST.L   DATA_WDISP_BSS_LONG_232F
    BEQ.W   .case5_no_entry

    MOVE.L  DATA_WDISP_BSS_LONG_232F,-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case5_update

    MOVE.W  DATA_WDISP_BSS_LONG_2331,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_2330,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .case5_post

.case5_update:
    PEA     DATA_WDISP_BSS_LONG_232F
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case5_post:
    MOVE.B  GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D6
    BEQ.S   .adjust_offset

    CMPI.L  #$1,NEWGRID_ShowtimesColumnAdjust
    BGE.S   .adjust_offset

    PEA     53.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesColumnAdjust

.adjust_offset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_ShowtimesColumnAdjust
    BRA.S   .return_state

.case5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state6:
    MOVE.B  GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case6_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case6_clear

.case6_handle:
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case6_done

    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_done:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_clear:
    CLR.L   NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.state_clear2:
    CLR.L   NEWGRID_ShowtimesWorkflowState

.return_state:
    TST.L   NEWGRID_ShowtimesWorkflowState
    BNE.S   .maybe_clear_markers

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7

.maybe_clear_markers:
    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestModeFlagActive   (Test mode flag active uncertain)
; ARGS:
;   stack +8: D7 = mode selector (0/1)
; RET:
;   D0: 1 if flag set, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   none
; READS:
;   DATA_CTASKS_STR_Y_1BAE, DATA_CTASKS_STR_N_1BB1
; DESC:
;   Returns whether the corresponding global flag is set for the mode.
;------------------------------------------------------------------------------
NEWGRID_TestModeFlagActive:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   D7
    BNE.S   .check_mode1

    MOVE.B  DATA_CTASKS_STR_Y_1BAE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return_false

    MOVE.B  DATA_CTASKS_STR_N_1BB1,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.return_false:
    MOVEQ   #0,D0
    BRA.S   .return

.return_true:
    MOVEQ   #1,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestEntrySelectable   (Test entry selectable uncertain)
; ARGS:
;   stack +8: A3 = entry header
;   stack +12: A2 = entry data
;   stack +16: D7 = mode selector (0/1)
; RET:
;   D0: 1 if selectable, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2
; READS:
;   27(A3), 40(A3)
; DESC:
;   Checks entry flags and mode rules to decide if selection is allowed.
;------------------------------------------------------------------------------
NEWGRID_TestEntrySelectable:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  28(A7),D7
    MOVEQ   #0,D6
    TST.L   D7
    BEQ.S   .check_args

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return

.check_args:
    MOVE.L  A3,D0
    BEQ.S   .set_false

    MOVE.L  A2,D0
    BEQ.S   .set_false

    BTST    #7,40(A3)
    BEQ.S   .set_false

    TST.L   D7
    BNE.S   .check_mode1

    BTST    #2,27(A3)
    BNE.S   .set_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .set_false

    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_false

.set_true:
    MOVEQ   #1,D1
    BRA.S   .store_result

.set_false:
    MOVEQ   #0,D1

.store_result:
    MOVE.L  D1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ClearMarkersIfSelectable   (Clear markers if selectable)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID_TestEntrySelectable
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_SecondaryGroupPresentFlag
; WRITES:
;   entry flag bytes (bit #5 cleared)
; DESC:
;   Clears marker bits for entries that pass selection checks.
;------------------------------------------------------------------------------
NEWGRID_ClearMarkersIfSelectable:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   .list1_done

    MOVEQ   #0,D5

.list1_loop:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .list1_done

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list1_done

    PEA     1.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list1_next

    MOVEQ   #1,D4

.list1_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list1_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list1_clear_flags

.list1_next:
    ADDQ.L  #1,D5
    BRA.S   .list1_loop

.list1_done:
    MOVEQ   #0,D5

.list2_loop:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .return

    TST.B   TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list2_next

    MOVEQ   #1,D4

.list2_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list2_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list2_clear_flags

.list2_next:
    ADDQ.L  #1,D5
    BRA.S   .list2_loop

.return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_InitSelectionWindowAlt   (Init selection window alt)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   CLOCK_DaySlotIndex, DATA_CTASKS_CONST_BYTE_1BA7, DATA_CTASKS_CONST_BYTE_1BBC
; WRITES:
;   0(A3)..24(A3)
; DESC:
;   Initializes selection bounds using an alternate mode offset.
;------------------------------------------------------------------------------
NEWGRID_InitSelectionWindowAlt:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  A3,D0
    BEQ.S   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    CLR.L   8(A3)
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   .compute_bounds

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   .adjust_row

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .compute_bounds

.adjust_row:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

.compute_bounds:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    TST.L   D6
    BNE.S   .mode_offset

    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA7,D0
    EXT.W   D0
    EXT.L   D0
    BRA.S   .mode_offset_done

.mode_offset:
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BBC,D0
    EXT.W   D0
    EXT.L   D0

.mode_offset_done:
    MOVE.L  D0,D5
    MOVE.W  20(A3),D0
    EXT.L   D0
    ADD.L   D5,D0
    MOVE.W  D0,24(A3)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   .clamp_end

    MOVE.W  D1,24(A3)

.clamp_end:
    ADDQ.W  #1,24(A3)

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateSelectionFromInputAlt   (Update selection alt uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: selection found flag (0/1)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_ClearMarkersIfSelectable, NEWGRID_TestEntrySelectable,
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility
; READS:
;   DATA_NEWGRID_BSS_LONG_2039/203A, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
; WRITES:
;   DATA_NEWGRID_BSS_LONG_2039/203A, selection state fields
; DESC:
;   Alternate selection state machine with a jump-table dispatch.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_UpdateSelectionFromInputAlt:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   .state_default

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .state_default-.state_jumptable-2
    DC.W    .case_state3_or5-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3_or5-.state_jumptable-2

.case_state0:
    CLR.L   (DATA_NEWGRID_BSS_LONG_2039).L
    MOVE.W  22(A3),D0
    MOVE.W  D0,DATA_NEWGRID_BSS_WORD_203A
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7
    BRA.S   .post_state

.case_state1:
    ADDQ.L  #1,DATA_NEWGRID_BSS_LONG_2039
    MOVE.W  22(A3),DATA_NEWGRID_BSS_WORD_203A
    BRA.S   .post_state

.case_state2:
    ADDQ.W  #1,DATA_NEWGRID_BSS_WORD_203A
    BRA.S   .post_state

.case_state3_or5:
    MOVEQ   #1,D5
    BRA.S   .post_state

.state_default:
    MOVEQ   #5,D7

.post_state:
    TST.L   D5
    BNE.W   .maybe_clear_state

.scan_loop:
    TST.L   D5
    BNE.W   .finalize_selection

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  DATA_NEWGRID_BSS_LONG_2039,D1
    CMP.L   D0,D1
    BGE.W   .finalize_selection

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .finalize_selection

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.W   .finalize_selection

    MOVE.W  DATA_NEWGRID_BSS_WORD_203A,D0
    EXT.L   D0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    MOVE.L  D6,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.W   .scan_reset

.entry_loop:
    TST.L   D5
    BNE.W   .scan_reset

    MOVE.W  DATA_NEWGRID_BSS_WORD_203A,D0
    TST.W   D0
    BLE.W   .scan_reset

    CMP.W   24(A3),D0
    BGE.W   .scan_reset

    MOVEQ   #49,D1
    CMP.W   D1,D0
    BNE.S   .adjust_index

    EXT.L   D0
    MOVE.L  DATA_NEWGRID_BSS_LONG_2039,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D4
    BRA.S   .after_adjust

.adjust_index:
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    CMP.W   D1,D4
    BLE.S   .after_adjust

    SUBI.W  #$30,D4

.after_adjust:
    TST.L   -4(A5)
    BEQ.W   .entry_loop_next

    TST.L   -8(A5)
    BEQ.W   .entry_loop_next

    MOVE.W  DATA_NEWGRID_BSS_WORD_203A,D0
    CMP.W   22(A3),D0
    BNE.S   .check_flags

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4

.check_flags:
    TST.W   D4
    BLE.W   .set_found_false

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .set_found_false

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D4,A1
    BTST    #5,7(A1)
    BNE.S   .set_found_false

    MOVEA.L A0,A1
    ADDA.W  DATA_NEWGRID_BSS_WORD_203A,A1
    BTST    #7,7(A1)
    BNE.S   .set_found_false

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   .set_found_false

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  CONFIG_TimeWindowMinutes,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .set_found_false

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .mark_match

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .set_found_false

.mark_match:
    MOVEQ   #1,D1
    BRA.S   .store_found

.set_found_false:
    MOVEQ   #0,D1

.store_found:
    MOVE.L  D1,D5

.entry_loop_next:
    TST.L   D5
    BNE.W   .entry_loop

    ADDQ.W  #1,DATA_NEWGRID_BSS_WORD_203A
    BRA.W   .entry_loop

.scan_reset:
    TST.L   D5
    BNE.W   .scan_loop

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .advance_row

    MOVEQ   #5,D7
    BRA.W   .scan_loop

.advance_row:
    MOVE.W  22(A3),DATA_NEWGRID_BSS_WORD_203A
    ADDQ.L  #1,DATA_NEWGRID_BSS_LONG_2039
    BRA.W   .scan_loop

.finalize_selection:
    TST.L   D5
    BEQ.S   .maybe_clear_state

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.S   .maybe_clear_state

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  DATA_NEWGRID_BSS_LONG_2039,8(A3)
    CMPI.W  #'0',DATA_NEWGRID_BSS_WORD_203A
    BLE.S   .set_offset_flag

    MOVEQ   #49,D0
    CMP.W   D0,D4
    BGE.S   .set_offset_flag

    MOVEQ   #48,D0
    BRA.S   .apply_offset

.set_offset_flag:
    MOVEQ   #0,D0

.apply_offset:
    MOVE.L  D4,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,20(A3)
    MOVEA.L -8(A5),A0
    ADDA.W  D4,A0
    BSET    #5,7(A0)

.maybe_clear_state:
    TST.L   D5
    BNE.S   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AppendShowtimesForRow   (Append showtimes for row uncertain)
; ARGS:
;   stack +12: A3 = selection state
;   stack +16: A2 = output buffer
;   stack +20: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility, TEXTDISP_FormatEntryTimeForIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3,
;   PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   CONFIG_TimeWindowMinutes, DATA_NEWGRID_STR_VALUE_203B
; WRITES:
;   output buffer contents
; DESC:
;   Scans rows and appends matching showtime strings into the buffer.
; NOTES:
;   Performs multiple field comparisons to coalesce identical showtimes.
;------------------------------------------------------------------------------
NEWGRID_AppendShowtimesForRow:
    LINK.W  A5,#-84
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 12(A5),A3
    MOVEA.L 16(A5),A2
    MOVE.L  20(A5),D7
    CLR.B   (A2)
    MOVE.W  20(A3),D5
    TST.L   (A3)
    BEQ.W   .return

    TST.L   4(A3)
    BEQ.W   .return

    MOVE.L  A2,D0
    BEQ.W   .return

    TST.W   D5
    BLE.W   .return

    MOVEQ   #97,D0
    CMP.W   D0,D5
    BGE.W   .return

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .adjust_row_index

    SUBI.W  #$30,D5

.adjust_row_index:
    MOVEA.L 4(A3),A0
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-36(A5)
    MOVE.L  A6,D0
    BEQ.W   .return

    TST.B   (A6)
    BEQ.W   .return

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_default

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .time_prefix_default

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done

.time_prefix_default:
    MOVEQ   #0,D0

.time_prefix_done:
    ADD.L   D0,-36(A5)
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A3),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-40(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-44(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-48(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-52(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .mode_flag_check

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .mode_flag_check

    MOVEQ   #1,D1
    BRA.S   .mode_flag_store

.mode_flag_check:
    MOVEQ   #0,D1

.mode_flag_store:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  4(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    MOVE.B  D1,-53(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     12(A7),A7
    MOVE.L  (A3),-80(A5)
    MOVE.L  4(A3),-84(A5)
    MOVEQ   #32,D0
    ADD.W   20(A3),D0
    MOVEM.W D0,-6(A5)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   .compute_bounds

    MOVE.W  D1,-6(A5)

.compute_bounds:
    ADDQ.W  #1,-6(A5)
    MOVE.W  20(A3),D5
    ADDQ.W  #1,D5

.row_loop:
    CMP.W   -6(A5),D5
    BGE.W   .post_loop

    MOVEQ   #49,D0
    CMP.W   D0,D5
    BNE.S   .row_fetch_entry

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  8(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -84(A5)
    PEA     -80(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7

.row_fetch_entry:
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .row_direct_index

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .row_index_ready

.row_direct_index:
    MOVE.L  D5,D0
    EXT.L   D0

.row_index_ready:
    MOVE.L  D0,D6
    TST.L   -80(A5)
    BEQ.W   .row_next

    TST.L   -84(A5)
    BEQ.W   .row_next

    MOVEA.L -80(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .row_next

    MOVEA.L -84(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #5,7(A1)
    BNE.W   .row_next

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   56(A1)
    BEQ.W   .row_next

    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #7,7(A1)
    BNE.W   .row_next

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-58(A5)
    MOVE.L  A6,D0
    BEQ.S   .fetch_row_fields

    TST.B   (A6)
    BEQ.S   .fetch_row_fields

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_check2

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .time_prefix_check2

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done2

.time_prefix_check2:
    MOVEQ   #0,D0

.time_prefix_done2:
    ADD.L   D0,-58(A5)

.fetch_row_fields:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -80(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-70(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-74(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .mode_flag2_false

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -84(A5),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .mode_flag2_false

    MOVEQ   #1,D1
    BRA.S   .mode_flag2_store

.mode_flag2_false:
    MOVEQ   #0,D1

.mode_flag2_store:
    MOVE.B  D1,-75(A5)
    TST.L   -58(A5)
    BEQ.W   .row_next

    MOVEA.L -36(A5),A0
    MOVEA.L -58(A5),A1
    CMPA.L  A0,A1
    BEQ.W   .row_next

.compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_title_loop

    BNE.W   .row_next

    MOVE.B  -53(A5),D0
    CMP.B   D1,D0
    BNE.W   .row_next

    MOVEA.L -40(A5),A0
    MOVEA.L -62(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field2_loop

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field1_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field1_loop

    BNE.W   .row_next

.compare_field2_loop:
    MOVEA.L -44(A5),A0
    MOVEA.L -66(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field4

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field3_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field3_loop

    BNE.W   .row_next

.compare_field4:
    MOVEA.L -48(A5),A0
    MOVEA.L -70(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field4_done

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field4_loop2:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field4_loop2

    BNE.W   .row_next

.compare_field4_done:
    MOVEA.L -52(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .append_prefix_check

    MOVE.L  A0,D0
    BEQ.S   .row_next

    MOVE.L  A1,D0
    BEQ.S   .row_next

.compare_field4_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .row_next

    TST.B   D0
    BNE.S   .compare_field4_loop

    BNE.S   .row_next

.append_prefix_check:
    TST.B   (A2)
    BNE.S   .append_showtime

    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -31(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_showtime:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -84(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -31(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    PEA     DATA_NEWGRID_STR_VALUE_203B
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -10(A5),(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     28(A7),A7
    MOVEA.L -84(A5),A0
    ADDA.W  D6,A0
    BSET    #5,7(A0)

.row_next:
    ADDQ.W  #1,D5
    BRA.W   .row_loop

.post_loop:
    TST.B   (A2)
    BNE.S   .return

    LEA     Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -31(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawShowtimesPrompt   (Draw showtimes prompt uncertain)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = output buffer
;   stack +16: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3, NEWGRID2_JMPTBL_STRING_AppendN, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, NEWGRID_ValidateSelectionCode
; READS:
;   DATA_SCRIPT_CONST_LONG_2109, DATA_SCRIPT_CONST_LONG_210D, DATA_SCRIPT_CONST_LONG_210F, NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
; WRITES:
;   output buffer contents, 32(A3), 52(A3)
; DESC:
;   Builds a prompt string and centers it inside a grid frame.
;------------------------------------------------------------------------------
NEWGRID_DrawShowtimesPrompt:
    LINK.W  A5,#-168
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  A2,D0
    BEQ.W   .return

    LEA     19(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    LEA     1(A2),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-4(A5)
    MOVE.L  A0,-8(A5)
    JSR     NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   D7
    BNE.S   .copy_prompt_b

    MOVEA.L DATA_SCRIPT_CONST_LONG_210D,A0
    LEA     -136(A5),A1

.copy_prompt_a:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_a

    BRA.S   .prompt_done

.copy_prompt_b:
    MOVEA.L DATA_SCRIPT_CONST_LONG_2109,A0
    LEA     -136(A5),A1

.copy_prompt_b_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_b_loop

.prompt_done:
    MOVEA.L -4(A5),A0

.measure_prompt:
    TST.B   (A0)+
    BNE.S   .measure_prompt

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     -136(A5)
    JSR     NEWGRID2_JMPTBL_STRING_AppendN(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.S   .draw_frame

    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .draw_frame

    MOVE.L  DATA_SCRIPT_CONST_LONG_210F,-(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .append_suffix

    MOVEA.L -8(A5),A0
    LEA     -146(A5),A1

.copy_suffix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix

    CLR.B   -144(A5)
    PEA     -146(A5)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     DATA_NEWGRID_STR_DASH_203C
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -8(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    BRA.S   .draw_frame

.append_suffix:
    MOVE.L  -8(A5),-(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.draw_frame:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -136(A5),A6
    MOVE.L  A0,80(A7)
    MOVEA.L A6,A0

.measure_text:
    TST.B   (A0)+
    BNE.S   .measure_text

    SUBQ.L  #1,A0
    SUBA.L  A6,A0
    MOVE.L  D0,84(A7)
    MOVE.L  D1,88(A7)
    MOVE.L  A0,96(A7)
    MOVEA.L A6,A0
    MOVE.L  96(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  88(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  84(A7),D0
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
    MOVEA.L 80(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    LEA     -136(A5),A1
    MOVEA.L A1,A6

.draw_text:
    TST.B   (A6)+
    BNE.S   .draw_text

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     -136(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     67.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    LEA     68(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameVariant4   (Draw grid frame variant)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws a grid frame with row separators using another variant.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameVariant4:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     6.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
    BPL.S   .return

    ADDQ.L  #1,D0

.return:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestPrimeTimeWindow   (Test primetime window uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: 1 if in window, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   48(A3)
; DESC:
;   Checks an entry flag and applies a time window test.
; NOTES:
;   Treats 'N'/'P' as mode hints and applies 18..22 window for 'P'.
;------------------------------------------------------------------------------
NEWGRID_TestPrimeTimeWindow:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.B  1(A0),D6
    MOVE.B  D6,D0
    EXT.W   D0
    SUBI.W  #'N',D0 ; Does it equal 'N'?
    BEQ.S   .equalsN

    SUBQ.W  #('P'-'N'),D0 ; Does it equal 'P'?
    BEQ.S   .equalsP

    SUBI.W  #('n'-'P'),D0 ; Does it equal 'n'?
    BEQ.S   .equalsN

    SUBQ.W  #('p'-'n'),D0 ; Does it equal 'p'?
    BEQ.S   .equalsP

    BRA.S   .equalsNeither

.equalsN:
    MOVEQ   #0,D5
    BRA.S   .return

.equalsP:
    ; Is D7 less than 18?
    MOVEQ   #18,D0
    CMP.L   D0,D7
    BLE.S   .return

    ; Is D7 greater than 22?
    MOVEQ   #22,D0
    CMP.L   D0,D7
    BGE.S   .return

    ; If it's between 18 and 22 put 1 in D5 and return.
    MOVEQ   #1,D5
    BRA.S   .return

.equalsNeither:
    MOVEQ   #1,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS
