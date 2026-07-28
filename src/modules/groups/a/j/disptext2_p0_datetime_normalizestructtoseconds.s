    XDEF    _DATETIME_NormalizeStructToSeconds


;------------------------------------------------------------------------------
; FUNC: _DATETIME_NormalizeStructToSeconds   (Normalize time struct to secondsuncertain)
; ARGS:
;   stack +8: A3 = time struct
; RET:
;   D0: seconds or -1 on invalid
; CLOBBERS:
;   A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _DATETIME_AdjustMonthIndex, _DATETIME_IsLeapYear, _GROUP_AG_JMPTBL_MATH_Mulu32, _DATETIME_NormalizeMonthRange
; READS:
;   A3+2/4/6/8/10/12/16
; WRITES:
;   A3+2/4/6/8/10/12/16/20
; DESC:
;   Normalizes fields in the time struct and computes total seconds.
; NOTES:
;   Uses DIVS #10 and SWAP idioms for decimal extraction.
;------------------------------------------------------------------------------
_DATETIME_NormalizeStructToSeconds:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  6(A3),D0
    CMPI.W  #$76c,D0
    BGE.S   .year_check_high

    ADDI.W  #$76c,6(A3)

.year_check_high:
    MOVE.W  6(A3),D0
    CMPI.W  #$7b2,D0
    BLT.S   .invalid_year

    CMPI.W  #$7f6,D0
    BLE.S   .normalize_fields

.invalid_year:
    MOVEQ   #-1,D0
    BRA.W   .return

.normalize_fields:
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_AdjustMonthIndex

    ADDQ.W  #4,A7
    MOVE.W  12(A3),D0
    EXT.L   D0
    MOVEQ   #60,D1
    DIVS    D1,D0
    ADD.W   D0,10(A3)
    MOVE.W  12(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,12(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,8(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,10(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #24,D1
    DIVS    D1,D0
    ADD.W   D0,4(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,16(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .non_leap_days_in_year

    MOVE.L  #366,D0
    BRA.S   .set_days_in_year

.non_leap_days_in_year:
    MOVE.L  #$16d,D0

.set_days_in_year:
    MOVE.L  D0,D6

.normalize_day_of_year:
    MOVE.W  16(A3),D0
    EXT.L   D0
    CMP.L   D6,D0
    BLE.S   .compute_leap_correction

    MOVE.W  16(A3),D0
    EXT.L   D0
    SUB.L   D6,D0
    MOVE.W  D0,16(A3)
    ADDQ.W  #1,6(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .leap_days_in_year

    MOVE.L  #366,D0
    BRA.S   .days_in_year_ready

.leap_days_in_year:
    MOVE.L  #$16d,D0

.days_in_year_ready:
    MOVE.L  D0,D6
    BRA.S   .normalize_day_of_year

.compute_leap_correction:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b0,D0
    TST.L   D0
    BPL.S   .adjust_leap_correction

    ADDQ.L  #3,D0

.adjust_leap_correction:
    ASR.L   #2,D0
    MOVE.L  D0,D7
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .compute_total_days

    SUBQ.L  #1,D7

.compute_total_days:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b2,D0
    MOVE.L  #$16d,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    SUBQ.L  #1,D5
    MOVE.L  D5,D0
    MOVE.L  #$15180,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.W  8(A3),D1
    MULS    #$e10,D1
    ADD.L   D1,D0
    MOVE.W  10(A3),D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    MOVE.W  12(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeMonthRange

    ADDQ.W  #4,A7
    TST.L   D4
    BLE.S   .invalid_result

    MOVE.L  D4,D0
    BRA.S   .return

.invalid_result:
    MOVEQ   #-1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======