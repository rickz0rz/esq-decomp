    XDEF    _DST_TickBannerCounters


;------------------------------------------------------------------------------
; FUNC: _DST_TickBannerCounters   (Tick banner counters.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   (none)
; READS:
;   _ESQ_STR_6, _DST_PrimaryCountdown, _DST_SecondaryCountdown
; WRITES:
;   _WDISP_BannerCharPhaseShift
; DESC:
;   Updates banner counters based on timers and flags.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_TickBannerCounters:
    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_6,D0
    SUBI.W  #$36,D0
    MOVE.W  D0,_WDISP_BannerCharPhaseShift
    MOVE.W  _DST_PrimaryCountdown,D1
    SUBQ.W  #1,D1
    BNE.S   .after_primary_tick

    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,_WDISP_BannerCharPhaseShift

.after_primary_tick:
    MOVE.W  _DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .return

    MOVE.W  _WDISP_BannerCharPhaseShift,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_WDISP_BannerCharPhaseShift

.return:
    RTS

;!======