    XDEF    _BATTCLOCK_WriteSecondsToBatteryBackedClock


;------------------------------------------------------------------------------
; FUNC: _BATTCLOCK_WriteSecondsToBatteryBackedClock   (Write seconds to the battery-backed clock.)
; ARGS:
;   stack +8: D0 = seconds since Amiga epoch
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A6
; CALLS:
;   _LVOWriteBattClock
;------------------------------------------------------------------------------
_BATTCLOCK_WriteSecondsToBatteryBackedClock:
    MOVE.L  A6,-(A7)

    MOVEA.L _Global_REF_BATTCLOCK_RESOURCE,A6
    MOVE.L  8(A7),D0
    JSR     _LVOWriteBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======