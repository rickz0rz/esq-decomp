    XDEF    _DATETIME_IsLeapYear


;------------------------------------------------------------------------------
; FUNC: _DATETIME_IsLeapYear   (Leap year test.)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if leap year, 0 otherwise
; CLOBBERS:
;   A7/D0/D1/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Tests year divisibility by 4/100/400.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DATETIME_IsLeapYear:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    ; Normalize and test for leap year.
    CMPI.L  #$76c,D7
    BGE.S   .normalize_year_base

    ADDI.L  #$76c,D7

.normalize_year_base:
    MOVE.L  D7,D0
    MOVEQ   #4,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .check_century

    MOVE.L  D7,D0
    MOVEQ   #100,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .set_leap_result

.check_century:
    MOVE.L  D7,D0
    MOVE.L  #400,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .set_leap_result

    MOVEQ   #0,D0
    BRA.S   .return

.set_leap_result:
    MOVEQ   #1,D0

.return:
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======