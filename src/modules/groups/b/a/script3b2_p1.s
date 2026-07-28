    XDEF    SCRIPT_ProcessCtrlContextPlaybackTick


;------------------------------------------------------------------------------
; FUNC: SCRIPT_ProcessCtrlContextPlaybackTick   (ProcessCtrlContextPlaybackTick)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1/D2
; CALLS:
;   SCRIPT_ApplyPendingBannerTarget, SCRIPT_UpdateRuntimeModeForPlaybackCursor, _SCRIPT_DispatchPlaybackCursorCommand, SCRIPT_LoadCtrlContextSnapshot, _SCRIPT_SaveCtrlContextSnapshot, SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
; READS:
;   _CONFIG_MSN_FlagChar, SCRIPT_RuntimeModeDispatchLatch, SCRIPT_RuntimeModeDeferredFlag, _LOCAVAIL_PrimaryFilterState, _SCRIPT_RuntimeMode, _SCRIPT_PlaybackCursor, _TEXTDISP_CurrentMatchIndex
; WRITES:
;   SCRIPT_RuntimeModeDispatchLatch, SCRIPT_RuntimeModeDeferredFlag, _SCRIPT_RuntimeMode, _SCRIPT_PlaybackCursor, TEXTDISP_CurrentMatchIndexSaved
; DESC:
;   Loads context state, applies mode/cursor gating, runs playback-command
;   dispatch, then saves the updated state back into the context snapshot.
; NOTES:
;   Playback cursor dispatch is only attempted for cursor values 1..15.
;------------------------------------------------------------------------------
SCRIPT_ProcessCtrlContextPlaybackTick:
    MOVEM.L D2/A3,-(A7)
    MOVEA.L 12(A7),A3
    PEA     _LOCAVAIL_PrimaryFilterState
    MOVE.L  A3,-(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(PC)

    MOVE.L  A3,(A7)
    BSR.W   SCRIPT_LoadCtrlContextSnapshot

    ADDQ.W  #8,A7
    TST.L   SCRIPT_RuntimeModeDeferredFlag
    BEQ.S   .playback_tick_apply_pending_mode_change

    MOVEQ   #3,D0
    MOVE.W  D0,_SCRIPT_RuntimeMode
    MOVEQ   #0,D0
    MOVE.L  D0,SCRIPT_RuntimeModeDeferredFlag

.playback_tick_apply_pending_mode_change:
    MOVE.B  _CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .playback_tick_gate_cursor_for_m_mode

    MOVE.L  _SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #2,D2
    MOVE.L  D2,_SCRIPT_PlaybackCursor

.playback_tick_gate_cursor_for_m_mode:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .playback_tick_maybe_dispatch_cursor

    TST.W   SCRIPT_RuntimeModeDispatchLatch
    BEQ.S   .playback_tick_clear_runtime_latch

    MOVE.L  _SCRIPT_PlaybackCursor,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BLE.S   .playback_tick_clear_runtime_latch

.playback_tick_maybe_dispatch_cursor:
    MOVE.L  _SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #15,D1
    CMP.L   D1,D0
    BGT.S   .return

    BSR.W   SCRIPT_UpdateRuntimeModeForPlaybackCursor

    TST.W   D0
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   _SCRIPT_PlaybackCursor,D0
    BEQ.S   .playback_tick_dispatch_cursor

    BSR.W   SCRIPT_ApplyPendingBannerTarget

.playback_tick_dispatch_cursor:
    PEA     _SCRIPT_PlaybackCursor
    BSR.W   _SCRIPT_DispatchPlaybackCursorCommand

    ADDQ.W  #4,A7
    BRA.S   .return

.playback_tick_clear_runtime_latch:
    CLR.W   SCRIPT_RuntimeModeDispatchLatch

.return:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,TEXTDISP_CurrentMatchIndexSaved
    MOVE.L  A3,-(A7)
    BSR.W   _SCRIPT_SaveCtrlContextSnapshot

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A3
    RTS

;!======
