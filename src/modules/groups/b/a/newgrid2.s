    XDEF    NEWGRID2_DispatchGridOperation
    XDEF    NEWGRID2_DispatchOperationDefault
    XDEF    NEWGRID2_EnsureBuffersAllocated
    XDEF    NEWGRID2_FreeBuffersIfAllocated
    XDEF    NEWGRID2_HandleGridState
    XDEF    NEWGRID2_ProcessGridState
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel
    XDEF    NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
    XDEF    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry
    XDEF    NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1
    XDEF    NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes
    XDEF    NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState
    XDEF    NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant
    XDEF    NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer
    XDEF    NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex
    XDEF    NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
    XDEF    NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow
    XDEF    NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
    XDEF    NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
    XDEF    NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2
    XDEF    NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
    XDEF    NEWGRID2_JMPTBL_ESQ_TestBit1Based
    XDEF    NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    NEWGRID2_JMPTBL_STRING_AppendN
    XDEF    NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
    XDEF    NEWGRID2_JMPTBL_STR_SkipClass3Chars

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
;   NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID_TestPrimeTimeWindow, NEWGRID_DrawGridEntry, SCRIPT_JMPTBL_MEMORY_AllocateMemory,
;   NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_AppendShowtimesForRow, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   SCRIPT_JMPTBL_MEMORY_DeallocateMemory, NEWGRID_DrawGridFrameVariant4, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

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
    BSR.W   NEWGRID_DrawGridEntry

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
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.allocate_showtimes_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     2000.W
    PEA     3947.W
    PEA     Global_STR_NEWGRID2_C_1
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    PEA     2000.W
    MOVE.L  -6(A5),-(A7)
    PEA     3953.W
    PEA     Global_STR_NEWGRID2_C_2
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

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
    BSR.W   NEWGRID_TestModeFlagActive

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
    BSR.W   NEWGRID_TestModeFlagActive

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
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID2_CachedModeIndex

.state5_apply_column_delta_only:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

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
; FUNC: NEWGRID2_DispatchGridOperation   (Dispatch grid operation)
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
;   NEWGRID2_HandleGridState, NEWGRID_HandleGridSelection, NEWGRID_ProcessAltEntryState, NEWGRID_ProcessSecondaryState, NEWGRID_ProcessScheduleState, NEWGRID_ProcessShowtimesWorkflow
; READS:
;   ESQDISP_PendingGridReinitFlag, NEWGRID2_PendingOperationId
; WRITES:
;   NEWGRID_GridOperationId, NEWGRID2_PendingOperationId, NEWGRID2_LastDispatchResult
; DESC:
;   Dispatches a grid operation by index using a switch/jumptable.
; NOTES:
;   Booleanizes the return value via SNE/NEG/EXT.
;   If operation id is zero, reuses the pending id in NEWGRID2_PendingOperationId.
;   Operation ids map as:
;   `1=selection`, `2=alt-entry`, `3/4=grid-state`, `5=secondary`,
;   `6=schedule`, `7=showtimes`.
;------------------------------------------------------------------------------
NEWGRID2_DispatchGridOperation:
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
    TST.W   ESQDISP_PendingGridReinitFlag
    BEQ.S   .dispatch_operation

    CLR.W   ESQDISP_PendingGridReinitFlag
    SUBA.L  A3,A3

.dispatch_operation:
    MOVE.L  D7,NEWGRID_GridOperationId      ; current operation id (1..7)
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
    BSR.W   NEWGRID_ProcessSecondaryState

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
    BSR.W   NEWGRID_ProcessScheduleState

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
    CLR.L   NEWGRID_GridOperationId

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

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_DispatchOperationDefault   (Dispatch default grid operation)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   NEWGRID2_DispatchGridOperation
; DESC:
;   Dispatches the grid operation with zeroed inputs.
;------------------------------------------------------------------------------
NEWGRID2_DispatchOperationDefault:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID2_DispatchGridOperation

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_EnsureBuffersAllocated   (Allocate grid buffers on demand)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_AllocateMemory, NEWGRID_RebuildIndexCache
; READS:
;   NEWGRID2_BufferAllocationFlag
; WRITES:
;   NEWGRID_SecondaryIndexCachePtr, NEWGRID_EntryTextScratchPtr, NEWGRID2_BufferAllocationFlag
; DESC:
;   Allocates the grid backing buffers when the request flag is set.
; NOTES:
;   Allocates 1208-byte index cache plus 1000-byte text scratch, then clears
;   NEWGRID2_BufferAllocationFlag to mark allocation complete.
;------------------------------------------------------------------------------
NEWGRID2_EnsureBuffersAllocated:
    TST.L   NEWGRID2_BufferAllocationFlag
    BEQ.S   .buffers_already_ready

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1208.W
    PEA     4153.W
    PEA     Global_STR_NEWGRID2_C_3
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,NEWGRID_SecondaryIndexCachePtr
    ; Rebuild secondary index cache immediately after allocation.
    BSR.W   NEWGRID_RebuildIndexCache

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     4156.W
    PEA     Global_STR_NEWGRID2_C_4
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    CLR.L   NEWGRID2_BufferAllocationFlag
    MOVE.L  D0,NEWGRID_EntryTextScratchPtr

.buffers_already_ready:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_FreeBuffersIfAllocated   (Free grid buffers)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   NEWGRID_EntryTextScratchPtr, NEWGRID_SecondaryIndexCachePtr
; WRITES:
;   NEWGRID_EntryTextScratchPtr, NEWGRID_SecondaryIndexCachePtr
; DESC:
;   Frees any allocated grid buffers and clears stored pointers.
; NOTES:
;   Uses NEWGRID_EntryTextScratchPtr as the gate before freeing both buffers.
;------------------------------------------------------------------------------
NEWGRID2_FreeBuffersIfAllocated:
    TST.L   NEWGRID_EntryTextScratchPtr
    BEQ.S   .buffers_already_freed

    PEA     1000.W
    MOVE.L  NEWGRID_EntryTextScratchPtr,-(A7)
    PEA     4164.W
    PEA     Global_STR_NEWGRID2_C_5
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    CLR.L   NEWGRID_EntryTextScratchPtr
    PEA     1208.W
    MOVE.L  NEWGRID_SecondaryIndexCachePtr,-(A7)
    PEA     4167.W
    PEA     Global_STR_NEWGRID2_C_6
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    CLR.L   NEWGRID_SecondaryIndexCachePtr

.buffers_already_freed:
    RTS

;!======

; Jump-stub block:
; These entries preserve legacy call-table layout and tail-call target helpers.
; Arguments/return values pass through unchanged unless noted in each header.

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   COI_SelectAnimFieldPointer
; DESC:
;   Jump table entry that forwards to COI_SelectAnimFieldPointer.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer:
    JMP     COI_SelectAnimFieldPointer

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_SetCurrentLineIndex
; DESC:
;   Jump table entry that forwards to DISPTEXT_SetCurrentLineIndex.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex:
    JMP     DISPTEXT_SetCurrentLineIndex

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_LayoutAndAppendToBuffer
; DESC:
;   Jump table entry that forwards to DISPTEXT_LayoutAndAppendToBuffer.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer:
    JMP     DISPTEXT_LayoutAndAppendToBuffer

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   DISPTEXT_GetTotalLineCount
; DESC:
;   Jump table entry that forwards to DISPTEXT_GetTotalLineCount.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount:
    JMP     DISPTEXT_GetTotalLineCount

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   TLIBA_FindFirstWildcardMatchIndex
; DESC:
;   Jump table entry that forwards to TLIBA_FindFirstWildcardMatchIndex.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex:
    JMP     TLIBA_FindFirstWildcardMatchIndex

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   DISPTEXT_BuildLayoutForSource
; DESC:
;   Jump table entry that forwards to DISPTEXT_BuildLayoutForSource.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource:
    JMP     DISPTEXT_BuildLayoutForSource

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawBevelFrameWithTopRight
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBevelFrameWithTopRight.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight:
    JMP     BEVEL_DrawBevelFrameWithTopRight

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQDISP_GetEntryAuxPointerByMode
; DESC:
;   Jump table entry that forwards to ESQDISP_GetEntryAuxPointerByMode.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode:
    JMP     ESQDISP_GetEntryAuxPointerByMode

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawVerticalBevel
; DESC:
;   Jump table entry that forwards to BEVEL_DrawVerticalBevel.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel:
    JMP     BEVEL_DrawVerticalBevel

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_LayoutSourceToLines
; DESC:
;   Jump table entry that forwards to DISPTEXT_LayoutSourceToLines.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines:
    JMP     DISPTEXT_LayoutSourceToLines

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   CLEANUP_UpdateEntryFlagBytes
; DESC:
;   Jump table entry that forwards to CLEANUP_UpdateEntryFlagBytes.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes:
    JMP     CLEANUP_UpdateEntryFlagBytes

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   COI_RenderClockFormatEntryVariant
; DESC:
;   Jump table entry that forwards to COI_RenderClockFormatEntryVariant.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant:
    JMP     COI_RenderClockFormatEntryVariant

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQDISP_TestEntryBits0And2
; DESC:
;   Jump table entry that forwards to ESQDISP_TestEntryBits0And2.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2:
    JMP     ESQDISP_TestEntryBits0And2

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_ComputeVisibleLineCount
; DESC:
;   Jump table entry that forwards to DISPTEXT_ComputeVisibleLineCount.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount:
    JMP     DISPTEXT_ComputeVisibleLineCount

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQDISP_GetEntryPointerByMode
; DESC:
;   Jump table entry that forwards to ESQDISP_GetEntryPointerByMode.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode:
    JMP     ESQDISP_GetEntryPointerByMode

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_RenderCurrentLine
; DESC:
;   Jump table entry that forwards to DISPTEXT_RenderCurrentLine.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine:
    JMP     DISPTEXT_RenderCurrentLine

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   COI_ProcessEntrySelectionState
; DESC:
;   Jump table entry that forwards to COI_ProcessEntrySelectionState.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState:
    JMP     COI_ProcessEntrySelectionState

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   CLEANUP_FormatClockFormatEntry
; DESC:
;   Jump table entry that forwards to CLEANUP_FormatClockFormatEntry.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry:
    JMP     CLEANUP_FormatClockFormatEntry

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawBevelFrameWithTop
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBevelFrameWithTop.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop:
    JMP     BEVEL_DrawBevelFrameWithTop

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQ_GetHalfHourSlotIndex
; DESC:
;   Jump table entry that forwards to ESQ_GetHalfHourSlotIndex.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex:
    JMP     ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_STR_SkipClass3Chars   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   STR_SkipClass3Chars
; DESC:
;   Jump table entry that forwards to STR_SkipClass3Chars.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_STR_SkipClass3Chars:
    JMP     STR_SkipClass3Chars

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_STRING_AppendN   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   STRING_AppendN
; DESC:
;   Jump table entry that forwards to STRING_AppendN.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_STRING_AppendN:
    JMP     STRING_AppendN

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQDISP_ComputeScheduleOffsetForRow
; DESC:
;   Jump table entry that forwards to ESQDISP_ComputeScheduleOffsetForRow.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow:
    JMP     ESQDISP_ComputeScheduleOffsetForRow

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   PARSE_ReadSignedLongSkipClass3_Alt
; DESC:
;   Jump table entry that forwards to PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    JMP     PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   CLEANUP_TestEntryFlagYAndBit1
; DESC:
;   Jump table entry that forwards to CLEANUP_TestEntryFlagYAndBit1.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1:
    JMP     CLEANUP_TestEntryFlagYAndBit1

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_IsCurrentLineLast
; DESC:
;   Jump table entry that forwards to DISPTEXT_IsCurrentLineLast.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast:
    JMP     DISPTEXT_IsCurrentLineLast

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_IsLastLineSelected
; DESC:
;   Jump table entry that forwards to DISPTEXT_IsLastLineSelected.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected:
    JMP     DISPTEXT_IsLastLineSelected

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawBeveledFrame
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBeveledFrame.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame:
    JMP     BEVEL_DrawBeveledFrame

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPLIB_FindPreviousValidEntryIndex
; DESC:
;   Jump table entry that forwards to DISPLIB_FindPreviousValidEntryIndex.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex:
    JMP     DISPLIB_FindPreviousValidEntryIndex

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_ComputeMarkerWidths
; DESC:
;   Jump table entry that forwards to DISPTEXT_ComputeMarkerWidths.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths:
    JMP     DISPTEXT_ComputeMarkerWidths

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_ESQ_TestBit1Based   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   ESQ_TestBit1Based
; DESC:
;   Jump table entry that forwards to ESQ_TestBit1Based.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_ESQ_TestBit1Based:
    JMP     ESQ_TestBit1Based

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawVerticalBevelPair
; DESC:
;   Jump table entry that forwards to BEVEL_DrawVerticalBevelPair.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair:
    JMP     BEVEL_DrawVerticalBevelPair

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_MeasureCurrentLineLength
; DESC:
;   Jump table entry that forwards to DISPTEXT_MeasureCurrentLineLength.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength:
    JMP     DISPTEXT_MeasureCurrentLineLength

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_SetLayoutParams
; DESC:
;   Jump table entry that forwards to DISPTEXT_SetLayoutParams.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams:
    JMP     DISPTEXT_SetLayoutParams

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPTEXT_HasMultipleLines
; DESC:
;   Jump table entry that forwards to DISPTEXT_HasMultipleLines.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines:
    JMP     DISPTEXT_HasMultipleLines

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   BEVEL_DrawHorizontalBevel
; DESC:
;   Jump table entry that forwards to BEVEL_DrawHorizontalBevel.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel:
    JMP     BEVEL_DrawHorizontalBevel

;!======

    RTS

;!======

    ; Alignment
    ALIGN_WORD
