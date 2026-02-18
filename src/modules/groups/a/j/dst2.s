    XDEF    DATETIME_AdjustMonthIndex
    XDEF    DATETIME_IsLeapYear
    XDEF    DATETIME_NormalizeMonthRange
    XDEF    DST_AddTimeOffset
    XDEF    DST_BuildBannerTimeEntry
    XDEF    DST_BuildBannerTimeWord
    XDEF    DST_CallJump_066F
    XDEF    DST_ComputeBannerIndex
    XDEF    DST_FormatBannerDateTime
    XDEF    DST_HandleBannerCommand32_33
    XDEF    DST_NormalizeDayOfYear
    XDEF    DST_RefreshBannerBuffer
    XDEF    DST_TickBannerCounters
    XDEF    DST_UpdateBannerQueue

;------------------------------------------------------------------------------
; FUNC: DST_HandleBannerCommand32_33   (Handle banner command $32/$33 and enqueue text)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +18: arg_3 (via 22(A5))
;   stack +40: arg_4 (via 44(A5))
;   stack +48: arg_5 (via 52(A5))
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   DATETIME_ParseString, DATETIME_CopyPairAndRecalc, DST_UpdateBannerQueue
; READS:
;   DST_BannerWindowSecondary, DST_BannerWindowPrimary
; WRITES:
;   (none observed)
; DESC:
;   Parses two string segments and enqueues them to the appropriate buffer.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_HandleBannerCommand32_33:
    LINK.W  A5,#-44
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$32,D0
    BEQ.S   .case_cmd_32

    SUBQ.W  #1,D0
    BEQ.S   .case_cmd_33

    BRA.S   .return

.case_cmd_32:
    ; Parse two string segments and enqueue into DST_BannerWindowSecondary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  DST_BannerWindowSecondary,-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7
    BRA.S   .return

.case_cmd_33:
    ; Parse two string segments and enqueue into DST_BannerWindowPrimary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  DST_BannerWindowPrimary,-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.return:
    PEA     DST_BannerWindowPrimary
    BSR.W   DST_UpdateBannerQueue

    MOVEM.L -52(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_CallJump_066F   (Jump stub to GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Small jump stub used by banner update paths.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_CallJump_066F:
    JSR     GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_UpdateBannerQueue   (Update the rotating banner queue)
; ARGS:
;   (none observed)
; RET:
;   D0: update flag (0/1?)
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   DATETIME_UpdateSelectionField, DST_AddTimeOffset, DST_AllocateBannerStruct, DST_RefreshBannerBuffer, DST_CallJump_066F
; READS:
;   DST_PrimaryCountdown, DST_SecondaryCountdown, DATA_ESQ_STR_N_1DD2
; WRITES:
;   DST_PrimaryCountdown, DST_SecondaryCountdown
; DESC:
;   Ticks the banner queue timers and refreshes buffers when entries change.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
; Update the rotating banner queue; free resources when entries expire.
DST_UpdateBannerQueue:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.W   .return

    ; Slot 0 update: tick timer and free if expired.
    TST.L   (A3)
    BEQ.S   .slot0_empty

    MOVEA.L (A3),A0
    MOVE.W  DST_PrimaryCountdown,16(A0)
    MOVE.L  (A3),-(A7)
    BSR.W   DATETIME_UpdateSelectionField

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .slot0_done

    MOVEA.L (A3),A0
    TST.W   16(A0)
    BEQ.S   .slot0_timer_zero

    MOVEQ   #1,D0
    BRA.S   .slot0_timer_ready

.slot0_timer_zero:
    MOVEQ   #-1,D0

.slot0_timer_ready:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    PEA     CLOCK_DaySlotIndex
    BSR.W   DST_AddTimeOffset

    MOVEA.L (A3),A0
    MOVE.W  16(A0),DST_PrimaryCountdown
    BSR.S   DST_CallJump_066F

    LEA     12(A7),A7
    MOVEQ   #1,D6
    BRA.S   .slot0_done

.slot0_empty:
    ; No active entry: count down DST_PrimaryCountdown and free when it hits 1.
    MOVE.W  DST_PrimaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .slot0_done

    CLR.L   -(A7)
    PEA     -1.W
    PEA     CLOCK_DaySlotIndex
    BSR.W   DST_AddTimeOffset

    LEA     12(A7),A7
    CLR.W   DST_PrimaryCountdown
    MOVEQ   #1,D6

.slot0_done:
    ; Slot 1 update depends on DATA_ESQ_STR_N_1DD2 mode.
    MOVE.B  DATA_ESQ_STR_N_1DD2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .slot1_mode_off

    TST.L   4(A3)
    BEQ.S   .slot1_empty

    MOVEA.L 4(A3),A0
    MOVE.W  DST_SecondaryCountdown,16(A0)
    MOVE.L  4(A3),-(A7)
    BSR.W   DATETIME_UpdateSelectionField

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .after_slot1

    MOVEA.L 4(A3),A0
    MOVE.W  16(A0),D0
    MOVE.W  D0,DST_SecondaryCountdown
    MOVEQ   #1,D6
    BRA.S   .after_slot1

.slot1_empty:
    MOVE.W  DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .after_slot1

    MOVEQ   #0,D0
    MOVE.W  D0,DST_SecondaryCountdown
    MOVEQ   #1,D6
    BRA.S   .after_slot1

.slot1_mode_off:
    ; Non-'Y' mode: only refresh slot 1 when timer hits 1.
    MOVE.W  DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .after_slot1

    MOVE.L  4(A3),-(A7)
    BSR.W   DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    CLR.W   DST_SecondaryCountdown
    MOVEQ   #1,D6

.after_slot1:
    TST.L   D6
    BEQ.S   .return

    ; At least one slot changed: rebuild the staging buffer.
    BSR.W   DST_RefreshBannerBuffer

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_NormalizeDayOfYear   (Normalize day-of-year across years.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   DATETIME_IsLeapYear
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Subtracts full years from D7 while adjusting year count in D6.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_NormalizeDayOfYear:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_IsLeapYear

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
    BSR.W   DATETIME_IsLeapYear

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

;------------------------------------------------------------------------------
; FUNC: DST_BuildBannerTimeEntry   (Build banner time entryuncertain)
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
;   DATETIME_IsLeapYear, DATETIME_BuildFromBaseDay, DATETIME_ClassifyValueInRange, DATETIME_SecondsToStruct, GROUP_AG_JMPTBL_MATH_Mulu32/1A07
; READS:
;   CLOCK_DaySlotIndex, WDISP_BannerSlotCursor, DATA_WDISP_BSS_WORD_223D, DATA_ESQ_STR_N_1DD2, DATA_ESQ_STR_6_1DD1, CLOCK_FormatVariantCode, DST_BannerWindowSecondary, DST_BannerWindowPrimary
; WRITES:
;   (A3), 14(A2)
; DESC:
;   Builds or updates banner-related time fields and writes them into outputs.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_BuildBannerTimeEntry:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    LEA     CLOCK_DaySlotIndex,A0
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
    MOVE.W  DATA_WDISP_BSS_WORD_223D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   DATETIME_IsLeapYear

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
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #30,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

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
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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
    BSR.W   DATETIME_BuildFromBaseDay

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVE.B  DATA_ESQ_STR_N_1DD2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .skip_alt_buffer

    ; If in 'Y' mode, write into DST_BannerWindowSecondary buffer first.
    MOVE.L  D5,-(A7)
    MOVE.L  DST_BannerWindowSecondary,-(A7)
    BSR.W   DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    EXT.L   D0
    BRA.S   .after_alt_buffer

.skip_alt_buffer:
    MOVEQ   #0,D0

.after_alt_buffer:
    MOVE.L  D5,-(A7)
    MOVE.L  DST_BannerWindowPrimary,-(A7)
    MOVE.W  D0,-32(A5)
    BSR.W   DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  DATA_ESQ_STR_6_1DD1,D1
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
    MOVE.B  CLOCK_FormatVariantCode,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,D5
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   DATETIME_SecondsToStruct

    ADDQ.W  #8,A7
    MOVE.W  -32(A5),14(A2)

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_BuildBannerTimeWord   (Wrapper: call DST_BuildBannerTimeEntry and return word.)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +11: arg_3 (via 15(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D6/D7
; CALLS:
;   DST_BuildBannerTimeEntry
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Calls DST_BuildBannerTimeEntry and returns the computed word from stack temp.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_BuildBannerTimeWord:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    CLR.L   -(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   DST_BuildBannerTimeEntry

    MOVE.W  -2(A5),D0
    MOVEM.L -12(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_ComputeBannerIndex   (Compute banner index from time structuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +15: arg_3 (via 19(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D6/D7
; CALLS:
;   DST_BuildBannerTimeEntry, GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   8(A3), 10(A3), 18(A3)
; WRITES:
;   (none observed)
; DESC:
;   Calls DST_BuildBannerTimeEntry and computes a derived index value.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_ComputeBannerIndex:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  A3,-(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   DST_BuildBannerTimeEntry

    LEA     16(A7),A7
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A3)
    BEQ.S   .month_offset_zero

    MOVEQ   #12,D0
    BRA.S   .month_offset_ready

.month_offset_zero:
    MOVEQ   #0,D0

.month_offset_ready:
    ADD.L   D0,D1
    ADD.L   D1,D1
    CMPI.W  #$1d,10(A3)
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    ADD.L   D0,D1
    BEQ.S   .set_nonzero_flag

    MOVEQ   #1,D0
    BRA.S   .nonzero_flag_ready

.set_nonzero_flag:
    MOVEQ   #0,D0

.nonzero_flag_ready:
    MOVE.L  D0,D7
    ADDI.W  #$26,D7
    MOVE.L  D7,D0
    EXT.L   D0
    DIVS    #$30,D0
    SWAP    D0
    MOVE.L  D0,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_TickBannerCounters   (Tick banner counters.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   (none)
; READS:
;   DATA_ESQ_STR_6_1DD1, DST_PrimaryCountdown, DST_SecondaryCountdown
; WRITES:
;   WDISP_BannerCharPhaseShift
; DESC:
;   Updates banner counters based on timers and flags.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_TickBannerCounters:
    MOVEQ   #0,D0
    MOVE.B  DATA_ESQ_STR_6_1DD1,D0
    SUBI.W  #$36,D0
    MOVE.W  D0,WDISP_BannerCharPhaseShift
    MOVE.W  DST_PrimaryCountdown,D1
    SUBQ.W  #1,D1
    BNE.S   .after_primary_tick

    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,WDISP_BannerCharPhaseShift

.after_primary_tick:
    MOVE.W  DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .return

    MOVE.W  WDISP_BannerCharPhaseShift,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,WDISP_BannerCharPhaseShift

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_AddTimeOffset   (Add time offset and store seconds.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   DATETIME_NormalizeStructToSeconds, DATETIME_SecondsToStruct
; READS:
;   e10
; WRITES:
;   (none observed)
; DESC:
;   Computes a seconds offset from hours/minutes and stores it via DATETIME_SecondsToStruct.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_AddTimeOffset:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVE.L  A3,-(A7)
    BSR.W   DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    MULS    #$e10,D0
    MOVE.L  D6,D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    ADD.L   D0,D5
    MOVE.L  A3,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   DATETIME_SecondsToStruct

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_FormatBannerDateTime   (Format banner date/time string.)
; ARGS:
;   stack +68: arg_1 (via 72(A5))
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D3/D4/D5/D6
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   Global_JMPTBL_SHORT_DAYS_OF_WEEK, Global_JMPTBL_SHORT_MONTHS, DATA_DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT__1D0C..DATA_DST_STR_NORM_YEAR_1D12
; WRITES:
;   (none observed)
; DESC:
;   Builds a formatted banner string using day/month tables and flags.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_FormatBannerDateTime:
    LINK.W  A5,#-40
    MOVEM.L D2-D6/A2-A3/A6,-(A7)
    MOVEA.L 80(A7),A3
    ; Build formatted banner string from date/time fields.

    ; 84(A7) is copied into (A2), which itself points to the day number.
    ; This is then copied into D0 and shifted by 2 to multiply by 4 becoming
    ; an index off of Global_JMPTBL_SHORT_DAYS_OF_WEEK and stored into A0.
    MOVEA.L 84(A7),A2
    MOVE.W  (A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0

    ; 2(A2) is copied into (D0), which itself points to the month number.
    ; This is then copied into D0 and again shifted by 2 to multiply by 4 becoming
    ; an index off of Global_JMPTBL_SHORT_MONTHS and stored into A1.
    MOVE.W  2(A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1

    ; Copy 4(A2) into D0 and sign extend
    MOVE.W  4(A2),D0
    EXT.L   D0

    ; Copy 6(A2) into D1 and sign extend
    MOVE.W  6(A2),D1
    EXT.L   D1

    ; Copy 16(A2) into D2 and sign extend
    MOVE.W  16(A2),D2
    EXT.L   D2

    ; Copy 8(A2) into D3 and sign extend
    MOVE.W  8(A2),D3
    EXT.L   D3

    ; Copy 10(A2) into D4 and sign extend
    MOVE.W  10(A2),D4
    EXT.L   D4

    ; Copy 12(A2) into D5 and sign extend
    MOVE.W  12(A2),D5
    EXT.L   D5

    ; Select format strings based on flags in A2.
    TST.W   18(A2)
    BEQ.S   .use_pm_string

    LEA     DATA_DST_TAG_PM_1D0D,A6
    BRA.S   .ampm_string_ready

.use_pm_string:
    LEA     DATA_DST_TAG_AM_1D0E,A6

.ampm_string_ready:
    ; Copy A6 into 64(A7), then 1 into D6. Compare 14(A2) to D6 and if it's not equal,
    ; branch to use_day_suffix_1 -- otherwise, load the address for DATA_DST_TAG_DST_1D0F
    ; ("DST") into A6 and branch to .day_suffix_ready
    MOVE.L  A6,64(A7)
    MOVEQ   #1,D6
    CMP.W   14(A2),D6
    BNE.S   .use_day_suffix_1

    ; A6 points to "DST"
    LEA     DATA_DST_TAG_DST_1D0F,A6
    BRA.S   .day_suffix_ready

.use_day_suffix_1:
    ; A6 points to "STD"
    LEA     DATA_DST_TAG_STD_1D10,A6

.day_suffix_ready:
    MOVE.L  A6,68(A7)
    TST.W   20(A2)
    BEQ.S   .use_dst_on_string

    ; A6 points to "Leap year"
    LEA     DATA_DST_STR_LEAP_YEAR_1D11,A6
    BRA.S   .dst_string_ready

.use_dst_on_string:
    ; A6 points to "Norm year"
    LEA     DATA_DST_STR_NORM_YEAR_1D12,A6

.dst_string_ready:
    ; Setup the stack and call a printf function with the string
    ; "%s:  %s%s%02d, '%d (%03d) %2d:%02d:%02d %s %s %s"
    MOVE.L  A6,-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    PEA     DATA_DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT__1D0C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEM.L -72(A5),D2-D6/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_RefreshBannerBuffer   (Copy the next banner entry into the staging buffer.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   DST_TickBannerCounters, DST_AddTimeOffset
; READS:
;   CLOCK_DaySlotIndex, DST_SecondaryCountdown, WDISP_BannerCharPhaseShift, CLOCK_FormatVariantCode
; WRITES:
;   CLOCK_CurrentDayOfWeekIndex, DST_SecondaryCountdown
; DESC:
;   Updates counters, copies the queue state into staging, and writes timestamps.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
; Copy the next banner entry into the staging buffer and trigger drawing.
DST_RefreshBannerBuffer:
    MOVE.L  D7,-(A7)
    BSR.W   DST_TickBannerCounters

    MOVE.W  DST_SecondaryCountdown,D7
    LEA     CLOCK_DaySlotIndex,A0
    LEA     CLOCK_CurrentDayOfWeekIndex,A1
    MOVEQ   #4,D0

    ; Copy current queue state into staging buffer.
.copy_queue_state:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_queue_state
    MOVE.W  (A0),(A1)
    MOVE.W  D7,DST_SecondaryCountdown
    MOVE.W  WDISP_BannerCharPhaseShift,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  CLOCK_FormatVariantCode,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     CLOCK_CurrentDayOfWeekIndex
    BSR.W   DST_AddTimeOffset

    LEA     12(A7),A7
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DATETIME_IsLeapYear   (Leap year test.)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if leap year, 0 otherwise
; CLOBBERS:
;   A7/D0/D1/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Tests year divisibility by 4/100/400.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DATETIME_IsLeapYear:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    ; Normalize and test for leap year.
    CMPI.L  #$76c,D7
    BGE.S   .normalize_year_base

    ADDI.L  #$76c,D7

.normalize_year_base:
    MOVE.L  D7,D0
    MOVEQ   #4,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .check_century

    MOVE.L  D7,D0
    MOVEQ   #100,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .set_leap_result

.check_century:
    MOVE.L  D7,D0
    MOVE.L  #400,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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

;------------------------------------------------------------------------------
; FUNC: DATETIME_AdjustMonthIndex   (Adjust month index with optional +12 offset.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   8(A3), 18(A3)
; WRITES:
;   8(A3)
; DESC:
;   Adds 12 months when a flag is set and writes back the result.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DATETIME_AdjustMonthIndex:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Adjust month index with optional +12 offset flag.
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A3)
    BEQ.S   .month_offset_zero

    MOVEQ   #12,D0
    BRA.S   .month_offset_ready

.month_offset_zero:
    MOVEQ   #0,D0

.month_offset_ready:
    ADD.L   D0,D1
    MOVE.W  D1,8(A3)
    MOVE.L  D1,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DATETIME_NormalizeMonthRange   (Normalize month range and set overflow flag.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   (none)
; READS:
;   8(A3)
; WRITES:
;   8(A3), 18(A3)
; DESC:
;   Sets an overflow flag and wraps month index into 1..12 range.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DATETIME_NormalizeMonthRange:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Normalize month range and set overflow flag.
    MOVE.W  8(A3),D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BLE.S   .month_overflow

    MOVEQ   #-1,D1
    BRA.S   .month_overflow_ready

.month_overflow:
    MOVEQ   #0,D1

.month_overflow_ready:
    MOVE.W  D1,18(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    TST.W   D0
    BNE.S   .return

    MOVE.W  D1,8(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
