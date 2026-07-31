    XDEF    _NEWGRID_ProcessScheduleState




;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ProcessScheduleState   (Process schedule/detail state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = row index
;   stack +16: D6 = selector value
; RET:
;   D0: state (_NEWGRID_ScheduleWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleGridEditorState, _NEWGRID_UpdateGridState,
;   _NEWGRID_HandleDetailGridState, _NEWGRID_FindNextEntryWithAltMarkers,
;   _NEWGRID_DrawStatusMessage, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_ScheduleSelectionCodeCache/202B/202C/202D/202E/202F, _GCOMMAND_DigitalMplexEnabledFlag/_GCOMMAND_MplexSearchRowLimit/_GCOMMAND_MplexEditorLayoutPen/_GCOMMAND_MplexEditorRowPen/_GCOMMAND_MplexWorkflowMode/_GCOMMAND_MplexDetailLayoutFlag/_GCOMMAND_MplexListingsTemplatePtr
; WRITES:
;   _NEWGRID_ScheduleSelectionCodeCache/202B/202C/202D/202E/202F
; DESC:
;   Drives a multi-state schedule/detail workflow using a jump table.
; NOTES:
;   Uses _NEWGRID_ScheduleWorkflowState as a 0..7 state index.
;------------------------------------------------------------------------------
_NEWGRID_ProcessScheduleState:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  34(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVE.L  _NEWGRID_ScheduleWorkflowState,D0
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
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .legacy_nullctx_run_detail_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    BRA.S   .legacy_nullctx_clear_selection_and_state

.legacy_nullctx_run_detail_state:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleDetailGridState

    LEA     12(A7),A7

.legacy_nullctx_clear_selection_and_state:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    MOVE.L  D0,_NEWGRID_SelectedPrimaryEntryIndex
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_ScheduleWorkflowState,D0
    CMPI.L  #$8,D0
    BCC.W   .clear_workflow_state

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
    MOVE.B  _GCOMMAND_MplexWorkflowMode,D0
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
    MOVE.L  D2,_NEWGRID_ScheduleEditorGateFlag
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
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  _NEWGRID_ScheduleWorkflowState,-(A7)
    MOVE.L  D0,_NEWGRID_ScheduleAltSelectorFlag
    BSR.W   _NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    CLR.W   _NEWGRID_ScheduleRowOffset
    MOVE.L  D0,_NEWGRID_SelectedPrimaryEntryIndex

.search_loop:
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .search_done

    MOVE.W  _NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    CMP.L   _GCOMMAND_MplexSearchRowLimit,D1
    BGE.S   .search_done

    ADDQ.W  #1,_NEWGRID_ScheduleRowOffset
    MOVE.L  D7,D1
    ADD.W   _NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_SelectedPrimaryEntryIndex
    BRA.S   .search_loop

.search_done:
    MOVEQ   #-1,D0
    CMP.L   _NEWGRID_SelectedPrimaryEntryIndex,D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState

.case_state1:
    MOVE.L  D6,D0
    ADD.W   _NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawStatusMessage

    ADDQ.W  #8,A7
    CLR.L   _NEWGRID_ScheduleSelectionCodeCache
    TST.L   _NEWGRID_ScheduleEditorGateFlag
    BEQ.S   .case_state1_select

    MOVEQ   #2,D0
    BRA.S   .case_state1_store

.case_state1_select:
    MOVEQ   #3,D0

.case_state1_store:
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2:
    TST.L   _NEWGRID_ScheduleEditorGateFlag
    BEQ.S   .case_state2_force_state3

    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_MplexEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_MplexEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state2_done

    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2_done:
    CLR.L   _NEWGRID_ScheduleEditorGateFlag
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.W   .return_state

.case_state2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState

.case_state3_or4:
    MOVE.L  D7,D0
    ADD.W   _NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  _NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,_NEWGRID_SelectedPrimaryEntryIndex

.case_state5:
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,D0
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
    BEQ.S   .case_state5_process_detail

    MOVE.L  D7,D0
    ADD.W   _NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.S   .case_state5_post

.case_state5_process_detail:
    MOVE.L  D7,D0
    ADD.W   _NEWGRID_ScheduleRowOffset,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleDetailGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState

.case_state5_post:
    MOVE.B  _GCOMMAND_DigitalMplexEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D5
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_ScheduleSelectionCodeCache
    BGE.S   .update_column_adjust

    MOVE.B  _GCOMMAND_MplexDetailLayoutFlag,D0
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
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ScheduleSelectionCodeCache

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_ScheduleSelectionCodeCache
    BRA.W   .return_state

.case_state5_no_entry:
    MOVEQ   #6,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState

.case_state6:
    MOVE.L  _NEWGRID_SelectedPrimaryEntryIndex,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .case_state6_done

    MOVE.W  _NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    CMP.L   _GCOMMAND_MplexSearchRowLimit,D1
    BGE.S   .case_state6_done

    ADDQ.W  #1,_NEWGRID_ScheduleRowOffset
    MOVE.L  D7,D1
    ADD.W   _NEWGRID_ScheduleRowOffset,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_ScheduleWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithAltMarkers

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_SelectedPrimaryEntryIndex
    BRA.S   .case_state6

.case_state6_done:
    MOVEQ   #-1,D0
    CMP.L   _NEWGRID_SelectedPrimaryEntryIndex,D0
    BNE.S   .case_state6_store

    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.S   .case_state7

.case_state6_store:
    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.case_state7:
    TST.L   _NEWGRID_ScheduleAltSelectorFlag
    BEQ.S   .case_state7_clear_state

    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_MplexEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_MplexEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state7_done

    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.case_state7_done:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ScheduleWorkflowState
    MOVE.L  D0,_NEWGRID_ScheduleAltSelectorFlag
    BRA.S   .return_state

.case_state7_clear_state:
    CLR.L   _NEWGRID_ScheduleWorkflowState
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   _NEWGRID_ScheduleWorkflowState

.return_state:
    MOVE.L  _NEWGRID_ScheduleWorkflowState,D0
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======