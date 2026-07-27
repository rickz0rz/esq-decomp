    XDEF    _DATETIME_BuildFromBaseDay
    XDEF    _DATETIME_NormalizeStructToSeconds
    XDEF    _DATETIME_SecondsToStruct



;------------------------------------------------------------------------------
; FUNC: _DATETIME_SecondsToStruct   (Convert seconds to time structuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: A3
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AJ_JMPTBL_MATH_Mulu32, _DATETIME_IsLeapYear, GROUP_AJ_JMPTBL_MATH_DivU32, _DATETIME_NormalizeMonthRange
; READS:
;   DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES
; WRITES:
;   A3+0/2/4/6/8/10/12/16/20
; DESC:
;   Converts a seconds value into fields stored in the output struct.
; NOTES:
;   Uses repeated division/modulo with 60/24 and year/day tables.
;------------------------------------------------------------------------------
_DATETIME_SecondsToStruct:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    TST.L   D7
    BPL.S   .seconds_ok

    MOVEQ   #0,D7

.seconds_ok:
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,12(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,10(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D5
    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.W  D0,6(A3)
    ADDI.W  #$7b2,6(A3)
    MOVE.L  D5,D0
    MOVE.L  #$5b5,D1
    JSR     GROUP_AJ_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,D7

.year_hours_loop:
    MOVE.L  #$2238,D6
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .check_year_hours

    MOVEQ   #24,D0
    ADD.L   D0,D6

.check_year_hours:
    CMP.L   D6,D7
    BLT.S   .convert_day_hours

    MOVE.L  D6,D0
    MOVEQ   #24,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    ADD.L   D0,D4
    ADDQ.W  #1,6(A3)
    SUB.L   D6,D7
    BRA.S   .year_hours_loop

.convert_day_hours:
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,8(A3)
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    ADD.L   D0,D4
    MOVE.L  D4,D0
    MOVEQ   #7,D1
    JSR     GROUP_AJ_JMPTBL_MATH_DivU32(PC)

    MOVE.W  D1,(A3)
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVE.W  D0,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .set_is_leap_false

    MOVEQ   #-1,D0
    BRA.S   .set_is_leap_flag

.set_is_leap_false:
    MOVEQ   #0,D0

.set_is_leap_flag:
    MOVE.W  D0,20(A3)
    ADDQ.W  #1,D0
    BNE.S   .month_loop_start

    MOVEQ   #60,D0
    CMP.L   D0,D7
    BLE.S   .handle_feb29

    SUBQ.L  #1,D7
    BRA.S   .month_loop_start

.handle_feb29:
    CMP.L   D0,D7
    BNE.S   .month_loop_start

    MOVE.W  #1,2(A3)
    MOVE.W  #$1d,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeMonthRange

    ADDQ.W  #4,A7
    MOVE.L  A3,D0
    BRA.S   .return

.month_loop_start:
    CLR.W   2(A3)

.month_loop:
    LEA     DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES,A0
    MOVE.W  2(A3),D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVE.B  (A1),D1
    EXT.W   D1
    EXT.L   D1
    CMP.L   D7,D1
    BGE.S   .month_done

    ADDA.W  D0,A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    SUB.L   D0,D7
    ADDQ.W  #1,2(A3)
    BRA.S   .month_loop

.month_done:
    MOVE.L  D7,D0
    MOVE.W  D0,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeMonthRange

    ADDQ.W  #4,A7
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======
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

;!======
;------------------------------------------------------------------------------
; FUNC: _DATETIME_BuildFromBaseDay   (Build time struct from date/timeuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +14: arg_4 (via 18(A5))
;   stack +18: arg_5 (via 22(A5))
;   stack +32: arg_6 (via 36(A5))
; RET:
;   D0: seconds?
; CLOBBERS:
;   A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _DATETIME_NormalizeStructToSeconds, _GROUP_AG_JMPTBL_MATH_Mulu32, _DATETIME_SecondsToStruct
; READS:
;   A2
; WRITES:
;   A2 fields, A2+14 cleared
; DESC:
;   Computes a derived time value and fills output fields.
; NOTES:
;   Uses offset of 0x36 and 0x0E10 scaling.
;------------------------------------------------------------------------------
_DATETIME_BuildFromBaseDay:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    SUBI.W  #$36,D0
    MOVEM.W D0,-10(A5)
    MOVEQ   #1,D1
    CMP.W   D1,D6
    BNE.S   .flag_zero

    MOVEQ   #1,D1
    BRA.S   .flag_ready

.flag_zero:
    MOVEQ   #0,D1

.flag_ready:
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.L  #$e10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D5,D4
    ADD.L   D0,D4
    MOVE.L  A2,-(A7)
    MOVE.L  D4,-(A7)
    BSR.W   _DATETIME_SecondsToStruct

    CLR.W   14(A2)
    MOVE.L  D4,D0
    MOVEM.L -36(A5),D4-D7/A2-A3
    UNLK    A5
    RTS

;!======