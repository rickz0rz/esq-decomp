    XDEF    _ESQ_CalcDayOfYearFromMonthDay


;------------------------------------------------------------------------------
; FUNC: _ESQ_CalcDayOfYearFromMonthDay   (CalcDayOfYearFromMonthDayuncertain)
; ARGS:
;   stack +4: timePtr (struct with month/day fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   _CLOCK_MonthLengths
; WRITES:
;   16(A0)
; DESC:
;   Converts month index and day-of-month into day-of-year.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
_ESQ_CalcDayOfYearFromMonthDay:
    MOVEA.L 4(A7),A0
    MOVE.W  2(A0),D1
    MOVEQ   #0,D0
    LEA     _CLOCK_MonthLengths,A1
    DBF     D1,.month_loop

    BRA.S   .return

.month_loop:
    TST.W   20(A0)
    BEQ.S   .select_table

    ADDA.L  #$18,A1

.select_table:
    ADD.W   (A1)+,D0
    DBF     D1,.select_table

.return:
    ADD.W   4(A0),D0
    MOVE.W  D0,16(A0)
    RTS

;!======