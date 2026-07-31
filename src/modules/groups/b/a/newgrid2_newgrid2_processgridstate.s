    XDEF    _NEWGRID2_ProcessGridState



;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_ProcessGridState   (Process grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry struct
;   stack +16: D7 = key/index
; RET:
;   D0: current state (_NEWGRID_RenderStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, _NEWGRID_TestPrimeTimeWindow, _NEWGRID_DrawGridEntry, _SCRIPT_JMPTBL_MEMORY_AllocateMemory,
;   _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, _NEWGRID_AppendShowtimesForRow, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   _SCRIPT_JMPTBL_MEMORY_DeallocateMemory, _NEWGRID_DrawGridFrameVariant4, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   _NEWGRID_RenderStateLatch, _NEWGRID_PrimeTimeLayoutEnable
; WRITES:
;   _NEWGRID_RenderStateLatch, 32(A3)
; DESC:
;   Executes a state machine to render/update the grid, allocate buffers, and
;   advance to the next UI state.
; NOTES:
;   Uses _NEWGRID_RenderStateLatch to track state 4/5 transitions.
;   `A2+0/A2+4` are required entry payload pointers and `A2+20` carries
;   row-relative selection/slot index used for draw/layout.
;------------------------------------------------------------------------------
_NEWGRID2_ProcessGridState:
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
    MOVE.L  D0,_NEWGRID_RenderStateLatch
    BRA.W   .return_state

.dispatch_render_state:
    MOVE.L  _NEWGRID_RenderStateLatch,D0
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
    TST.W   _NEWGRID_PrimeTimeLayoutEnable
    BEQ.S   .draw_grid_entry_alt_variant

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_TestPrimeTimeWindow

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
    PEA     _Global_STR_NEWGRID2_C_1
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .draw_frame_after_showtimes

    PEA     3.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    MOVE.L  D7,(A7)
    MOVE.L  -6(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_AppendShowtimesForRow

    LEA     60(A3),A0
    MOVE.L  -6(A5),(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    PEA     2000.W
    MOVE.L  -6(A5),-(A7)
    PEA     3953.W
    PEA     _Global_STR_NEWGRID2_C_2
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     36(A7),A7

.draw_frame_after_showtimes:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state5_for_frame_only_followup

    MOVEQ   #4,D0                           ; state 4 = full draw/layout pass
    BRA.S   .store_next_state_and_visible_count

.set_state5_for_frame_only_followup:
    MOVEQ   #5,D0                           ; state 5 = frame-only follow-up

.store_next_state_and_visible_count:
    PEA     2.W
    MOVE.L  D0,_NEWGRID_RenderStateLatch
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)                      ; A3+32 = visible-line count cache
    BRA.S   .return_state

.state5_redraw_frame_only:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant4

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
    MOVE.L  D0,_NEWGRID_RenderStateLatch
    BRA.S   .return_state

.force_state4_recovery:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_RenderStateLatch

.return_state:
    MOVE.L  _NEWGRID_RenderStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======