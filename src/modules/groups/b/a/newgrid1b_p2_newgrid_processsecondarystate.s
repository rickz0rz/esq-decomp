    XDEF    _NEWGRID_ProcessSecondaryState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ProcessSecondaryState   (Process alternate state machine)
; ARGS:
;   (none observed)
; RET:
;   D0: state (_NEWGRID_SecondaryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleGridEditorState, _NEWGRID_UpdateGridState,
;   _NEWGRID_ProcessGridEntries, _NEWGRID_FindNextEntryWithFlags,
;   _NEWGRID_ValidateSelectionCode, _NEWGRID_GetGridModeIndex,
;   _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_SecondarySelectedEntryIndex/2022/2023, _GCOMMAND_DigitalNicheEnabledFlag/_GCOMMAND_NicheEditorLayoutPen/_GCOMMAND_NicheEditorRowPen/_GCOMMAND_NicheWorkflowMode/_GCOMMAND_DigitalNicheListingsTemplatePtr, _CONFIG_NewgridSelectionCode48_49EnabledFlag
; WRITES:
;   _NEWGRID_SecondarySelectedEntryIndex/2022/2023
; DESC:
;   Drives a secondary state machine for a different grid display path.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
_NEWGRID_ProcessSecondaryState:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVE.L  _NEWGRID_SecondaryWorkflowState,D0
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
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,D0
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
    BSR.W   _NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.legacy_nullctx_clear_selection_and_state:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    MOVE.L  D0,_NEWGRID_SecondarySelectedEntryIndex
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_SecondaryWorkflowState,D0
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
    CLR.L   _NEWGRID_SecondarySelectionHintCounter
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  _NEWGRID_SecondaryWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithFlags

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_SecondarySelectedEntryIndex
    ADDQ.L  #1,D0
    BEQ.W   .return_state

    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState

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
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state2_done

    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    BRA.W   .return_state

.case_state2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    BRA.W   .return_state

.case_state2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState

.case_state3:
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  _NEWGRID_SecondaryWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithFlags

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,_NEWGRID_SecondarySelectedEntryIndex

.case_state5:
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,D0
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
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    BRA.S   .case_state5_post

.case_state5_process_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_SecondarySelectedEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessGridEntries

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    TST.L   D6
    BEQ.S   .case_state5_post

    CMPI.L  #$1,_NEWGRID_SecondarySelectionHintCounter
    BGE.S   .case_state5_post

    SUBQ.L  #5,D0
    BNE.S   .case_state5_post

    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .case_state5_post

    PEA     49.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_SecondarySelectionHintCounter

.case_state5_post:
    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_column_adjust

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_SecondarySelectionHintCounter
    BGE.S   .update_column_adjust

    PEA     33.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_SecondarySelectionHintCounter

.update_column_adjust:
    MOVE.L  _NEWGRID_SecondarySelectionHintCounter,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_SecondarySelectionHintCounter
    BRA.S   .return_state

.case_state5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState

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
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case_state7_done

    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    BRA.S   .return_state

.case_state7_done:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_SecondaryWorkflowState
    BRA.S   .return_state

.case_state7_clear_state:
    CLR.L   _NEWGRID_SecondaryWorkflowState

.return_state:
    MOVE.L  _NEWGRID_SecondaryWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======