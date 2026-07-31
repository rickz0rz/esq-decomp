    XDEF    _NEWGRID2_DispatchGridOperation
    XDEF    NEWGRID2_HandleGridState
    XDEF    NEWGRID2_ProcessGridState


;------------------------------------------------------------------------------
; FUNC: NEWGRID2_ProcessGridState   (Process grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry struct
;   stack +16: D7 = key/index
; RET:
;   D0: current state (NEWGRID_RenderStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID_TestPrimeTimeWindow, _NEWGRID_DrawGridEntry, _SCRIPT_JMPTBL_MEMORY_AllocateMemory,
;   NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_AppendShowtimesForRow, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   _SCRIPT_JMPTBL_MEMORY_DeallocateMemory, NEWGRID_DrawGridFrameVariant4, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   NEWGRID_RenderStateLatch, NEWGRID_PrimeTimeLayoutEnable
; WRITES:
;   NEWGRID_RenderStateLatch, 32(A3)
; DESC:
;   Executes a state machine to render/update the grid, allocate buffers, and
;   advance to the next UI state.
; NOTES:
;   Uses NEWGRID_RenderStateLatch to track state 4/5 transitions.
;   `A2+0/A2+4` are required entry payload pointers and `A2+20` carries
;   row-relative selection/slot index used for draw/layout.
;------------------------------------------------------------------------------
NEWGRID2_ProcessGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    SUBA.L  A0,A0
    MOVE.L  A0,-6(A5)
    MOVE.L  A3,D0
    BNE.S   .dispatch_render_state

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_RenderStateLatch
    BRA.W   .return_state

.dispatch_render_state:
    MOVE.L  NEWGRID_RenderStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_full_draw_and_layout

    SUBQ.L  #1,D0
    BEQ.W   .state5_redraw_frame_only

    BRA.W   .force_state4_recovery

.state4_full_draw_and_layout:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    PEA     1.W
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D6                      ; A2+20 = row/slot index
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .row_slot_index_ready

    SUBI.W  #$30,D6

.row_slot_index_ready:
    TST.W   NEWGRID_PrimeTimeLayoutEnable
    BEQ.S   .draw_grid_entry_alt_variant

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID_TestPrimeTimeWindow

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.S   .draw_grid_entry_alt_variant

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     3.W
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .allocate_showtimes_buffer

.draw_grid_entry_alt_variant:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #3,D1
    MOVE.L  D1,-(A7)
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.allocate_showtimes_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     2000.W
    PEA     3947.W
    PEA     Global_STR_NEWGRID2_C_1
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .draw_frame_after_showtimes

    PEA     3.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    MOVE.L  D7,(A7)
    MOVE.L  -6(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_AppendShowtimesForRow

    LEA     60(A3),A0
    MOVE.L  -6(A5),(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    PEA     2000.W
    MOVE.L  -6(A5),-(A7)
    PEA     3953.W
    PEA     Global_STR_NEWGRID2_C_2
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     36(A7),A7

.draw_frame_after_showtimes:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state5_for_frame_only_followup

    MOVEQ   #4,D0                           ; state 4 = full draw/layout pass
    BRA.S   .store_next_state_and_visible_count

.set_state5_for_frame_only_followup:
    MOVEQ   #5,D0                           ; state 5 = frame-only follow-up

.store_next_state_and_visible_count:
    PEA     2.W
    MOVE.L  D0,NEWGRID_RenderStateLatch
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)                      ; A3+32 = visible-line count cache
    BRA.S   .return_state

.state5_redraw_frame_only:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_keep_frame_only_mode

    MOVEQ   #4,D0
    BRA.S   .state5_store_next_mode

.state5_keep_frame_only_mode:
    MOVEQ   #5,D0

.state5_store_next_mode:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)                      ; A3+32 = no line-count refresh in state5
    MOVE.L  D0,NEWGRID_RenderStateLatch
    BRA.S   .return_state

.force_state4_recovery:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_RenderStateLatch

.return_state:
    MOVE.L  NEWGRID_RenderStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_HandleGridState   (Handle grid state transitions)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = row index
;   stack +16: D6 = selection-mode selector (commonly 0 or 1)
; RET:
;   D0: state (NEWGRID2_DispatchStateIndex)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_ProcessGridState, NEWGRID_InitSelectionWindowAlt, NEWGRID_UpdateSelectionFromInputAlt
; READS:
;   NEWGRID2_DispatchStateIndex
; WRITES:
;   NEWGRID2_DispatchStateIndex
; DESC:
;   State machine wrapper around NEWGRID2_ProcessGridState with jump table dispatch.
; NOTES:
;   Uses NEWGRID2_DispatchStateIndex as a 0..5 state index.
;   State 5 performs the main per-row processing via NEWGRID2_ProcessGridState.
;   Jump table maps states `3` and `4` to the same update-selection handler.
;------------------------------------------------------------------------------
NEWGRID2_HandleGridState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_by_state_index

    MOVEQ   #5,D0                           ; state 5 = active per-row grid processing
    CMP.L   NEWGRID2_DispatchStateIndex,D0
    BNE.S   .reset_state

    MOVE.L  D6,-(A7)
    PEA     NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.dispatch_by_state_index:
    MOVE.L  NEWGRID2_DispatchStateIndex,D0
    CMPI.L  #$6,D0
    BCC.W   .clear_dispatch_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .state0_init_selection-.state_jumptable-2
    DC.W    .state1_update_selection-.state_jumptable-2
    DC.W    .state2_finish-.state_jumptable-2
    DC.W    .state3_update_selection-.state_jumptable-2
    DC.W    .state3_update_selection-.state_jumptable-2
    DC.W    .state5_process_grid-.state_jumptable-2

.state0_init_selection:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     NEWGRID2_ShowtimesSelectionContextPtr
    BSR.W   NEWGRID_InitSelectionWindowAlt

    LEA     12(A7),A7

.state1_update_selection:
    MOVE.L  D6,-(A7)
    PEA     NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInputAlt

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .state1_abort_and_reset

    ; Selection became valid: show prompt, then move into state 3.
    MOVE.L  D6,-(A7)
    MOVE.L  NEWGRID2_ShowtimesSelectionContextPtr,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawShowtimesPrompt

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEQ   #3,D1                           ; advance into state3/state4 shared path
    MOVE.L  D1,NEWGRID2_DispatchStateIndex
    MOVE.L  D0,NEWGRID2_CachedModeIndex
    BRA.W   .return_state

.state1_abort_and_reset:
    CLR.L   NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.state3_update_selection:
    MOVE.L  D6,-(A7)
    PEA     NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInputAlt

    MOVE.L  D6,(A7)
    BSR.W   _NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    MOVE.L  D0,D5

.state5_process_grid:
    TST.L   NEWGRID2_ShowtimesSelectionContextPtr
    BEQ.S   .state5_restart_selection_update

    MOVE.L  D6,-(A7)
    PEA     NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    MOVE.L  D6,(A7)
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BSR.W   _NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return_state

    TST.L   D5
    BEQ.S   .state5_apply_column_delta_only

    ; First-entry hint: cache mode index once, then offset by column delta.
    CMPI.L  #$1,NEWGRID2_CachedModeIndex
    BGE.S   .state5_apply_column_delta_only

    PEA     50.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID2_CachedModeIndex

.state5_apply_column_delta_only:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID2_CachedModeIndex
    BRA.S   .return_state

.state5_restart_selection_update:
    MOVEQ   #1,D0                           ; restart from "update selection" state
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BRA.S   .return_state

.state2_finish:
.clear_dispatch_state:
    CLR.L   NEWGRID2_DispatchStateIndex

.return_state:
    TST.L   NEWGRID2_DispatchStateIndex
    BNE.S   .skip_marker_clear

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7

.skip_marker_clear:
    MOVE.L  NEWGRID2_DispatchStateIndex,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

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
;   NEWGRID2_HandleGridState, NEWGRID_HandleGridSelection, NEWGRID_ProcessAltEntryState, _NEWGRID_ProcessSecondaryState, _NEWGRID_ProcessScheduleState, NEWGRID_ProcessShowtimesWorkflow
; READS:
;   _ESQDISP_PendingGridReinitFlag, NEWGRID2_PendingOperationId
; WRITES:
;   _NEWGRID_GridOperationId, NEWGRID2_PendingOperationId, NEWGRID2_LastDispatchResult
; DESC:
;   Dispatches a grid operation by index using a switch/jumptable.
; NOTES:
;   Booleanizes the return value via SNE/NEG/EXT.
;   If operation id is zero, reuses the pending id in NEWGRID2_PendingOperationId.
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
    MOVE.L  NEWGRID2_PendingOperationId,D7
    CLR.L   NEWGRID2_PendingOperationId
    BRA.S   .prepare_operation_context

.remember_requested_operation:
    MOVE.L  D7,NEWGRID2_PendingOperationId

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
    BSR.W   NEWGRID_HandleGridSelection

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.W   .return_success_bool

.op2_process_alt_entry:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessAltEntryState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.W   .return_success_bool

.op3_handle_grid_state:
    MOVE.L  D6,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op4_handle_grid_state_alt:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op5_process_secondary_state:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ProcessSecondaryState

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
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
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.op7_process_showtimes_workflow:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessShowtimesWorkflow

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID2_LastDispatchResult
    BRA.S   .return_success_bool

.operation_out_of_range:
    CLR.L   _NEWGRID_GridOperationId

.return_success_bool:
    TST.L   NEWGRID2_LastDispatchResult
    ; booleanize to 0/-1
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======