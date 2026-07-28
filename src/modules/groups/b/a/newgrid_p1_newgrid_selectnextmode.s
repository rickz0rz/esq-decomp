    XDEF    _NEWGRID_SelectNextMode



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_SelectNextMode   (Advance grid mode selection)
; ARGS:
;   stack +34: arg_1 (via 38(A5))
; RET:
;   D0: selected mode (or 12 sentinel)
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_IsGridReadyForInput (_NEWGRID_IsGridReadyForInput)
; READS:
;   _CONFIG_ModeCycleEnabledFlag, _CONFIG_ModeCycleGateDuration, _NEWGRID_ModeCycleCountdown-200A, _CONFIG_NicheModeCycleBudget_Y/1BA5/1BAD,
;   _GCOMMAND_NicheModeCycleCount/_GCOMMAND_NicheForceMode5Flag/_GCOMMAND_MplexModeCycleCount, _GCOMMAND_PpvModeCycleCount, _TEXTDISP_PrimaryGroupPresentFlag/2231/222E/222F
; WRITES:
;   _NEWGRID_ModeCycleCountdown-200A
; DESC:
;   Cycles through candidate grid modes based on current day/state and
;   gating flags, returning the next valid mode.
; NOTES:
;   Uses two switch/jumptable blocks to select flag sources and timers.
;------------------------------------------------------------------------------
_NEWGRID_SelectNextMode:
    LINK.W  A5,#-40
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D5
    LEA     _NEWGRID_ModeSelectionTable,A0
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

    MOVE.L  _NEWGRID_ModeCycleCountdown,D1
    TST.L   D1
    BGT.S   .decrement_cycle_counter

    MOVE.L  _NEWGRID_ModeCandidateIndex,D7
    MOVE.L  D0,_NEWGRID_ModeCycleCountdown
    BRA.S   .evaluate_next_candidate

.decrement_cycle_counter:
    SUBQ.L  #1,_NEWGRID_ModeCycleCountdown
    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.S   .evaluate_next_candidate

.force_select_current:
    MOVEQ   #12,D6
    MOVEQ   #1,D5

.evaluate_next_candidate:
    TST.W   D5
    BNE.W   .return_selected_mode

    MOVE.L  _NEWGRID_ModeCandidateIndex,D0
    ASL.L   #2,D0
    MOVE.L  -38(A5,D0.L),D6
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BNE.S   .advance_slot_index

    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ModeCandidateIndex
    BRA.S   .dispatch_mode_family

.advance_slot_index:
    ADDQ.L  #1,_NEWGRID_ModeCandidateIndex

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

    MOVE.L  _NEWGRID_ModeCandidateIndex,D0
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

    SUBQ.B  #1,_NEWGRID_NicheModeCycleBudget_Y
    BGT.S   .case_group2_1_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_1_store_gate

.case_group2_1_gate_false:
    MOVEQ   #0,D1

.case_group2_1_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_NicheModeCycleBudget_Y
    BRA.W   .evaluate_next_candidate

.case_group2_2:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D0
    TST.B   D0
    BLE.S   .case_group2_2_gate_false

    SUBQ.B  #1,_NEWGRID_NicheModeCycleBudget_Static
    BGT.S   .case_group2_2_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_2_store_gate

.case_group2_2_gate_false:
    MOVEQ   #0,D1

.case_group2_2_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_NicheModeCycleBudget_Static
    BRA.W   .evaluate_next_candidate

.case_group2_3:
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D0
    TST.B   D0
    BLE.S   .case_group2_3_gate_false

    SUBQ.B  #1,_NEWGRID_NicheModeCycleBudget_Custom
    BGT.S   .case_group2_3_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_3_store_gate

.case_group2_3_gate_false:
    MOVEQ   #0,D1

.case_group2_3_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_NicheModeCycleBudget_Custom
    BRA.W   .evaluate_next_candidate

.case_group2_0:
    MOVE.L  _GCOMMAND_NicheModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_0_gate_false

    SUBQ.B  #1,_NEWGRID_NicheModeCycleBudget_Global
    BGT.S   .case_group2_0_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_0_store_gate

.case_group2_0_gate_false:
    MOVEQ   #0,D1

.case_group2_0_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_NicheModeCycleBudget_Global
    BRA.W   .evaluate_next_candidate

.case_group2_4:
    MOVE.L  _GCOMMAND_MplexModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_4_gate_false

    SUBQ.B  #1,_NEWGRID_MplexModeCycleBudget
    BGT.S   .case_group2_4_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_4_store_gate

.case_group2_4_gate_false:
    MOVEQ   #0,D1

.case_group2_4_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_MplexModeCycleBudget
    BRA.W   .evaluate_next_candidate

.case_group2_5:
    MOVE.L  _GCOMMAND_PpvModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_5_gate_false

    SUBQ.B  #1,_NEWGRID_PpvModeCycleBudget
    BGT.S   .case_group2_5_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_5_store_gate

.case_group2_5_gate_false:
    MOVEQ   #0,D1

.case_group2_5_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,_NEWGRID_PpvModeCycleBudget
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