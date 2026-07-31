    XDEF    _NEWGRID_ProcessAltEntryState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ProcessAltEntryState   (Process alternate entry state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = row index
;   stack +16: D6 = selector value
; RET:
;   D0: state (_NEWGRID_AltEntryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleAltGridState, _NEWGRID_FindNextEntryWithMarkers,
;   _NEWGRID_DrawEmptyGridMessage, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_AltEntryAttemptCounter/2026/2027, _CONFIG_NewgridSelectionCode35EnabledFlag
; WRITES:
;   _NEWGRID_AltEntryAttemptCounter/2026/2027
; DESC:
;   State machine wrapper around alternate grid entry handling.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
_NEWGRID_ProcessAltEntryState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVEQ   #5,D0
    CMP.L   _NEWGRID_AltEntryWorkflowState,D0
    BNE.S   .legacy_nullctx_reset_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleAltGridState

    LEA     12(A7),A7

.legacy_nullctx_reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_AltEntryWorkflowState
    MOVE.L  D0,_NEWGRID_AltEntryCursor
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_AltEntryWorkflowState,D0
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
    CLR.L   _NEWGRID_AltEntryAttemptCounter
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  _NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_AltEntryCursor
    ADDQ.L  #1,D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_AltEntryWorkflowState

.case_state1_draw_empty:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawEmptyGridMessage

    LEA     12(A7),A7
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_AltEntryWorkflowState
    BRA.W   .return_state

.case_state3_or4:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  _NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,_NEWGRID_AltEntryCursor

.case_state5:
    MOVE.L  _NEWGRID_AltEntryCursor,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.S   .clear_workflow_state

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleAltGridState

    LEA     12(A7),A7
    MOVE.B  _CONFIG_NewgridSelectionCode35EnabledFlag,D1
    MOVE.L  D0,_NEWGRID_AltEntryWorkflowState
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BNE.S   .return_state

    TST.L   D5
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_AltEntryAttemptCounter
    BGE.S   .update_column_adjust

    PEA     51.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_AltEntryAttemptCounter

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_AltEntryAttemptCounter
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   _NEWGRID_AltEntryWorkflowState

.return_state:
    MOVE.L  _NEWGRID_AltEntryWorkflowState,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======