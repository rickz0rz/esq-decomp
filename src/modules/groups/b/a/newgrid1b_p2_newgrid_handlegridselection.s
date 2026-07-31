    XDEF    _NEWGRID_HandleGridSelection


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleGridSelection   (Handle selection state transitions)
; ARGS:
;   (none observed)
; RET:
;   D0: selection state (_NEWGRID_GridSelectionWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_UpdateGridState, _NEWGRID_ProcessGridEntries, _NEWGRID_FindNextFlaggedEntry,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ValidateSelectionCode, _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_GridSelectionColumnAdjust, _NEWGRID_GridSelectionEntryIndex, _NEWGRID_GridSelectionWorkflowState, _CONFIG_NewgridSelectionCode32EnabledFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag
; WRITES:
;   _NEWGRID_GridSelectionColumnAdjust, _NEWGRID_GridSelectionEntryIndex, _NEWGRID_GridSelectionWorkflowState
; DESC:
;   Advances selection state and triggers grid redraw/update actions.
;------------------------------------------------------------------------------
_NEWGRID_HandleGridSelection:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVEQ   #5,D0
    CMP.L   _NEWGRID_GridSelectionWorkflowState,D0
    BNE.S   .reset_workflow_state

    MOVE.L  _NEWGRID_GridSelectionEntryIndex,D0
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
    BSR.W   _NEWGRID_ProcessGridEntries

    LEA     12(A7),A7

.reset_workflow_state:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_GridSelectionWorkflowState
    MOVE.L  D0,_NEWGRID_GridSelectionEntryIndex
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_GridSelectionWorkflowState,D0
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
    CLR.L   _NEWGRID_GridSelectionColumnAdjust
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_GridSelectionWorkflowState

.state3or4_find_next:
    MOVE.L  _NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  _NEWGRID_GridSelectionWorkflowState,-(A7)
    BSR.W   _NEWGRID_FindNextFlaggedEntry

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,_NEWGRID_GridSelectionEntryIndex

.state5_process_entry:
    MOVE.L  _NEWGRID_GridSelectionEntryIndex,D0
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
    MOVE.L  _NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_GridSelectionWorkflowState
    BRA.S   .post_process

.state5_process_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_GridSelectionEntryIndex,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessGridEntries

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_GridSelectionWorkflowState
    TST.L   D6
    BEQ.S   .post_process

    CMPI.L  #$1,_NEWGRID_GridSelectionColumnAdjust
    BGE.S   .post_process

    SUBQ.L  #5,D0
    BNE.S   .post_process

    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .post_process

    PEA     48.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_GridSelectionColumnAdjust

.post_process:
    MOVE.B  _CONFIG_NewgridSelectionCode32EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_column_adjust

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_GridSelectionColumnAdjust
    BGE.S   .update_column_adjust

    PEA     32.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_GridSelectionColumnAdjust

.update_column_adjust:
    MOVE.L  _NEWGRID_GridSelectionColumnAdjust,D0
    TST.L   D0
    BLE.S   .return_state

    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_GridSelectionColumnAdjust
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   _NEWGRID_GridSelectionWorkflowState

.return_state:
    MOVE.L  _NEWGRID_GridSelectionWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======