    XDEF    _ESQFUNC_UpdateRefreshModeState


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_UpdateRefreshModeState   (UpdateRefreshModeState)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _ESQSHARED4_ComputeBannerRowBlitGeometry
; READS:
;   _NEWGRID_MessagePumpSuspendFlag, NEWGRID_LastRefreshRequest
; WRITES:
;   ESQFUNC_WeatherSliceWidthInitGate, _ESQPARS2_BannerRowWidthBytes, _ESQPARS2_BannerCopyBlockSpanBytes, _NEWGRID_RefreshStateFlag, _NEWGRID_MessagePumpSuspendFlag, _NEWGRID_ModeSelectorState, NEWGRID_LastRefreshRequest
; DESC:
;   Updates NEWGRID refresh/mode selector state from the incoming request flag
;   and recomputes banner blit geometry when message-pump suspension is cleared.
; NOTES:
;   Writes NEWGRID_LastRefreshRequest every call; uses mode 0 vs 2 selector states.
;------------------------------------------------------------------------------
_ESQFUNC_UpdateRefreshModeState:
    LINK.W  A5,#0

    MOVE.L  D7,-(A7)
    MOVE.L  12(A5),D7
    MOVE.W  #1,ESQFUNC_WeatherSliceWidthInitGate
    TST.L   _NEWGRID_MessagePumpSuspendFlag
    BEQ.S   .apply_mode_selector_state

    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    MOVE.L  D0,_NEWGRID_MessagePumpSuspendFlag
    MOVE.W  #$90,_ESQPARS2_BannerRowWidthBytes
    MOVE.W  #$230,_ESQPARS2_BannerCopyBlockSpanBytes
    BSR.W   _ESQSHARED4_ComputeBannerRowBlitGeometry

.apply_mode_selector_state:
    TST.L   D7
    BNE.S   .set_mode_selector_two

    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ModeSelectorState
    BRA.S   .store_last_refresh_request

.set_mode_selector_two:
    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ModeSelectorState
    TST.L   NEWGRID_LastRefreshRequest
    BNE.S   .store_last_refresh_request

    CLR.L   _NEWGRID_RefreshStateFlag

.store_last_refresh_request:
    MOVE.L  D7,NEWGRID_LastRefreshRequest
    MOVE.L  (A7)+,D7

    UNLK    A5
    RTS

;!======