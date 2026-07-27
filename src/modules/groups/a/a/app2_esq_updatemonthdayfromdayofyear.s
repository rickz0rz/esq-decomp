    XDEF    _ESQ_UpdateMonthDayFromDayOfYear


; Unreachable Code?
    MOVEA.L 4(A7),A0

;------------------------------------------------------------------------------
; FUNC: _ESQ_UpdateMonthDayFromDayOfYear   (UpdateMonthDayFromDayOfYearuncertain)
; ARGS:
;   stack +4: timePtr (struct with day-of-year fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   _CLOCK_MonthLengths
; WRITES:
;   2(A0), 4(A0)
; DESC:
;   Converts day-of-year to month index and day-of-month fields.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
_ESQ_UpdateMonthDayFromDayOfYear:
    MOVE.L  D2,-(A7)
    MOVE.W  16(A0),D0
    MOVEQ   #0,D2
    LEA     _CLOCK_MonthLengths,A1
    TST.W   20(A0)
    BEQ.S   .scan_months

    ADDA.L  #$18,A1

.scan_months:
    MOVE.W  (A1)+,D1
    CMP.W   D1,D0
    BLE.S   .return

    SUB.W   D1,D0
    ADDQ.W  #1,D2
    BRA.S   .scan_months

.return:
    MOVE.W  D2,2(A0)
    MOVE.W  D0,4(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======