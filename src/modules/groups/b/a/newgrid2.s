;------------------------------------------------------------------------------
; FUNC: NEWGRID2_ProcessGridState   (Process grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry struct
;   stack +16: D7 = key/index
; RET:
;   D0: current state (DATA_NEWGRID_CONST_LONG_203D)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID_TestPrimeTimeWindow, NEWGRID_DrawGridEntry, SCRIPT_JMPTBL_MEMORY_AllocateMemory,
;   NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_AppendShowtimesForRow, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   SCRIPT_JMPTBL_MEMORY_DeallocateMemory, NEWGRID_DrawGridFrameVariant4, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   DATA_NEWGRID_CONST_LONG_203D, DATA_NEWGRID_CONST_WORD_2016
; WRITES:
;   DATA_NEWGRID_CONST_LONG_203D, 32(A3)
; DESC:
;   Executes a state machine to render/update the grid, allocate buffers, and
;   advance to the next UI state.
; NOTES:
;   Uses DATA_NEWGRID_CONST_LONG_203D to track state 4/5 transitions.
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
    BNE.S   .state_check_current

    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_203D
    BRA.W   .return_state

.state_check_current:
    MOVE.L  DATA_NEWGRID_CONST_LONG_203D,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_draw_and_layout

    SUBQ.L  #1,D0
    BEQ.W   .state5_frame_only

    BRA.W   .force_state4_reset

.state4_draw_and_layout:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    PEA     1.W
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D6
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .entry_index_ok

    SUBI.W  #$30,D6

.entry_index_ok:
    TST.W   DATA_NEWGRID_CONST_WORD_2016
    BEQ.S   .draw_alt_variant

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID_TestPrimeTimeWindow

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.S   .draw_alt_variant

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
    BRA.S   .allocate_text_buffer

.draw_alt_variant:
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

.allocate_text_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     2000.W
    PEA     3947.W
    PEA     Global_STR_NEWGRID2_C_1
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .post_alloc

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

.post_alloc:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state5_after_frame

    MOVEQ   #4,D0
    BRA.S   .store_state_and_count

.set_state5_after_frame:
    MOVEQ   #5,D0

.store_state_and_count:
    PEA     2.W
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_203D
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_frame_only:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_set_value

    MOVEQ   #4,D0
    BRA.S   .state5_store_value

.state5_set_value:
    MOVEQ   #5,D0

.state5_store_value:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_203D
    BRA.S   .return_state

.force_state4_reset:
    MOVEQ   #4,D0
    MOVE.L  D0,DATA_NEWGRID_CONST_LONG_203D

.return_state:
    MOVE.L  DATA_NEWGRID_CONST_LONG_203D,D0
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
;------------------------------------------------------------------------------
NEWGRID2_HandleGridState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_state

    MOVEQ   #5,D0
    CMP.L   NEWGRID2_DispatchStateIndex,D0
    BNE.S   .reset_state

    MOVE.L  D6,-(A7)
    PEA     DATA_WDISP_BSS_LONG_2332
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.dispatch_state:
    MOVE.L  NEWGRID2_DispatchStateIndex,D0
    CMPI.L  #$6,D0
    BCC.W   .state_done

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
    PEA     DATA_WDISP_BSS_LONG_2332
    BSR.W   NEWGRID_InitSelectionWindowAlt

    LEA     12(A7),A7

.state1_update_selection:
    MOVE.L  D6,-(A7)
    PEA     DATA_WDISP_BSS_LONG_2332
    MOVE.L  NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInputAlt

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .state1_no_selection

    ; Selection became valid: show prompt, then move into state 3.
    MOVE.L  D6,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_2332,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawShowtimesPrompt

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEQ   #3,D1
    MOVE.L  D1,NEWGRID2_DispatchStateIndex
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2040
    BRA.W   .return_state

.state1_no_selection:
    CLR.L   NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.state3_update_selection:
    MOVE.L  D6,-(A7)
    PEA     DATA_WDISP_BSS_LONG_2332
    MOVE.L  NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInputAlt

    MOVE.L  D6,(A7)
    BSR.W   NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    MOVE.L  D0,D5

.state5_process_grid:
    TST.L   DATA_WDISP_BSS_LONG_2332
    BEQ.S   .state5_no_selection

    MOVE.L  D6,-(A7)
    PEA     DATA_WDISP_BSS_LONG_2332
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    MOVE.L  D6,(A7)
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BSR.W   NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return_state

    TST.L   D5
    BEQ.S   .state5_skip_hint

    ; First-entry hint: cache mode index once, then offset by column delta.
    CMPI.L  #$1,DATA_NEWGRID2_BSS_LONG_2040
    BGE.S   .state5_skip_hint

    PEA     50.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2040

.state5_skip_hint:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,DATA_NEWGRID2_BSS_LONG_2040
    BRA.S   .return_state

.state5_no_selection:
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID2_DispatchStateIndex
    BRA.S   .return_state

.state2_finish:
.state_done:
    CLR.L   NEWGRID2_DispatchStateIndex

.return_state:
    TST.L   NEWGRID2_DispatchStateIndex
    BNE.S   .skip_state_reset

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7

.skip_state_reset:
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
;   DATA_ESQDISP_BSS_WORD_1E86, DATA_NEWGRID2_BSS_LONG_2042
; WRITES:
;   NEWGRID_GridOperationId, DATA_NEWGRID2_BSS_LONG_2042, DATA_NEWGRID2_BSS_LONG_2043
; DESC:
;   Dispatches a grid operation by index using a switch/jumptable.
; NOTES:
;   Booleanizes the return value via SNE/NEG/EXT.
;   If operation id is zero, reuses the pending id in DATA_NEWGRID2_BSS_LONG_2042.
;------------------------------------------------------------------------------
NEWGRID2_DispatchGridOperation:
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D6
    MOVE.W  34(A7),D5
    TST.L   D7
    BNE.S   .store_pending_index

    SUBA.L  A3,A3
    MOVE.L  DATA_NEWGRID2_BSS_LONG_2042,D7
    CLR.L   DATA_NEWGRID2_BSS_LONG_2042
    BRA.S   .prepare_index

.store_pending_index:
    MOVE.L  D7,DATA_NEWGRID2_BSS_LONG_2042

.prepare_index:
    TST.W   DATA_ESQDISP_BSS_WORD_1E86
    BEQ.S   .after_reset_check

    CLR.W   DATA_ESQDISP_BSS_WORD_1E86
    SUBA.L  A3,A3

.after_reset_check:
    MOVE.L  D7,NEWGRID_GridOperationId
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   .out_of_range

    CMPI.L  #$7,D0
    BGE.W   .out_of_range

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
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.W   .return_bool

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
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.W   .return_bool

.op3_handle_grid_state:
    MOVE.L  D6,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.S   .return_bool

.op4_handle_grid_state_alt:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.S   .return_bool

.op5_process_secondary_state:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ProcessSecondaryState

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.S   .return_bool

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
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.S   .return_bool

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
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2043
    BRA.S   .return_bool

.out_of_range:
    CLR.L   NEWGRID_GridOperationId

.return_bool:
    TST.L   DATA_NEWGRID2_BSS_LONG_2043
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
;   DATA_NEWGRID2_CONST_LONG_2044
; WRITES:
;   NEWGRID_SecondaryIndexCachePtr, NEWGRID_EntryTextScratchPtr, DATA_NEWGRID2_CONST_LONG_2044
; DESC:
;   Allocates the grid backing buffers when the request flag is set.
; NOTES:
;   Allocates 1208-byte index cache plus 1000-byte text scratch, then clears
;   DATA_NEWGRID2_CONST_LONG_2044 to mark allocation complete.
;------------------------------------------------------------------------------
NEWGRID2_EnsureBuffersAllocated:
    TST.L   DATA_NEWGRID2_CONST_LONG_2044
    BEQ.S   .done

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
    CLR.L   DATA_NEWGRID2_CONST_LONG_2044
    MOVE.L  D0,NEWGRID_EntryTextScratchPtr

.done:
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
    BEQ.S   .done

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

.done:
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
; FUNC: NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   UNKNOWN7_SkipCharClass3
; DESC:
;   Jump table entry that forwards to UNKNOWN7_SkipCharClass3.
;------------------------------------------------------------------------------
NEWGRID2_JMPTBL_UNKNOWN7_SkipCharClass3:
    JMP     UNKNOWN7_SkipCharClass3

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
