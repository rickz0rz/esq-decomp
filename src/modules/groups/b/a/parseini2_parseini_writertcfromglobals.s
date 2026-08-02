    XDEF    _PARSEINI_WriteRtcFromGlobals



;------------------------------------------------------------------------------
; FUNC: _PARSEINI_WriteRtcFromGlobals   (Write globals to RTC chip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0/A6
; CALLS:
;   _PARSEINI_AdjustHoursTo24HrFormat, _PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch,
;   _PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch, _PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock
; READS:
;   _CLOCK_DaySlotIndex-E, _CLOCK_CacheAmPmFlag, _Global_REF_UTILITY_LIBRARY, _Global_REF_BATTCLOCK_RESOURCE,
;   _Global_REF_CLOCKDATA_STRUCT
; WRITES:
;   RTC chip via _BATTCLOCK_WriteSecondsToBatteryBackedClock
; DESC:
;   Converts current global date/time fields to a legal struct and writes them
;   to the battery-backed clock if the RTC resources are available.
; NOTES:
;   Early-exits if utility library or battclock resource is unavailable.
;------------------------------------------------------------------------------
_PARSEINI_WriteRtcFromGlobals:
    LINK.W  A5,#-20
    MOVE.L  D7,-(A7)

.clockDataStruct    = -18

    TST.L   _Global_REF_UTILITY_LIBRARY
    BEQ.W   .return

    TST.L   _Global_REF_BATTCLOCK_RESOURCE
    BEQ.S   .return

    MOVE.W  _CLOCK_DaySlotIndex,D0
    MOVE.W  D0,-6(A5)
    MOVE.W  _CLOCK_CacheMonthIndex0,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,-10(A5)
    MOVE.W  _CLOCK_CacheDayIndex0,D0
    MOVE.W  D0,-12(A5)
    MOVE.W  _CLOCK_CacheYear,D0
    MOVE.W  D0,-8(A5)
    MOVE.W  _CLOCK_CacheHour,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CacheAmPmFlag,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _PARSEINI_AdjustHoursTo24HrFormat

    MOVE.W  D0,-14(A5)
    MOVE.W  _CLOCK_CacheMinuteOrSecond,D0
    MOVE.W  D0,-16(A5)
    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  D0,.clockDataStruct(A5)
    PEA     .clockDataStruct(A5)
    JSR     _PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

    ; Clean the stack and test validity of clockdata struct seconds
    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return

    PEA     .clockDataStruct(A5)
    JSR     _PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    JSR     _PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======