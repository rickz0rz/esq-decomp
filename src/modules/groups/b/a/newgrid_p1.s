    XDEF    NEWGRID_DrawClockFormatHeader
    XDEF    NEWGRID_MapSelectionToMode
    XDEF    NEWGRID_SelectNextMode

;------------------------------------------------------------------------------
; FUNC: NEWGRID_SelectNextMode   (Advance grid mode selection)
; ARGS:
;   stack +34: arg_1 (via 38(A5))
; RET:
;   D0: selected mode (or 12 sentinel)
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_IsGridReadyForInput (_NEWGRID_IsGridReadyForInput)
; READS:
;   _CONFIG_ModeCycleEnabledFlag, _CONFIG_ModeCycleGateDuration, NEWGRID_ModeCycleCountdown-200A, _CONFIG_NicheModeCycleBudget_Y/1BA5/1BAD,
;   _GCOMMAND_NicheModeCycleCount/_GCOMMAND_NicheForceMode5Flag/_GCOMMAND_MplexModeCycleCount, _GCOMMAND_PpvModeCycleCount, _TEXTDISP_PrimaryGroupPresentFlag/2231/222E/222F
; WRITES:
;   NEWGRID_ModeCycleCountdown-200A
; DESC:
;   Cycles through candidate grid modes based on current day/state and
;   gating flags, returning the next valid mode.
; NOTES:
;   Uses two switch/jumptable blocks to select flag sources and timers.
;------------------------------------------------------------------------------
NEWGRID_SelectNextMode:
    LINK.W  A5,#-40
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D5
    LEA     NEWGRID_ModeSelectionTable,A0
    LEA     -38(A5),A1
    MOVEQ   #6,D0

.copy_mode_table:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_mode_table
    MOVE.B  _CONFIG_ModeCycleEnabledFlag,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .evaluate_next_candidate

    MOVE.L  _CONFIG_ModeCycleGateDuration,D0
    TST.L   D0
    BLE.S   .force_select_current

    MOVE.L  NEWGRID_ModeCycleCountdown,D1
    TST.L   D1
    BGT.S   .decrement_cycle_counter

    MOVE.L  NEWGRID_ModeCandidateIndex,D7
    MOVE.L  D0,NEWGRID_ModeCycleCountdown
    BRA.S   .evaluate_next_candidate

.decrement_cycle_counter:
    SUBQ.L  #1,NEWGRID_ModeCycleCountdown
    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.S   .evaluate_next_candidate

.force_select_current:
    MOVEQ   #12,D6
    MOVEQ   #1,D5

.evaluate_next_candidate:
    TST.W   D5
    BNE.W   .return_selected_mode

    MOVE.L  NEWGRID_ModeCandidateIndex,D0
    ASL.L   #2,D0
    MOVE.L  -38(A5,D0.L),D6
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BNE.S   .advance_slot_index

    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ModeCandidateIndex
    BRA.S   .dispatch_mode_family

.advance_slot_index:
    ADDQ.L  #1,NEWGRID_ModeCandidateIndex

.dispatch_mode_family:
    MOVE.B  _CONFIG_ModeCycleEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .dispatch_non_y_mode_group2

    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .validate_cycle_gate

    CMPI.L  #$8,D0
    BGE.W   .validate_cycle_gate

    ADD.W   D0,D0
    MOVE.W  .switch_group1_jumptable(PC,D0.W),D0
    JMP     .switch_group1_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_group1_jumptable:
    DC.W    .case_group1_0-.switch_group1_jumptable-2
    DC.W    .case_group1_1-.switch_group1_jumptable-2
    DC.W    .case_group1_2-.switch_group1_jumptable-2
    DC.W    .case_group1_3-.switch_group1_jumptable-2
    DC.W    .case_group1_4-.switch_group1_jumptable-2
    DC.W    .case_group1_5-.switch_group1_jumptable-2
    DC.W    .validate_cycle_gate-.switch_group1_jumptable-2
    DC.W    .validate_cycle_gate-.switch_group1_jumptable-2

.case_group1_1:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Y,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_2:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_3:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_0:
    TST.L   _GCOMMAND_NicheModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .validate_cycle_gate

.case_group1_4:
    TST.L   _GCOMMAND_MplexModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .validate_cycle_gate

.case_group1_5:
    TST.L   _GCOMMAND_PpvModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5

.validate_cycle_gate:
    TST.W   D5
    BNE.W   .evaluate_next_candidate

    MOVE.L  NEWGRID_ModeCandidateIndex,D0
    CMP.L   D7,D0
    BNE.W   .evaluate_next_candidate

    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.W   .evaluate_next_candidate

.dispatch_non_y_mode_group2:
    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .evaluate_next_candidate

    CMPI.L  #$8,D0
    BGE.W   .evaluate_next_candidate

    ADD.W   D0,D0
    MOVE.W  .switch_group2_jumptable(PC,D0.W),D0
    JMP     .switch_group2_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_group2_jumptable:
    DC.W    .case_group2_0-.switch_group2_jumptable-2
    DC.W    .case_group2_1-.switch_group2_jumptable-2
    DC.W    .case_group2_2-.switch_group2_jumptable-2
    DC.W    .case_group2_3-.switch_group2_jumptable-2
    DC.W    .case_group2_4-.switch_group2_jumptable-2
    DC.W    .case_group2_5-.switch_group2_jumptable-2
    DC.W    .evaluate_next_candidate-.switch_group2_jumptable-2
    DC.W    .case_group2_7-.switch_group2_jumptable-2

.case_group2_1:
    MOVE.B  (_CONFIG_NicheModeCycleBudget_Y).L,D0
    TST.B   D0
    BLE.S   .case_group2_1_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Y
    BGT.S   .case_group2_1_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_1_store_gate

.case_group2_1_gate_false:
    MOVEQ   #0,D1

.case_group2_1_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Y
    BRA.W   .evaluate_next_candidate

.case_group2_2:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D0
    TST.B   D0
    BLE.S   .case_group2_2_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Static
    BGT.S   .case_group2_2_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_2_store_gate

.case_group2_2_gate_false:
    MOVEQ   #0,D1

.case_group2_2_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Static
    BRA.W   .evaluate_next_candidate

.case_group2_3:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D0
    TST.B   D0
    BLE.S   .case_group2_3_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Custom
    BGT.S   .case_group2_3_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_3_store_gate

.case_group2_3_gate_false:
    MOVEQ   #0,D1

.case_group2_3_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Custom
    BRA.W   .evaluate_next_candidate

.case_group2_0:
    MOVE.L  _GCOMMAND_NicheModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_0_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Global
    BGT.S   .case_group2_0_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_0_store_gate

.case_group2_0_gate_false:
    MOVEQ   #0,D1

.case_group2_0_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Global
    BRA.W   .evaluate_next_candidate

.case_group2_4:
    MOVE.L  _GCOMMAND_MplexModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_4_gate_false

    SUBQ.B  #1,NEWGRID_MplexModeCycleBudget
    BGT.S   .case_group2_4_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_4_store_gate

.case_group2_4_gate_false:
    MOVEQ   #0,D1

.case_group2_4_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_MplexModeCycleBudget
    BRA.W   .evaluate_next_candidate

.case_group2_5:
    MOVE.L  _GCOMMAND_PpvModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_5_gate_false

    SUBQ.B  #1,NEWGRID_PpvModeCycleBudget
    BGT.S   .case_group2_5_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_5_store_gate

.case_group2_5_gate_false:
    MOVEQ   #0,D1

.case_group2_5_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_PpvModeCycleBudget
    BRA.W   .evaluate_next_candidate

.case_group2_7:
    MOVEQ   #1,D5
    BRA.W   .evaluate_next_candidate

.return_selected_mode:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_MapSelectionToMode   (Map selection index to mode)
; ARGS:
;   stack +8: D7 = selection index
;   stack +12: D6 = mode argument
; RET:
;   D0: mapped mode id
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_IsGridReadyForInput (_NEWGRID_IsGridReadyForInput), NEWGRID_SelectNextMode (NEWGRID_SelectNextMode)
; READS:
;   _GCOMMAND_NicheModeCycleCount/_GCOMMAND_NicheForceMode5Flag
; WRITES:
;   _GCOMMAND_NicheModeCycleCount (cleared when case 0x3E hit)
; DESC:
;   Uses a switch/jumptable to map selection indices to mode IDs and gates
;   certain modes based on flags and readiness checks.
; NOTES:
;   Returns 0 when input is out of range.
;------------------------------------------------------------------------------
NEWGRID_MapSelectionToMode:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.W  18(A7),D6
    MOVE.L  D7,D0
    CMPI.L  #$d,D0
    BCC.S   .selection_out_of_range

    ADD.W   D0,D0
    MOVE.W  .switch_selection_jumptable(PC,D0.W),D0
    JMP     .switch_selection_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_selection_jumptable:
    DC.W    .case_sel_0-.switch_selection_jumptable-2
    DC.W    .case_sel_1-.switch_selection_jumptable-2
    DC.W    .case_sel_2-.switch_selection_jumptable-2
    DC.W    .case_sel_3-.switch_selection_jumptable-2
    DC.W    .case_sel_4-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_6-.switch_selection_jumptable-2
    DC.W    .case_sel_0-.switch_selection_jumptable-2

.case_sel_0:
    MOVEQ   #1,D7
    BRA.S   .return_mapped_mode

.case_sel_1:
    MOVEQ   #2,D7
    BRA.S   .return_mapped_mode

.case_sel_2:
    MOVEQ   #3,D7
    BRA.S   .return_mapped_mode

.case_sel_3:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_IsGridReadyForInput

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .case_sel_3_fallback_mode4

    MOVEQ   #11,D0
    BRA.S   .case_sel_3_store_mode

.case_sel_3_fallback_mode4:
    MOVEQ   #4,D0

.case_sel_3_store_mode:
    MOVE.L  D0,D7
    BRA.S   .return_mapped_mode

.case_sel_4:
    TST.L   _GCOMMAND_NicheForceMode5Flag
    BEQ.S   .case_sel_5

    MOVEQ   #5,D7
    CLR.L   _GCOMMAND_NicheModeCycleCount
    BRA.S   .return_mapped_mode

.case_sel_5:
    BSR.W   NEWGRID_SelectNextMode

    MOVE.L  D0,D7
    BRA.S   .return_mapped_mode

.case_sel_6:
    MOVEQ   #1,D7
    BRA.S   .return_mapped_mode

.selection_out_of_range:
    MOVEQ   #0,D7

.return_mapped_mode:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawClockFormatHeader   (Draw clock header row)
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
NEWGRID_DrawClockFormatHeader:
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