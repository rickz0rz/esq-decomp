    XDEF    DATETIME_CopyPairAndRecalc
    XDEF    DATETIME_ParseString


;------------------------------------------------------------------------------
; FUNC: DATETIME_CopyPairAndRecalc   (Copy two date structs and recalc)
; ARGS:
;   stack +8: A3 = dest struct
;   stack +12: A2 = src1 pointer
;   stack +16: A0 = src2 pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0
; CALLS:
;   _DATETIME_NormalizeStructToSeconds
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
    BSR.W   _DATETIME_NormalizeStructToSeconds

    MOVE.L  D0,8(A3)
    MOVE.L  16(A5),(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,12(A3)

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DATETIME_ParseString   (Parse date/time from stringuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +15: arg_3 (via 19(A5))
; RET:
;   D0: boolean success
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   _GROUP_AI_JMPTBL_STR_FindCharPtr, GROUP_AG_JMPTBL_STRING_CopyPadNul, _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _GROUP_AG_JMPTBL_MATH_DivS32, _DATETIME_IsLeapYear, _DATETIME_NormalizeMonthRange, _DATETIME_NormalizeStructToSeconds, _DATETIME_SecondsToStruct
; READS:
;   CLOCK_CacheYear
; WRITES:
;   A3 fields
; DESC:
;   Parses a date/time string into a struct and validates ranges.
; NOTES:
;   Uses 0x12/0x0B offsets in the parsed buffer.
;------------------------------------------------------------------------------
DATETIME_ParseString:
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
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

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
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -1(A5)
    PEA     -8(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,6(A3)
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheYear,D2
    EXT.L   D2
    SUB.L   D2,D0
    BGE.S   .year_offset_nonnegative

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheYear,D2
    EXT.L   D2
    SUB.L   D2,D0
    NEG.L   D0
    BRA.S   .year_offset_abs

.year_offset_nonnegative:
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheYear,D2
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
    BSR.W   _DATETIME_IsLeapYear

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
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    BSR.W   _DATETIME_NormalizeMonthRange

    MOVE.L  A3,(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    MOVE.L  A3,(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_SecondsToStruct

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