    XDEF    ESQ_TickClockAndFlagEvents


;------------------------------------------------------------------------------
; FUNC: ESQ_TickClockAndFlagEvents   (Tick clock and emit boundary event code)
; ARGS:
;   stack +4: timePtr (struct with date/time fields)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D4
; CALLS:
;   _ESQ_UpdateMonthDayFromDayOfYear
; READS:
;   _CLOCK_MinuteTrigger30MinusBase, _CLOCK_MinuteTrigger60MinusBase, _CLOCK_MinuteTriggerBaseOffsetPlus30, _CLOCK_MinuteTriggerBaseOffset
; WRITES:
;   [timePtr] fields (0,2,4,6,8,10,12,16,18,20)
; DESC:
;   Advances the time structure by one second and returns a status/event code
;   for notable boundaries (minute/half-hour/hour/day changes).
; NOTES:
;   Field meanings are inferred; 18(A0) is treated as an AM/PM sign flag.
;------------------------------------------------------------------------------
ESQ_TickClockAndFlagEvents:
    MOVEA.L 4(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,D2
    MOVE.L  D0,D4
    MOVEQ   #1,D1
    MOVEQ   #60,D3
    MOVE.W  12(A0),D0
    CMP.W   D3,D0
    BLT.W   .return

    SUB.W   D3,12(A0)
    MOVEQ   #1,D4
    MOVE.W  10(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,10(A0)
    CMPI.W  #$1e,D0
    BNE.W   .check_minute_flags

    MOVEQ   #2,D4
    BRA.W   .return

.check_minute_flags:
    CMP.W   D3,D0
    BGE.W   .hour_rollover

    CMP.W   _CLOCK_MinuteTriggerBaseOffset,D0
    BEQ.W   .minute_trigger_5

    CMP.W   _CLOCK_MinuteTriggerBaseOffsetPlus30,D0
    BNE.W   .check_minute_20_or_50

.minute_trigger_5:
    MOVEQ   #5,D4
    BRA.W   .return

.check_minute_20_or_50:
    CMPI.W  #20,D0
    BEQ.W   .minute_trigger_4

    CMPI.W  #$32,D0
    BNE.W   .check_minute_special_3

.minute_trigger_4:
    MOVEQ   #4,D4
    BRA.W   .return

.check_minute_special_3:
    CMP.W   _CLOCK_MinuteTrigger30MinusBase,D0
    BEQ.W   .minute_trigger_3

    CMP.W   _CLOCK_MinuteTrigger60MinusBase,D0
    BNE.W   .return

.minute_trigger_3:
    MOVEQ   #3,D4
    BRA.W   .return

.hour_rollover:
    MOVE.W  D2,10(A0)
    MOVEQ   #2,D4
    MOVE.W  8(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,8(A0)
    MOVEQ   #12,D3
    CMP.W   D3,D0
    BLT.W   .return

    BEQ.S   .toggle_am_pm

    MOVE.W  D1,8(A0)
    BRA.W   .return

.toggle_am_pm:
    EORI.W   #$ffff,18(A0)
    BMI.W   .return

    MOVE.W  0(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,0(A0)
    MOVEQ   #7,D3
    CMP.W   D3,D0
    BNE.S   .wrap_weekday

    MOVE.W  D2,0(A0)

.wrap_weekday:
    MOVE.W  16(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,16(A0)
    MOVE.W  #$16e,D3
    TST.W   20(A0)
    BEQ.S   .day_of_year_check

    ADD.W   D1,D3

.day_of_year_check:
    CMP.W   D3,D0
    BLT.S   .update_month_day

    MOVE.W  6(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,6(A0)
    MOVE.W  D1,16(A0)
    MOVEQ   #0,D1
    ANDI.W  #3,D0
    BNE.S   .update_leap_flag

    MOVE.W  #(-1),D1

.update_leap_flag:
    MOVE.W  D1,20(A0)

.update_month_day:
    BSR.S   _ESQ_UpdateMonthDayFromDayOfYear

.return:
    MOVE.W  D4,D0
    MOVEM.L (A7)+,D2-D4
    RTS

;!======