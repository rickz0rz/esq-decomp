    XDEF    _NEWGRID_DrawGridCell
    XDEF    _NEWGRID_DrawGridCellText
    XDEF    _NEWGRID_SetRowColor
    XDEF    _NEWGRID_ValidateSelectionCode


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_SetRowColor   (Set row color slot)
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
_NEWGRID_SetRowColor:
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
; FUNC: _NEWGRID_ValidateSelectionCode   (Validate selection code against flags)
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
;   _CONFIG_NewgridSelectionCode16EnabledFlag, _CONFIG_NewgridSelectionCode32EnabledFlag, _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,
;   _CONFIG_NewgridSelectionCode34AltEnabledFlag, _CONFIG_NewgridSelectionCode35EnabledFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag,
;   _GCOMMAND_DigitalNicheEnabledFlag
; WRITES:
;   54(A3)
; DESC:
;   Validates a selection code against feature flags and updates the active
;   selection byte when allowed.
; NOTES:
;   Long chain of comparisons over coded ranges.
;------------------------------------------------------------------------------
_NEWGRID_ValidateSelectionCode:
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
    MOVE.B  _CONFIG_NewgridSelectionCode16EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_32:
    MOVE.B  _CONFIG_NewgridSelectionCode32EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_48:
    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_33:
    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_49:
    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_34:
    MOVE.B  _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .case_34_alt

    MOVE.B  _CONFIG_NewgridSelectionCode34AltEnabledFlag,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

.case_34_alt:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_35:
    MOVE.B  _CONFIG_NewgridSelectionCode35EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_36:
    MOVE.B  _GCOMMAND_DigitalMplexEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_37:
    MOVE.B  _GCOMMAND_DigitalPpvEnabledFlag,D0
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
; FUNC: _NEWGRID_DrawGridCellText   (Draw primary/secondary cell labels)
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
;   _PARSEINI_JMPTBL_STRING_AppendAtNull, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength,
;   _LVOMove, _LVOText
; READS:
;   NEWGRID_SampleTimeTextWidthPx, _NEWGRID_RowHeightPx, _NEWGRID_GridOperationId,
;   _GCOMMAND_NicheTextPen, _CTASKS_STR_C
; WRITES:
;   local temp strings (-26(A5))
; DESC:
;   Draws up to two strings centered within a grid cell, handling RAVESC markers.
; NOTES:
;   Uses _NEWGRID_GridOperationId/_CTASKS_STR_C to alter pen/centering behavior.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridCellText:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
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
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

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
    MOVE.W  _NEWGRID_RowHeightPx,D0
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
    CMP.L   _NEWGRID_GridOperationId,D0
    BNE.S   .use_alt_pen

    MOVEA.L A3,A1
    MOVE.L  _GCOMMAND_NicheTextPen,D0
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
    MOVE.B  _CTASKS_STR_C,D0
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
    MOVE.B  _CTASKS_STR_C,D0
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
; FUNC: _NEWGRID_DrawGridCell   (Draw cell background and text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = cell struct
;   stack +16: D7 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _NEWGRID_DrawGridCellText
; READS:
;   _NEWGRID_ColumnStartXPx, _NEWGRID_RowHeightPx
; WRITES:
;   none
; DESC:
;   Draws the cell background (highlight or normal) and renders its labels.
; NOTES:
;   Uses two string pointers from the cell struct (1(A2), 19(A2)).
;------------------------------------------------------------------------------
_NEWGRID_DrawGridCell:
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
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    ; choose frame style based on row flag
    TST.L   D7
    BNE.S   .draw_alternate_frame

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .draw_cell_text

.draw_alternate_frame:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.draw_cell_text:
    MOVE.L  D7,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridCellText

    MOVEM.L -24(A5),D2/D7/A2-A3
    UNLK    A5
    RTS

;!======