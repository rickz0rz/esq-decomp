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
;   _DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES
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
    LEA     _DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES,A0
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