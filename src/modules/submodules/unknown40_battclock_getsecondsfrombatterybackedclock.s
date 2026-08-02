    XDEF    _BATTCLOCK_GetSecondsFromBatteryBackedClock



;------------------------------------------------------------------------------
; FUNC: _BATTCLOCK_GetSecondsFromBatteryBackedClock   (Read seconds from the battery-backed clock.)
; ARGS:
;   none
; RET:
;   D0: seconds since Amiga epoch
; CLOBBERS:
;   D0/A6
; CALLS:
;   _LVOReadBattClock
;------------------------------------------------------------------------------
_BATTCLOCK_GetSecondsFromBatteryBackedClock:
    MOVE.L  A6,-(A7)

    MOVEA.L _Global_REF_BATTCLOCK_RESOURCE,A6
    JSR     _LVOReadBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======