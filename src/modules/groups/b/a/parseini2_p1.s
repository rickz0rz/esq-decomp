    XDEF    PARSEINI_NormalizeClockData
    XDEF    PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock
    XDEF    PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock
    XDEF    PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch
    XDEF    PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData
    XDEF    PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch
    XDEF    PARSEINI2_JMPTBL_DATETIME_IsLeapYear
    XDEF    PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay


;------------------------------------------------------------------------------
; FUNC: PARSEINI_NormalizeClockData   (Normalize/validate clock data structuncertain)
; ARGS:
;   stack +8: A3 = clockdata dest struct
;   stack +12: A2 = source struct
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D2/A0-A3
; CALLS:
;   PARSEINI2_JMPTBL_DATETIME_IsLeapYear (_DATETIME_IsLeapYear), PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay (_ESQ_CalcDayOfYearFromMonthDay)
; READS:
;   A2 contents
; WRITES:
;   (none observed)
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
    JSR     PARSEINI2_JMPTBL_DATETIME_IsLeapYear(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .clear_leap_flag

    MOVE.W  #(-1),20(A3)
    BRA.S   .return

.clear_leap_flag:
    CLR.W   20(A3)

.return:
    MOVE.L  A3,-(A7)
    JSR     PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData   (JumpStub_CLOCK_ConvertAmigaSecondsToClockData)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLOCK_ConvertAmigaSecondsToClockData
; DESC:
;   Jump stub to CLOCK_ConvertAmigaSecondsToClockData.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData:
    JMP     CLOCK_ConvertAmigaSecondsToClockData

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay   (JumpStub_ESQ_CalcDayOfYearFromMonthDay)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_CalcDayOfYearFromMonthDay
; DESC:
;   Jump stub to _ESQ_CalcDayOfYearFromMonthDay.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay:
    JMP     _ESQ_CalcDayOfYearFromMonthDay

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch   (JumpStub_CLOCK_CheckDateOrSecondsFromEpoch)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLOCK_CheckDateOrSecondsFromEpoch
; DESC:
;   Jump stub to CLOCK_CheckDateOrSecondsFromEpoch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch:
    JMP     CLOCK_CheckDateOrSecondsFromEpoch

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock   (JumpStub_BATTCLOCK_GetSecondsFromBatteryBackedClock)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BATTCLOCK_GetSecondsFromBatteryBackedClock
; DESC:
;   Jump stub to BATTCLOCK_GetSecondsFromBatteryBackedClock.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock:
    JMP     BATTCLOCK_GetSecondsFromBatteryBackedClock

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_DATETIME_IsLeapYear   (JumpStub_DATETIME_IsLeapYear)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_IsLeapYear
; DESC:
;   Jump stub to _DATETIME_IsLeapYear.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_DATETIME_IsLeapYear:
    JMP     _DATETIME_IsLeapYear

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock   (JumpStub_BATTCLOCK_WriteSecondsToBatteryBackedClock)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BATTCLOCK_WriteSecondsToBatteryBackedClock
; DESC:
;   Jump stub to BATTCLOCK_WriteSecondsToBatteryBackedClock.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock:
    JMP     BATTCLOCK_WriteSecondsToBatteryBackedClock

;------------------------------------------------------------------------------
; FUNC: PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch   (JumpStub_CLOCK_SecondsFromEpoch)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   CLOCK_SecondsFromEpoch
; DESC:
;   Jump stub to CLOCK_SecondsFromEpoch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch:
    JMP     CLOCK_SecondsFromEpoch

;!======

    ; Alignment
    MOVEQ   #97,D0
