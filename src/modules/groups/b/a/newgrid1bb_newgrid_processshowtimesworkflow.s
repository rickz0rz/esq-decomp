    XDEF    _NEWGRID_ProcessShowtimesWorkflow


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ProcessShowtimesWorkflow   (Top-level showtimes workflow dispatcher)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
; RET:
;   D0: state (_NEWGRID_ShowtimesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleGridEditorState, _NEWGRID_UpdateGridState,
;   _NEWGRID_HandleShowtimesState, _NEWGRID_InitSelectionWindow,
;   _NEWGRID_UpdateSelectionFromInput, _NEWGRID_DrawGridMessageAlt,
;   _NEWGRID_ClearEntryMarkerBits, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_ShowtimesWorkflowState/2038, _NEWGRID_ShowtimesSelectionContextPtr, _GCOMMAND_DigitalPpvEnabledFlag, _GCOMMAND_PpvShowtimesWorkflowMode, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PpvEditorLayoutPen, _GCOMMAND_PpvEditorRowPen
; WRITES:
;   _NEWGRID_ShowtimesWorkflowState/2038
; DESC:
;   Multi-state handler for showtimes selection and detail views.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
_NEWGRID_ProcessShowtimesWorkflow:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.W   .dispatch_workflow_state

    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .legacy_nullctx_editor_reset

    SUBQ.L  #3,D0
    BEQ.S   .legacy_nullctx_route_by_editor_gate

    SUBQ.L  #2,D0
    BNE.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_editor_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_route_by_editor_gate:
    MOVE.L  _NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .legacy_nullctx_run_showtimes_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_run_showtimes_state:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.legacy_nullctx_reinit_selection_and_clear:
    CLR.L   -(A7)
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   _NEWGRID_InitSelectionWindow

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
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
    DC.W    .clear_workflow_state-.state_jumptable-2
    DC.W    .case_state6-.state_jumptable-2

.case_state0:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   _NEWGRID_InitSelectionWindow

    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInput

    LEA     16(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state1:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridMessageAlt

    ADDQ.W  #4,A7
    CLR.L   _NEWGRID_ShowtimesColumnAdjust
    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case_state2:
    MOVE.B  _GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case2_force_state3

.case2_handle:
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case2_done

    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state3_or4:
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInput

    ADDQ.W  #8,A7
    MOVEQ   #1,D6

.case_state5:
    TST.L   _NEWGRID_ShowtimesSelectionContextPtr
    BEQ.W   .case5_no_entry

    MOVE.L  _NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case5_update

    MOVE.W  _NEWGRID_ShowtimesWorkflowArgWord,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_ShowtimesWorkflowArgLong,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .case5_post

.case5_update:
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case5_post:
    MOVE.B  _GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_ShowtimesColumnAdjust
    BGE.S   .update_column_adjust

    PEA     53.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesColumnAdjust

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_ShowtimesColumnAdjust
    BRA.S   .return_state

.case5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state6:
    MOVE.B  _GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case6_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case6_clear_state

.case6_handle:
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case6_done

    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_done:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_clear_state:
    CLR.L   _NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   _NEWGRID_ShowtimesWorkflowState

.return_state:
    TST.L   _NEWGRID_ShowtimesWorkflowState
    BNE.S   .maybe_clear_markers

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7

.maybe_clear_markers:
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======