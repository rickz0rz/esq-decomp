    XDEF    _DST_BuildBannerTimeEntry



;------------------------------------------------------------------------------
; FUNC: _DST_BuildBannerTimeEntry   (Build banner time entryuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +11: arg_5 (via 15(A5))
;   stack +12: arg_6 (via 16(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +24: arg_9 (via 28(A5))
;   stack +26: arg_10 (via 30(A5))
;   stack +28: arg_11 (via 32(A5))
;   stack +30: arg_12 (via 34(A5))
;   stack +32: arg_13 (via 36(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _DATETIME_IsLeapYear, _DATETIME_BuildFromBaseDay, _DATETIME_ClassifyValueInRange, _DATETIME_SecondsToStruct, _GROUP_AG_JMPTBL_MATH_Mulu32/1A07
; READS:
;   _CLOCK_DaySlotIndex, WDISP_BannerSlotCursor, _CLOCK_CacheYear, _ESQ_SecondarySlotModeFlagChar, _ESQ_STR_6, _CLOCK_FormatVariantCode, _DST_BannerWindowSecondary, _DST_BannerWindowPrimary
; WRITES:
;   (A3), 14(A2)
; DESC:
;   Builds or updates banner-related time fields and writes them into outputs.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_BuildBannerTimeEntry:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    LEA     _CLOCK_DaySlotIndex,A0
    LEA     -22(A5),A1
    MOVEQ   #4,D0

    ; Copy queue template into scratch buffer.
.copy_queue_state:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_queue_state
    MOVE.W  (A0),(A1)
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.W  WDISP_BannerSlotCursor,D1
    MOVE.W  D0,-30(A5)
    CMPI.W  #$ff,D1
    BLT.S   .after_wrap_flag

    CMP.W   D0,D1
    BEQ.S   .after_wrap_flag

    MOVE.L  D1,D2
    ANDI.W  #$ff,D2
    CMP.W   D0,D2
    BEQ.S   .set_wrap_flag

    EXT.L   D1
    ADDQ.L  #1,D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    EXT.L   D0
    CMP.L   D1,D0
    BNE.S   .after_wrap_flag

.set_wrap_flag:
    BSET    #0,-30(A5)

.after_wrap_flag:
    MOVE.W  -30(A5),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   .maybe_increment_year

    MOVE.W  WDISP_BannerSlotCursor,D2
    SUBQ.W  #1,D2
    BEQ.S   .maybe_increment_year

    MOVE.W  -16(A5),D2
    ADDQ.W  #1,D2
    MOVE.W  D2,-16(A5)

.maybe_increment_year:
    MOVEQ   #39,D2
    CMP.W   D2,D7
    BLT.S   .adjust_for_threshold

    ADDQ.W  #1,-30(A5)

.adjust_for_threshold:
    MOVE.W  _CLOCK_CacheYear,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _DATETIME_IsLeapYear

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .leap_year

    MOVE.L  #366,D0
    BRA.S   .set_year_days

.leap_year:
    MOVE.L  #$16d,D0

.set_year_days:
    MOVE.W  D0,-36(A5)
    MOVE.W  -30(A5),D1
    CMP.W   D0,D1
    BLE.S   .normalize_day_of_year

    ; Day-of-year overflow: carry into the year counter.
    SUB.W   D0,-30(A5)
    MOVE.W  -16(A5),D0
    ADDQ.W  #1,D0
    MOVE.W  D0,-16(A5)

.normalize_day_of_year:
    MOVE.W  -30(A5),-6(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,-10(A5)
    MOVE.L  D7,D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #30,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.W  D0,-12(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    TST.L   D0
    BPL.S   .adjust_dividend

    ADDQ.L  #1,D0

.adjust_dividend:
    ASR.L   #1,D0
    ADDQ.L  #5,D0
    MOVEQ   #12,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,-14(A5)
    BNE.S   .ensure_nonzero_divisor

    MOVE.W  #12,-14(A5)

.ensure_nonzero_divisor:
    MOVE.L  D7,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    TST.L   D0
    BPL.S   .adjust_dividend_2

    ADDQ.L  #1,D0

.adjust_dividend_2:
    ASR.L   #1,D0
    ADDQ.L  #5,D0
    MOVEQ   #24,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #11,D0
    CMP.L   D0,D1
    BLE.S   .set_overflow_flag

    MOVEQ   #-1,D0
    BRA.S   .overflow_flag_ready

.set_overflow_flag:
    MOVEQ   #0,D0

.overflow_flag_ready:
    MOVE.W  D0,-4(A5)
    MOVE.W  -8(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    LEA     -22(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _DATETIME_BuildFromBaseDay

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVE.B  _ESQ_SecondarySlotModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .skip_alt_buffer

    ; If in 'Y' mode, write into _DST_BannerWindowSecondary buffer first.
    MOVE.L  D5,-(A7)
    MOVE.L  _DST_BannerWindowSecondary,-(A7)
    BSR.W   _DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    EXT.L   D0
    BRA.S   .after_alt_buffer

.skip_alt_buffer:
    MOVEQ   #0,D0

.after_alt_buffer:
    MOVE.L  D5,-(A7)
    MOVE.L  _DST_BannerWindowPrimary,-(A7)
    MOVE.W  D0,-32(A5)
    BSR.W   _DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  _ESQ_STR_6,D1
    MOVEQ   #54,D2
    SUB.L   D2,D1
    MOVE.W  D0,-34(A5)
    MOVEM.W D1,-28(A5)
    MOVEQ   #1,D2
    CMP.W   D2,D0
    BNE.S   .adjust_row_for_flag

    SUBQ.W  #1,-28(A5)

.adjust_row_for_flag:
    CMP.W   -32(A5),D2
    BNE.S   .adjust_row_for_alt

    ADDQ.W  #1,-28(A5)

.adjust_row_for_alt:
    MOVE.W  -28(A5),D1
    MOVE.W  D1,(A3)
    MOVE.L  A2,D3
    BEQ.S   .return

    SUBQ.W  #1,D0
    BNE.S   .set_plus_one

    MOVEQ   #1,D0
    BRA.S   .set_plus_one_ready

.set_plus_one:
    MOVEQ   #0,D0

.set_plus_one_ready:
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,-28(A5)
    MULS    #$e10,D1
    ADD.L   D1,D5
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,D5
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   _DATETIME_SecondsToStruct

    ADDQ.W  #8,A7
    MOVE.W  -32(A5),14(A2)

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======