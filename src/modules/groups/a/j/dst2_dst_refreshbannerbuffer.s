    XDEF    _DST_RefreshBannerBuffer


;------------------------------------------------------------------------------
; FUNC: _DST_RefreshBannerBuffer   (Copy the next banner entry into the staging buffer.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   _DST_TickBannerCounters, _DST_AddTimeOffset
; READS:
;   _CLOCK_DaySlotIndex, _DST_SecondaryCountdown, _WDISP_BannerCharPhaseShift, _CLOCK_FormatVariantCode
; WRITES:
;   _CLOCK_CurrentDayOfWeekIndex, _DST_SecondaryCountdown
; DESC:
;   Updates counters, copies the queue state into staging, and writes timestamps.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
; Copy the next banner entry into the staging buffer and trigger drawing.
_DST_RefreshBannerBuffer:
    MOVE.L  D7,-(A7)
    BSR.W   _DST_TickBannerCounters

    MOVE.W  _DST_SecondaryCountdown,D7
    LEA     _CLOCK_DaySlotIndex,A0
    LEA     _CLOCK_CurrentDayOfWeekIndex,A1
    MOVEQ   #4,D0

    ; Copy current queue state into staging buffer.
.copy_queue_state:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_queue_state
    MOVE.W  (A0),(A1)
    MOVE.W  D7,_DST_SecondaryCountdown
    MOVE.W  _WDISP_BannerCharPhaseShift,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  _CLOCK_FormatVariantCode,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _CLOCK_CurrentDayOfWeekIndex
    BSR.W   _DST_AddTimeOffset

    LEA     12(A7),A7
    MOVE.L  (A7)+,D7
    RTS

;!======