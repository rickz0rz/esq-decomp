    XDEF    _NEWGRID2_HandleGridState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_HandleGridState   (Handle grid state transitions)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = row index
;   stack +16: D6 = selection-mode selector (commonly 0 or 1)
; RET:
;   D0: state (_NEWGRID2_DispatchStateIndex)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_ProcessGridState, _NEWGRID_InitSelectionWindowAlt, _NEWGRID_UpdateSelectionFromInputAlt
; READS:
;   _NEWGRID2_DispatchStateIndex
; WRITES:
;   _NEWGRID2_DispatchStateIndex
; DESC:
;   State machine wrapper around _NEWGRID2_ProcessGridState with jump table dispatch.
; NOTES:
;   Uses _NEWGRID2_DispatchStateIndex as a 0..5 state index.
;   State 5 performs the main per-row processing via _NEWGRID2_ProcessGridState.
;   Jump table maps states `3` and `4` to the same update-selection handler.
;------------------------------------------------------------------------------
_NEWGRID2_HandleGridState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_by_state_index

    MOVEQ   #5,D0                           ; state 5 = active per-row grid processing
    CMP.L   _NEWGRID2_DispatchStateIndex,D0
    BNE.S   .reset_state

    MOVE.L  D6,-(A7)
    PEA     _NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID2_ProcessGridState

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.dispatch_by_state_index:
    MOVE.L  _NEWGRID2_DispatchStateIndex,D0
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
    PEA     _NEWGRID2_ShowtimesSelectionContextPtr
    BSR.W   _NEWGRID_InitSelectionWindowAlt

    LEA     12(A7),A7

.state1_update_selection:
    MOVE.L  D6,-(A7)
    PEA     _NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInputAlt

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .state1_abort_and_reset

    ; Selection became valid: show prompt, then move into state 3.
    MOVE.L  D6,-(A7)
    MOVE.L  _NEWGRID2_ShowtimesSelectionContextPtr,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawShowtimesPrompt

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEQ   #3,D1                           ; advance into state3/state4 shared path
    MOVE.L  D1,_NEWGRID2_DispatchStateIndex
    MOVE.L  D0,_NEWGRID2_CachedModeIndex
    BRA.W   .return_state

.state1_abort_and_reset:
    CLR.L   _NEWGRID2_DispatchStateIndex
    BRA.W   .return_state

.state3_update_selection:
    MOVE.L  D6,-(A7)
    PEA     _NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID2_DispatchStateIndex,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInputAlt

    MOVE.L  D6,(A7)
    BSR.W   _NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    MOVE.L  D0,D5

.state5_process_grid:
    TST.L   _NEWGRID2_ShowtimesSelectionContextPtr
    BEQ.S   .state5_restart_selection_update

    MOVE.L  D6,-(A7)
    PEA     _NEWGRID2_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID2_ProcessGridState

    MOVE.L  D6,(A7)
    MOVE.L  D0,_NEWGRID2_DispatchStateIndex
    BSR.W   _NEWGRID_TestModeFlagActive

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return_state

    TST.L   D5
    BEQ.S   .state5_apply_column_delta_only

    ; First-entry hint: cache mode index once, then offset by column delta.
    CMPI.L  #$1,_NEWGRID2_CachedModeIndex
    BGE.S   .state5_apply_column_delta_only

    PEA     50.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID2_CachedModeIndex

.state5_apply_column_delta_only:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID2_CachedModeIndex
    BRA.S   .return_state

.state5_restart_selection_update:
    MOVEQ   #1,D0                           ; restart from "update selection" state
    MOVE.L  D0,_NEWGRID2_DispatchStateIndex
    BRA.S   .return_state

.state2_finish:
.clear_dispatch_state:
    CLR.L   _NEWGRID2_DispatchStateIndex

.return_state:
    TST.L   _NEWGRID2_DispatchStateIndex
    BNE.S   .skip_marker_clear

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   _NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7

.skip_marker_clear:
    MOVE.L  _NEWGRID2_DispatchStateIndex,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======