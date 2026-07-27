    XDEF    _DST_NormalizeDayOfYear


;------------------------------------------------------------------------------
; FUNC: _DST_NormalizeDayOfYear   (Normalize day-of-year across years.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   _DATETIME_IsLeapYear
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Subtracts full years from D7 while adjusting year count in D6.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_NormalizeDayOfYear:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    ; Determine days in year for the starting year.
    TST.W   D0
    BEQ.S   .leap_year

    MOVE.L  #366,D0
    BRA.S   .set_year_days

.leap_year:
    MOVE.L  #$16d,D0

.set_year_days:
    MOVE.L  D0,D5

.year_subtract_loop:
    ; Normalize D7 by subtracting whole years while it exceeds days/year.
    CMP.W   D5,D7
    BLE.S   .return

    SUB.W   D5,D7
    ADDQ.W  #1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .leap_year_next

    MOVE.L  #366,D0
    BRA.S   .set_year_days_next

.leap_year_next:
    MOVE.L  #$16d,D0

.set_year_days_next:
    MOVE.L  D0,D5
    BRA.S   .year_subtract_loop

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======