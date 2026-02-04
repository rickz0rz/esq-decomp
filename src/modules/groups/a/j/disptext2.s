
;------------------------------------------------------------------------------
; FUNC: DATETIME_SecondsToStruct   (Convert seconds to time struct??)
; ARGS:
;   stack +8: D7 = seconds??
;   stack +12: A3 = output struct
; RET:
;   D0: A3
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AJ_JMPTBL_MATH_Mulu32, DATETIME_IsLeapYear, DST_JMPTBL_DivMod7, DATETIME_NormalizeMonthRange
; READS:
;   LAB_1CF5
; WRITES:
;   A3+0/2/4/6/8/10/12/16/20
; DESC:
;   Converts a seconds value into fields stored in the output struct.
; NOTES:
;   Uses repeated division/modulo with 60/24 and year/day tables.
;------------------------------------------------------------------------------
DATETIME_SecondsToStruct:
LAB_05C7:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    TST.L   D7
    BPL.S   .seconds_ok

    MOVEQ   #0,D7

.seconds_ok:
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,12(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,10(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,D7

.year_hours_loop:
    MOVE.L  #$2238,D6
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_IsLeapYear

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
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    ADD.L   D0,D4
    ADDQ.W  #1,6(A3)
    SUB.L   D6,D7
    BRA.S   .year_hours_loop

.convert_day_hours:
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,8(A3)
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    ADD.L   D0,D4
    MOVE.L  D4,D0
    MOVEQ   #7,D1
    JSR     DST_JMPTBL_DivMod7(PC)

    MOVE.W  D1,(A3)
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVE.W  D0,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_IsLeapYear

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
    BSR.W   DATETIME_NormalizeMonthRange

    ADDQ.W  #4,A7
    MOVE.L  A3,D0
    BRA.S   .return

.month_loop_start:
    CLR.W   2(A3)

.month_loop:
    LEA     LAB_1CF5,A0
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
    BSR.W   DATETIME_NormalizeMonthRange

    ADDQ.W  #4,A7
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_NormalizeStructToSeconds   (Normalize time struct to seconds??)
; ARGS:
;   stack +8: A3 = time struct
; RET:
;   D0: seconds or -1 on invalid
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   DATETIME_AdjustMonthIndex, DATETIME_IsLeapYear, GROUP_AG_JMPTBL_MATH_Mulu32, DATETIME_NormalizeMonthRange
; READS:
;   A3+2/4/6/8/10/12/16
; WRITES:
;   A3+2/4/6/8/10/12/16/20
; DESC:
;   Normalizes fields in the time struct and computes total seconds.
; NOTES:
;   Uses DIVS #10 and SWAP idioms for decimal extraction.
;------------------------------------------------------------------------------
DATETIME_NormalizeStructToSeconds:
LAB_05D3:
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
    BSR.W   DATETIME_AdjustMonthIndex

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
    BSR.W   DATETIME_IsLeapYear

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
    BSR.W   DATETIME_IsLeapYear

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
    BSR.W   DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .compute_total_days

    SUBQ.L  #1,D7

.compute_total_days:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b2,D0
    MOVE.L  #$16d,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    SUBQ.L  #1,D5
    MOVE.L  D5,D0
    MOVE.L  #$15180,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

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
    BSR.W   DATETIME_NormalizeMonthRange

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
; FUNC: DATETIME_BuildFromBaseDay   (Build time struct from date/time??)
; ARGS:
;   stack +8: A3 = time struct
;   stack +12: A2 = output struct
;   stack +18: D7 = ?? (base day)
;   stack +22: D6 = ?? (flag)
; RET:
;   D0: seconds?
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   DATETIME_NormalizeStructToSeconds, GROUP_AG_JMPTBL_MATH_Mulu32, DATETIME_SecondsToStruct
; READS:
;   A2
; WRITES:
;   A2 fields, A2+14 cleared
; DESC:
;   Computes a derived time value and fills output fields.
; NOTES:
;   Uses offset of 0x36 and 0x0E10 scaling.
;------------------------------------------------------------------------------
DATETIME_BuildFromBaseDay:
LAB_05E1:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.L  A3,-(A7)
    BSR.W   DATETIME_NormalizeStructToSeconds

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
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D5,D4
    ADD.L   D0,D4
    MOVE.L  A2,-(A7)
    MOVE.L  D4,-(A7)
    BSR.W   DATETIME_SecondsToStruct

    CLR.W   14(A2)
    MOVE.L  D4,D0
    MOVEM.L -36(A5),D4-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_BuildFromGlobals   (Populate time struct from LAB_2241)
; ARGS:
;   stack +8: A3 = output struct
; RET:
;   D0: seconds?
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   DATETIME_BuildFromBaseDay
; READS:
;   LAB_2241, LAB_223A
; WRITES:
;   output struct
; DESC:
;   Wrapper that builds a time struct using global base data.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DATETIME_BuildFromGlobals:
LAB_05E4:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    MOVE.L  A3,-(A7)
    PEA     LAB_223A
    BSR.W   DATETIME_BuildFromBaseDay

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_ClassifyValueInRange   (Compare value against struct bounds)
; ARGS:
;   stack +8: A3 = struct pointer
;   stack +12: D7 = value
; RET:
;   D0: 0/1 ??
; CLOBBERS:
;   D0-D7/A3 ??
; CALLS:
;   none
; READS:
;   A3+8/12/16
; WRITES:
;   -11(A5) (flags)
; DESC:
;   Compares value against two bounds and returns a derived selector.
; NOTES:
;   Switch-like sequence on flags in -11(A5).
;------------------------------------------------------------------------------
DATETIME_ClassifyValueInRange:
LAB_05E5:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D0,-11(A5)
    MOVE.L  A3,D1
    BNE.S   .bounds_ready

    MOVEQ   #0,D0
    BRA.W   .return

.bounds_ready:
    MOVE.L  12(A3),D0
    MOVE.L  8(A3),D1
    CMP.L   D0,D1
    BGE.S   .bounds_high_gt_low

    MOVE.B  -11(A5),D2
    MOVE.L  D1,D5
    MOVE.L  D0,D4
    MOVE.B  D2,-11(A5)
    BRA.S   .check_value

.bounds_high_gt_low:
    CMP.L   D0,D1
    BLE.S   .bounds_equal

    BSET    #4,-11(A5)
    MOVE.L  D0,D5
    MOVE.L  D1,D4
    BRA.S   .check_value

.bounds_equal:
    MOVEQ   #0,D0
    BRA.S   .return

.check_value:
    CMP.L   D5,D7
    BGE.S   .value_below_low

    MOVE.B  -11(A5),D0
    MOVE.B  D0,-11(A5)
    BRA.S   .select_case

.value_below_low:
    CMP.L   D4,D7
    BGE.S   .value_above_high

    BSET    #0,-11(A5)
    BRA.S   .select_case

.value_above_high:
    BSET    #1,-11(A5)

.select_case:
    MOVEQ   #0,D0
    MOVE.B  -11(A5),D0
    TST.W   D0
    BEQ.S   .case_flag_0

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_1

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_2

    SUBI.W  #14,D0
    BEQ.S   .case_flag_14

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_15

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_16

    BRA.S   .case_default

.case_flag_0:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_1:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_flag_2:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_14:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_flag_15:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_16:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_default:
    MOVEQ   #0,D6

.store_result:
    MOVE.L  D6,D0

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_UpdateSelectionField   (Update A3 based on time comparison??)
; ARGS:
;   stack +8: A3 = struct pointer
; RET:
;   D0: boolean changed
; CLOBBERS:
;   D0-D7/A3 ??
; CALLS:
;   DATETIME_BuildFromGlobals, DATETIME_ClassifyValueInRange
; READS:
;   A3+16
; WRITES:
;   A3+16
; DESC:
;   Recomputes a selection value and stores it if changed.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DATETIME_UpdateSelectionField:
LAB_05F6:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   .return

    PEA     -26(A5)
    BSR.W   DATETIME_BuildFromGlobals

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    MOVE.W  16(A3),D0
    CMP.W   D5,D0
    BEQ.S   .return

    MOVE.W  D5,16(A3)
    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_CopyPairAndRecalc   (Copy two date structs and recalc)
; ARGS:
;   stack +8: A3 = dest struct
;   stack +12: A2 = src1 pointer
;   stack +16: A0 = src2 pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0-A3 ??
; CALLS:
;   DATETIME_NormalizeStructToSeconds
; READS:
;   A2, A0
; WRITES:
;   A3+0/4/8/12
; DESC:
;   Copies two 22-byte blocks into A3 and recalculates time values.
; NOTES:
;   DBF loops run (Dn+1) iterations (22 bytes).
;------------------------------------------------------------------------------
DATETIME_CopyPairAndRecalc:
LAB_05F8:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   (A3)
    BEQ.S   .return

    TST.L   4(A3)
    BEQ.S   .return

    MOVEQ   #21,D0
    MOVEA.L A2,A0
    MOVEA.L (A3),A1

.copy_first_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_first_loop
    MOVEQ   #21,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 4(A3),A1

.copy_second_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_second_loop
    MOVE.L  A2,-(A7)
    BSR.W   DATETIME_NormalizeStructToSeconds

    MOVE.L  D0,8(A3)
    MOVE.L  16(A5),(A7)
    BSR.W   DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,12(A3)

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_ParseString   (Parse date/time from string??)
; ARGS:
;   stack +8: A3 = output struct
;   stack +12: A2 = input string
;   stack +19: D7 = ?? (flags)
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_05C1, LAB_0470, LAB_0468, GROUP_AG_JMPTBL_MATH_DivS32, DATETIME_IsLeapYear, DATETIME_NormalizeMonthRange, DATETIME_NormalizeStructToSeconds, DATETIME_SecondsToStruct
; READS:
;   LAB_223D
; WRITES:
;   A3 fields
; DESC:
;   Parses a date/time string into a struct and validates ranges.
; NOTES:
;   Uses 0x12/0x0B offsets in the parsed buffer.
;------------------------------------------------------------------------------
DATETIME_ParseString:
LAB_05FC:
    LINK.W  A5,#-20
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  19(A5),D7
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.W   .parse_fail

    MOVE.L  A3,D0
    BEQ.W   .parse_fail

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

.clear_struct_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_struct_loop
    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    PEA     7.W
    MOVE.L  A0,-(A7)
    PEA     -8(A5)
    JSR     LAB_0470(PC)

    CLR.B   -1(A5)
    PEA     -8(A5)
    JSR     LAB_0468(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,6(A3)
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    BGE.S   .year_offset_nonnegative

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    NEG.L   D0
    BRA.S   .year_offset_abs

.year_offset_nonnegative:
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0

.year_offset_abs:
    MOVEQ   #1,D2
    CMP.L   D2,D0
    BGT.W   .parse_fail

    MOVEQ   #1,D0
    CMP.W   D0,D1
    BLE.W   .parse_fail

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .not_leap_year

    MOVEQ   #1,D0
    BRA.S   .leap_adjust_done

.not_leap_year:
    MOVEQ   #0,D0

.leap_adjust_done:
    ADDI.L  #366,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .parse_fail

    MOVEA.L -12(A5),A0
    ADDQ.L  #8,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,8(A3)
    TST.W   D0
    BMI.S   .parse_fail

    MOVEQ   #24,D1
    CMP.W   D1,D0
    BGE.S   .parse_fail

    MOVEA.L -12(A5),A0
    ADDA.W  #11,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,10(A3)
    TST.W   D0
    BMI.S   .parse_fail

    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   .parse_fail

    MOVEQ   #0,D0
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVE.L  A3,-(A7)
    BSR.W   DATETIME_NormalizeMonthRange

    MOVE.L  A3,(A7)
    BSR.W   DATETIME_NormalizeStructToSeconds

    MOVE.L  A3,(A7)
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_SecondsToStruct

    ADDQ.W  #8,A7
    MOVEQ   #1,D5

.parse_fail:
    TST.W   D5
    BNE.S   .return

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

.clear_on_fail_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_on_fail_loop

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_FormatPairToStream   (Dump time structs to stream??)
; ARGS:
;   stack +8: D7 = stream/handle
;   stack +12: A3 = struct pair
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AI_JMPTBL_STRING_AppendAtNull, GROUP_AG_JMPTBL_MATH_DivS32, LAB_03A0
; READS:
;   LAB_1CF8..LAB_1D00
; WRITES:
;   local buffer -87(A5)
; DESC:
;   Formats two optional time structs into text and writes to the stream.
; NOTES:
;   Uses local buffer with append helper.
;------------------------------------------------------------------------------
DATETIME_FormatPairToStream:
LAB_0605:
    LINK.W  A5,#-140
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    CLR.B   -87(A5)
    MOVE.L  A3,D0
    BEQ.W   .structs_missing

    MOVEA.L (A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   .first_missing

    PEA     4.W
    PEA     LAB_1CF8
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CF9
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A0)
    BEQ.S   .no_am_pm_adjust

    MOVEQ   #12,D0
    BRA.S   .ampm_adjust_ready

.no_am_pm_adjust:
    MOVEQ   #0,D0

.ampm_adjust_ready:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFA
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     24(A7),A7
    BRA.S   .after_first

.first_missing:
    PEA     LAB_1CFB
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_first:
    MOVEA.L 4(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   .second_missing

    PEA     19.W
    PEA     LAB_1CFC
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFD
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A0)
    BEQ.S   .no_am_pm_adjust_2

    MOVEQ   #12,D0
    BRA.S   .ampm_adjust_ready_2

.no_am_pm_adjust_2:
    MOVEQ   #0,D0

.ampm_adjust_ready_2:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFE
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     24(A7),A7
    BRA.S   .emit_buffer

.second_missing:
    PEA     LAB_1CFF
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .emit_buffer

.structs_missing:
    PEA     LAB_1D00
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.emit_buffer:
    LEA     -87(A5),A0
    MOVEA.L A0,A1

.count_buffer_len:
    TST.B   (A1)+
    BNE.S   .count_buffer_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVEM.L -152(A5),D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_SavePairToFile   (Save time structs to file)
; ARGS:
;   stack +8: A3 = struct pair
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, DATETIME_FormatPairToStream, LAB_039A
; READS:
;   LAB_1CF7, LAB_1D01, LAB_1D02
; WRITES:
;   file
; DESC:
;   Writes formatted struct data to a file using a buffered handle.
; NOTES:
;   Requires both struct pointers to be non-null.
;------------------------------------------------------------------------------
DATETIME_SavePairToFile:
LAB_0610:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return_false

    TST.L   (A3)
    BEQ.S   .return_false

    TST.L   4(A3)
    BEQ.S   .return_false

    PEA     MODE_NEWFILE.W
    MOVE.L  LAB_1CF7,-(A7)
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return_false

    PEA     4.W
    PEA     LAB_1D01
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  4(A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   DATETIME_FormatPairToStream

    PEA     4.W
    PEA     LAB_1D02
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  (A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   DATETIME_FormatPairToStream

    MOVE.L  D7,(A7)
    JSR     LAB_039A(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    BRA.S   .return

.return_false:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS
