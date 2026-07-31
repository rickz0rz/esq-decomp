    XDEF    _NEWGRID2_DispatchGridOperation


;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_DispatchGridOperation   (Dispatch grid operation)
; ARGS:
;   stack +4: D7 = operation id (1..7)
;   stack +8: A3 = grid/context pointer (optional)
;   stack +14: D6 = row/index word
;   stack +18: D5 = auxiliary selector word
; RET:
;   D0: boolean (-1/0) success flag
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _NEWGRID2_HandleGridState, _NEWGRID_HandleGridSelection, _NEWGRID_ProcessAltEntryState, _NEWGRID_ProcessSecondaryState, _NEWGRID_ProcessScheduleState, _NEWGRID_ProcessShowtimesWorkflow
; READS:
;   _ESQDISP_PendingGridReinitFlag, _NEWGRID2_PendingOperationId
; WRITES:
;   _NEWGRID_GridOperationId, _NEWGRID2_PendingOperationId, _NEWGRID2_LastDispatchResult
; DESC:
;   Dispatches a grid operation by index using a switch/jumptable.
; NOTES:
;   Booleanizes the return value via SNE/NEG/EXT.
;   If operation id is zero, reuses the pending id in _NEWGRID2_PendingOperationId.
;   Operation ids map as:
;   `1=selection`, `2=alt-entry`, `3/4=grid-state`, `5=secondary`,
;   `6=schedule`, `7=showtimes`.
;------------------------------------------------------------------------------
_NEWGRID2_DispatchGridOperation:
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D6
    MOVE.W  34(A7),D5
    TST.L   D7
    BNE.S   .remember_requested_operation

    SUBA.L  A3,A3
    MOVE.L  _NEWGRID2_PendingOperationId,D7
    CLR.L   _NEWGRID2_PendingOperationId
    BRA.S   .prepare_operation_context

.remember_requested_operation:
    MOVE.L  D7,_NEWGRID2_PendingOperationId

.prepare_operation_context:
    TST.W   _ESQDISP_PendingGridReinitFlag
    BEQ.S   .dispatch_operation

    CLR.W   _ESQDISP_PendingGridReinitFlag
    SUBA.L  A3,A3

.dispatch_operation:
    MOVE.L  D7,_NEWGRID_GridOperationId      ; current operation id (1..7)
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   .operation_out_of_range

    CMPI.L  #$7,D0
    BGE.W   .operation_out_of_range

    ADD.W   D0,D0
    MOVE.W  .operation_jumptable(PC,D0.W),D0
    JMP     .operation_jumptable+2(PC,D0.W)

; switch/jumptable
.operation_jumptable:
    ; op1..op7 map to selection/entry/grid/secondary/schedule/showtimes handlers.
    DC.W    .op1_handle_selection-.operation_jumptable-2
    DC.W    .op2_process_alt_entry-.operation_jumptable-2
    DC.W    .op3_handle_grid_state-.operation_jumptable-2
    DC.W    .op4_handle_grid_state_alt-.operation_jumptable-2
    DC.W    .op5_process_secondary_state-.operation_jumptable-2
    DC.W    .op6_process_schedule_state-.operation_jumptable-2
    DC.W    .op7_process_showtimes_workflow-.operation_jumptable-2

.op1_handle_selection:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridSelection

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.W   .return_success_bool

.op2_process_alt_entry:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessAltEntryState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.W   .return_success_bool

.op3_handle_grid_state:
    MOVE.L  D6,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op4_handle_grid_state_alt:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op5_process_secondary_state:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessSecondaryState

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op6_process_schedule_state:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessScheduleState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op7_process_showtimes_workflow:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessShowtimesWorkflow

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.operation_out_of_range:
    CLR.L   _NEWGRID_GridOperationId

.return_success_bool:
    TST.L   _NEWGRID2_LastDispatchResult
    ; booleanize to 0/-1
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======