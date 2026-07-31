    XDEF    PARSEINI_UpdateClockFromRtc
    XDEF    PARSEINI_WriteRtcFromGlobals


;------------------------------------------------------------------------------
; FUNC: PARSEINI_WriteRtcFromGlobals   (Write globals to RTC chip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0/A6
; CALLS:
;   _PARSEINI_AdjustHoursTo24HrFormat, PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch,
;   PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch, PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock
; READS:
;   _CLOCK_DaySlotIndex-E, _CLOCK_CacheAmPmFlag, _Global_REF_UTILITY_LIBRARY, _Global_REF_BATTCLOCK_RESOURCE,
;   _Global_REF_CLOCKDATA_STRUCT
; WRITES:
;   RTC chip via BATTCLOCK_WriteSecondsToBatteryBackedClock
; DESC:
;   Converts current global date/time fields to a legal struct and writes them
;   to the battery-backed clock if the RTC resources are available.
; NOTES:
;   Early-exits if utility library or battclock resource is unavailable.
;------------------------------------------------------------------------------
PARSEINI_WriteRtcFromGlobals:
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
    JSR     PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

    ; Clean the stack and test validity of clockdata struct seconds
    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return

    PEA     .clockDataStruct(A5)
    JSR     PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    JSR     PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_UpdateClockFromRtc   (UpdateClockFromRtcuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none (status is implicit via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock, PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData,
;   PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch, PARSEINI_NormalizeClockData
; READS:
;   _Global_REF_UTILITY_LIBRARY, _Global_REF_BATTCLOCK_RESOURCE
; WRITES:
;   _CLOCK_DaySlotIndex (date/time fields via PARSEINI_NormalizeClockData)
; DESC:
;   Reads the battery-backed clock, validates the resulting date/time fields,
;   and updates the global date/time structure used by the UI.
; NOTES:
;   If the clock data is invalid or unavailable, a fallback/default is written.
;------------------------------------------------------------------------------
PARSEINI_UpdateClockFromRtc:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)

.clockData  = -18
.localSec   = -28
.localMin   = -30
.localHour  = -32
.localYear  = -34
.localMDay  = -36
.localMonth = -38
.localWDay  = -40

    TST.L   _Global_REF_UTILITY_LIBRARY
    BEQ.W   .return_status

    TST.L   _Global_REF_BATTCLOCK_RESOURCE
    BEQ.W   .return_status

    JSR     PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(PC)

    MOVE.L  D0,D7
    PEA     .clockData(A5)
    MOVE.L  D7,-(A7)
    JSR     PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(PC)

    PEA     .clockData(A5)
    JSR     PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   .fallback_default_date

    MOVE.W  (.clockData+Struct_ClockData__WDay)(A5),D0
    MOVE.W  D0,.localWDay(A5)

    MOVE.W  (.clockData+Struct_ClockData__Month)(A5),D1
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,.localMonth(A5)  ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__MDay)(A5),D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,.localMDay(A5)   ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__Year)(A5),D3
    MOVE.W  D3,.localYear(A5)

    MOVE.W  (.clockData+Struct_ClockData__Hour)(A5),D4
    MOVE.W  D4,.localHour(A5)

    MOVE.W  (.clockData+Struct_ClockData__Min)(A5),D5
    MOVE.W  D5,.localMin(A5)

    MOVE.W  (.clockData+Struct_ClockData__Sec)(A5),D6
    MOVE.W  D6,.localSec(A5)

    MOVE.W  _DST_PrimaryCountdown,-26(A5)

    MOVEQ   #0,D6
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #6,D5
    CMP.W   D5,D0
    BHI.S   .invalid_date_data

    CMP.W   D6,D1
    BCS.S   .invalid_date_data

    MOVEQ   #11,D0      ; Month?
    CMP.W   D0,D1
    BHI.S   .invalid_date_data

    CMP.W   D6,D2
    BCS.S   .invalid_date_data

    MOVEQ   #31,D0      ; Day number
    CMP.W   D0,D2
    BHI.S   .invalid_date_data

    CMP.W   D6,D3
    BCS.S   .invalid_date_data

    CMPI.W  #9999,D3    ; Year
    BHI.S   .invalid_date_data

    CMP.W   D6,D4
    BCS.S   .invalid_date_data

    MOVEQ   #23,D0      ; Hour
    CMP.W   D0,D4
    BHI.S   .invalid_date_data

    MOVE.W  -16(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #59,D1      ; Minutes
    CMP.W   D1,D0
    BHI.S   .invalid_date_data

    MOVE.W  -18(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    CMP.W   D1,D0

.invalid_date_data:
    PEA     -40(A5)
    PEA     _CLOCK_DaySlotIndex
    BSR.W   PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7
    BRA.S   .return_status

.fallback_default_date:
    PEA     PARSEINI_FallbackClockDataRecord
    PEA     _CLOCK_DaySlotIndex
    BSR.W   PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7

.return_status:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======