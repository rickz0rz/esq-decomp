;------------------------------------------------------------------------------
; FUNC: PARSEINI_WriteRtcFromGlobals   (Write globals to RTC chip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0/A6
; CALLS:
;   PARSEINI_AdjustHoursTo24HrFormat, JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch,
;   JMPTBL_CLOCK_SecondsFromEpoch, JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock
; READS:
;   LAB_223A-E, LAB_2243, GLOB_REF_UTILITY_LIBRARY, GLOB_REF_BATTCLOCK_RESOURCE,
;   GLOB_REF_CLOCKDATA_STRUCT
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

    TST.L   GLOB_REF_UTILITY_LIBRARY
    BEQ.W   .return

    TST.L   GLOB_REF_BATTCLOCK_RESOURCE
    BEQ.S   .return

    MOVE.W  LAB_223A,D0
    MOVE.W  D0,-6(A5)
    MOVE.W  LAB_223B,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,-10(A5)
    MOVE.W  LAB_223C,D0
    MOVE.W  D0,-12(A5)
    MOVE.W  LAB_223D,D0
    MOVE.W  D0,-8(A5)
    MOVE.W  LAB_223E,D0
    EXT.L   D0
    MOVE.W  LAB_2243,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   PARSEINI_AdjustHoursTo24HrFormat

    MOVE.W  D0,-14(A5)
    MOVE.W  LAB_223F,D0
    MOVE.W  D0,-16(A5)
    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  D0,.clockDataStruct(A5)
    PEA     .clockDataStruct(A5)
    JSR     JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

    ; Clean the stack and test validity of clockdata struct seconds
    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return

    PEA     .clockDataStruct(A5)
    JSR     JMPTBL_CLOCK_SecondsFromEpoch(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    JSR     JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_UpdateClockFromRtc   (UpdateClockFromRtc??)
; ARGS:
;   (none)
; RET:
;   D0: none (status is implicit via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock, JMPTBL_CLOCK_ConvertAmigaSecondsToClockData,
;   JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch, PARSEINI_NormalizeClockData
; READS:
;   GLOB_REF_UTILITY_LIBRARY, GLOB_REF_BATTCLOCK_RESOURCE
; WRITES:
;   LAB_223A (date/time fields via PARSEINI_NormalizeClockData)
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

    TST.L   GLOB_REF_UTILITY_LIBRARY
    BEQ.W   .return_status

    TST.L   GLOB_REF_BATTCLOCK_RESOURCE
    BEQ.W   .return_status

    JSR     JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(PC)

    MOVE.L  D0,D7
    PEA     .clockData(A5)
    MOVE.L  D7,-(A7)
    JSR     JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(PC)

    PEA     .clockData(A5)
    JSR     JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

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

    MOVE.W  LAB_2241,-26(A5)

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
    PEA     LAB_223A
    BSR.W   PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7
    BRA.S   .return_status

.fallback_default_date:
    PEA     LAB_20A1
    PEA     LAB_223A
    BSR.W   PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7

.return_status:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_AdjustHoursTo24HrFormat   (12h→24h adjust helper)
; ARGS:
;   stack +14: D7 = hour (0-12?)
;   stack +18: D6 = AM/PM flag? (-1 for PM)
; RET:
;   D0: adjusted hour (long)
; CLOBBERS:
;   D0/D1/D6-D7
; CALLS:
;   none
; READS/WRITES:
;   none (pure)
; DESC:
;   Converts 12-hour clock fields to 24-hour format: returns 0 for 12 AM,
;   adds 12 when PM flag is set and hour < 12.
; NOTES:
;   Expects flag -1 to indicate PM; keeps hour unchanged otherwise.
;------------------------------------------------------------------------------
PARSEINI_AdjustHoursTo24HrFormat:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6

    ; If we're over 12 hours, jump.
    MOVEQ   #12,D0
    CMP.W   D0,D7
    BNE.S   .add12ToHour

    ; If D6 is not 0, jump.
    TST.W   D6
    BNE.S   .add12ToHour

    ; Return 0 if we're 12 AM.
    MOVEQ   #0,D7
    BRA.S   .return

.add12ToHour:
    CMP.W   D0,D7
    BGE.S   .return

    MOVEQ   #-1,D1
    CMP.W   D1,D6
    BNE.S   .return

    ADDI.W  #12,D7

.return:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_NormalizeClockData   (Normalize/validate clock data struct??)
; ARGS:
;   stack +8: A3 = clockdata dest struct
;   stack +12: A2 = source struct
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A3
; CALLS:
;   JMPTBL_DATETIME_IsLeapYear (DATETIME_IsLeapYear), JMPTBL_ESQ_CalcDayOfYearFromMonthDay (ESQ_CalcDayOfYearFromMonthDay)
; READS:
;   A2 contents
; WRITES:
;   A3 contents (year/month/day/hour/min/sec, wday), LAB_20A4/20A5??
; DESC:
;   Copies clock fields, adjusts year (<1900), clamps/normalizes month/day/hour,
;   computes day-of-year, and sets validity flags.
; NOTES:
;   Adds 1 to day before validation; treats month/day indices as 0-based internally.
;------------------------------------------------------------------------------
PARSEINI_NormalizeClockData:
    MOVEM.L D2/A2-A3,-(A7)

.localYear  = 6
.localMonth = 8

    SetOffsetForStack 3

    MOVEA.L (.stackOffsetBytes+4)(A7),A3
    MOVEA.L (.stackOffsetBytes+8)(A7),A2

    MOVEA.L A2,A0
    MOVEA.L A3,A1
    MOVEQ   #4,D0

.loopWhileA0IsNotNull:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loopWhileA0IsNotNull

    MOVE.W  (A0),(A1)
    MOVE.W  .localYear(A3),D0
    CMPI.W  #1900,D0
    BGE.S   .yearGreaterThan1900

    ADDI.W  #1900,6(A3)

.yearGreaterThan1900:
    MOVE.W  .localMonth(A3),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BGE.S   .set_month_invalid_flag

    MOVEQ   #0,D2
    MOVE.W  D2,18(A3)
    BRA.S   .normalize_month_zero_to_12

.set_month_invalid_flag:
    MOVE.W  #(-1),18(A3)

.normalize_month_zero_to_12:
    TST.W   8(A3)
    BNE.S   .wrap_month_over_12

    MOVE.W  D1,8(A3)

.wrap_month_over_12:
    MOVE.W  8(A3),D0
    CMP.W   D1,D0
    BLE.S   .increment_day_for_calc

    MOVEQ   #12,D1
    SUB.W   D1,8(A3)

.increment_day_for_calc:
    ADDQ.W  #1,4(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_DATETIME_IsLeapYear(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .clear_leap_flag

    MOVE.W  #(-1),20(A3)
    BRA.S   .return

.clear_leap_flag:
    CLR.W   20(A3)

.return:
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_ESQ_CalcDayOfYearFromMonthDay(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: JMPTBL_CLOCK_ConvertAmigaSecondsToClockData   (JumpStub_CLOCK_ConvertAmigaSecondsToClockData)
; ARGS:
;   ?? (see CLOCK_ConvertAmigaSecondsToClockData)
; RET:
;   ?? (see CLOCK_ConvertAmigaSecondsToClockData)
; CLOBBERS:
;   ?? (see CLOCK_ConvertAmigaSecondsToClockData)
; CALLS:
;   CLOCK_ConvertAmigaSecondsToClockData
; DESC:
;   Jump stub to CLOCK_ConvertAmigaSecondsToClockData.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_CLOCK_ConvertAmigaSecondsToClockData:
    JMP     CLOCK_ConvertAmigaSecondsToClockData

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ESQ_CalcDayOfYearFromMonthDay   (JumpStub_ESQ_CalcDayOfYearFromMonthDay)
; ARGS:
;   ?? (see ESQ_CalcDayOfYearFromMonthDay)
; RET:
;   ?? (see ESQ_CalcDayOfYearFromMonthDay)
; CLOBBERS:
;   ?? (see ESQ_CalcDayOfYearFromMonthDay)
; CALLS:
;   ESQ_CalcDayOfYearFromMonthDay
; DESC:
;   Jump stub to ESQ_CalcDayOfYearFromMonthDay.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ESQ_CalcDayOfYearFromMonthDay:
    JMP     ESQ_CalcDayOfYearFromMonthDay

;------------------------------------------------------------------------------
; FUNC: JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch   (JumpStub_CLOCK_CheckDateOrSecondsFromEpoch)
; ARGS:
;   ?? (see CLOCK_CheckDateOrSecondsFromEpoch)
; RET:
;   ?? (see CLOCK_CheckDateOrSecondsFromEpoch)
; CLOBBERS:
;   ?? (see CLOCK_CheckDateOrSecondsFromEpoch)
; CALLS:
;   CLOCK_CheckDateOrSecondsFromEpoch
; DESC:
;   Jump stub to CLOCK_CheckDateOrSecondsFromEpoch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch:
    JMP     CLOCK_CheckDateOrSecondsFromEpoch

;------------------------------------------------------------------------------
; FUNC: JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock   (JumpStub_BATTCLOCK_GetSecondsFromBatteryBackedClock)
; ARGS:
;   ?? (see BATTCLOCK_GetSecondsFromBatteryBackedClock)
; RET:
;   ?? (see BATTCLOCK_GetSecondsFromBatteryBackedClock)
; CLOBBERS:
;   ?? (see BATTCLOCK_GetSecondsFromBatteryBackedClock)
; CALLS:
;   BATTCLOCK_GetSecondsFromBatteryBackedClock
; DESC:
;   Jump stub to BATTCLOCK_GetSecondsFromBatteryBackedClock.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock:
    JMP     BATTCLOCK_GetSecondsFromBatteryBackedClock

;------------------------------------------------------------------------------
; FUNC: JMPTBL_DATETIME_IsLeapYear   (JumpStub_DATETIME_IsLeapYear)
; ARGS:
;   ?? (see DATETIME_IsLeapYear)
; RET:
;   ?? (see DATETIME_IsLeapYear)
; CLOBBERS:
;   ?? (see DATETIME_IsLeapYear)
; CALLS:
;   DATETIME_IsLeapYear
; DESC:
;   Jump stub to DATETIME_IsLeapYear.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_DATETIME_IsLeapYear:
    JMP     DATETIME_IsLeapYear

;------------------------------------------------------------------------------
; FUNC: JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock   (JumpStub_BATTCLOCK_WriteSecondsToBatteryBackedClock)
; ARGS:
;   ?? (see BATTCLOCK_WriteSecondsToBatteryBackedClock)
; RET:
;   ?? (see BATTCLOCK_WriteSecondsToBatteryBackedClock)
; CLOBBERS:
;   ?? (see BATTCLOCK_WriteSecondsToBatteryBackedClock)
; CALLS:
;   BATTCLOCK_WriteSecondsToBatteryBackedClock
; DESC:
;   Jump stub to BATTCLOCK_WriteSecondsToBatteryBackedClock.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock:
    JMP     BATTCLOCK_WriteSecondsToBatteryBackedClock

;------------------------------------------------------------------------------
; FUNC: JMPTBL_CLOCK_SecondsFromEpoch   (JumpStub_CLOCK_SecondsFromEpoch)
; ARGS:
;   ?? (see CLOCK_SecondsFromEpoch)
; RET:
;   ?? (see CLOCK_SecondsFromEpoch)
; CLOBBERS:
;   ?? (see CLOCK_SecondsFromEpoch)
; CALLS:
;   CLOCK_SecondsFromEpoch
; DESC:
;   Jump stub to CLOCK_SecondsFromEpoch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_CLOCK_SecondsFromEpoch:
    JMP     CLOCK_SecondsFromEpoch

;!======

    ; Alignment
    MOVEQ   #97,D0
