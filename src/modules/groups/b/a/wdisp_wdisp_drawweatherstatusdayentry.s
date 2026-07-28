    XDEF    _WDISP_DrawWeatherStatusDayEntry


;------------------------------------------------------------------------------
; FUNC: _WDISP_DrawWeatherStatusDayEntry   (DrawWeatherStatusDayEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +42: arg_6 (via 46(A5))
;   stack +46: arg_7 (via 50(A5))
;   stack +50: arg_8 (via 54(A5))
;   stack +54: arg_9 (via 58(A5))
;   stack +55: arg_10 (via 59(A5))
;   stack +60: arg_11 (via 64(A5))
;   stack +64: arg_12 (via 68(A5))
;   stack +68: arg_13 (via 72(A5))
;   stack +72: arg_14 (via 76(A5))
;   stack +76: arg_15 (via 80(A5))
;   stack +80: arg_16 (via 84(A5))
;   stack +84: arg_17 (via 88(A5))
;   stack +88: arg_18 (via 92(A5))
;   stack +92: arg_19 (via 96(A5))
;   stack +96: arg_20 (via 100(A5))
;   stack +100: arg_21 (via 104(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _MATH_DivS32, _MATH_Mulu32, _STRING_AppendAtNull, _WDISP_JMPTBL_BRUSH_FindBrushByPredicate, _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex, _WDISP_JMPTBL_BRUSH_SelectBrushSlot, _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples, _WDISP_JMPTBL_NEWGRID_DrawWrappedText, _WDISP_SPrintf, _LVOCopyMem, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOText, _LVOTextLength
; READS:
;   AbsExecBase, _Global_HANDLE_PREVUEC_FONT, _Global_JMPTBL_DAYS_OF_WEEK, Global_REF_GRAPHICS_LIBRARY, _Global_STR_PERCENT_D, _Global_STR_PERCENT_D_SLASH, _ESQFUNC_PwBrushListHead, _ESQFUNC_STR_I5, _P_TYPE_WeatherForecastMsgPtr, _WDISP_StatusDayEntry0, _WDISP_STR_UNKNOWN_NUM_WITH_SLASH, _WDISP_STR_UNKNOWN_NUM, _WDISP_CharClassTable, _CLOCK_CurrentDayOfWeekIndex, _WDISP_PaletteTriplesRBase, _WDISP_AccumulatorRowTable
; WRITES:
;   _WDISP_AccumulatorCaptureActive, _WDISP_AccumulatorFlushPending
; DESC:
;   Renders one day-entry panel for the weather status display.
; NOTES:
;   Accepts day-slot index D7 in range 0..3; out-of-range returns immediately.
;------------------------------------------------------------------------------
_WDISP_DrawWeatherStatusDayEntry:
    LINK.W  A5,#-116
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5

    MOVEQ   #0,D0
    MOVEQ   #1,D1
    CLR.L   -104(A5)
    MOVE.L  D0,-68(A5)
    MOVE.L  D0,-64(A5)
    MOVE.L  D1,-100(A5)
    TST.L   D7
    BMI.W   .return

    MOVEQ   #4,D2
    CMP.L   D2,D7
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #3,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D7,D1
    MOVE.L  D0,-4(A5)
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D0,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  4(A1),D1
    ADDA.L  D0,A0
    MOVEM.L D1,-88(A5)
    MOVEQ   #1,D0
    CMP.L   16(A0),D0
    BEQ.S   .dayentry_normalize_brush_index

    MOVEQ   #2,D0
    CMP.L   D0,D1
    BLT.S   .dayentry_normalize_brush_index

    MOVEQ   #6,D3
    CMP.L   D3,D1
    BLE.S   .dayentry_lookup_brush

.dayentry_normalize_brush_index:
    MOVEQ   #2,D0
    CLR.L   -100(A5)
    MOVE.L  D0,-88(A5)

.dayentry_lookup_brush:
    MOVE.L  -88(A5),D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor (_ESQFUNC_STR_I5 -> ptr table).
    LEA     _ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     _WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-104(A5)
    TST.L   D0
    BEQ.S   .dayentry_use_default_brush_size

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D2
    MOVE.W  176(A0),D2
    MOVE.L  D1,-12(A5)
    MOVE.L  D2,-16(A5)
    BRA.S   .dayentry_branch_by_status_mode

.dayentry_use_default_brush_size:
    MOVEQ   #90,D1
    MOVE.L  D1,-12(A5)
    MOVEQ   #0,D1
    MOVE.L  D1,-100(A5)
    MOVE.L  D1,-16(A5)

.dayentry_branch_by_status_mode:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    TST.L   16(A0)
    BNE.W   .dayentry_draw_multiline_forecast

    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    CLR.W   _WDISP_AccumulatorFlushPending
    TST.L   -100(A5)
    BEQ.W   .dayentry_restore_base_palette

    PEA     5.W
    JSR     _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -104(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-76(A5)
    JSR     _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -84(A5)
    MOVE.L  D1,-80(A5)

.dayentry_copy_palette_from_brush_loop:
    MOVE.L  -84(A5),D0
    CMP.L   -80(A5),D0
    BGE.S   .dayentry_after_palette_copy

    CMP.L   -76(A5),D0
    BGE.S   .dayentry_after_palette_copy

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVEA.L -104(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-84(A5)
    BRA.S   .dayentry_copy_palette_from_brush_loop

.dayentry_after_palette_copy:
    CLR.L   -84(A5)

.dayentry_copy_accumulator_rows_loop:
    MOVE.L  -84(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .dayentry_after_accumulator_copy

    ASL.L   #3,D0
    MOVEA.L -104(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     _WDISP_AccumulatorRowTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,40(A7)
    MOVEA.L A1,A0
    MOVEA.L 40(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-84(A5)
    BRA.S   .dayentry_copy_accumulator_rows_loop

.dayentry_after_accumulator_copy:
    CLR.W   _WDISP_AccumulatorCaptureActive
    MOVE.W  #1,_WDISP_AccumulatorFlushPending
    MOVE.L  -16(A5),D0
    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .dayentry_center_brush_x

    ADDQ.L  #1,D1

.dayentry_center_brush_x:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D2
    ADD.L   D1,D2
    MOVE.L  D5,D1
    MOVE.L  -12(A5),D3
    SUB.L   D3,D1
    MOVEQ   #0,D4
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D4
    SUB.L   D4,D1
    SUBQ.L  #5,D1
    ADD.L   D2,D0
    ADD.L   D1,D3
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -104(A5),-(A7)
    MOVE.L  D1,-96(A5)
    MOVE.L  D2,-92(A5)
    JSR     _WDISP_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    BRA.S   .dayentry_build_temperature_strings

.dayentry_restore_base_palette:
    JSR     _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

.dayentry_build_temperature_strings:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,8(A0)
    BNE.S   .dayentry_format_high_temp_numeric

    LEA     _WDISP_STR_UNKNOWN_NUM_WITH_SLASH,A0
    LEA     -46(A5),A1
    MOVE.L  (A0)+,(A1)+
    CLR.B   (A1)
    BRA.S   .dayentry_format_low_temp_string

.dayentry_format_high_temp_numeric:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    MOVE.L  8(A0),-(A7)
    PEA     _Global_STR_PERCENT_D_SLASH
    PEA     -46(A5)
    JSR     _WDISP_SPrintf(PC)

    LEA     12(A7),A7

.dayentry_format_low_temp_string:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,12(A0)   ; -999
    BNE.S   .dayentry_format_low_temp_numeric

    LEA     _WDISP_STR_UNKNOWN_NUM,A0
    LEA     -26(A5),A1
    MOVE.L  (A0)+,(A1)+
    BRA.S   .dayentry_draw_temperature_line

.dayentry_format_low_temp_numeric:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    MOVE.L  12(A0),-(A7)
    PEA     _Global_STR_PERCENT_D
    PEA     -26(A5)
    JSR     _WDISP_SPrintf(PC)

    LEA     12(A7),A7

.dayentry_draw_temperature_line:
    PEA     -26(A5)
    PEA     -46(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.dayentry_scan_temp_line_len_loop:
    TST.B   (A1)+
    BNE.S   .dayentry_scan_temp_line_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .dayentry_center_temp_line_x

    ADDQ.L  #1,D1

.dayentry_center_temp_line_x:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

    BRA.W   .dayentry_draw_weekday_label

.dayentry_draw_multiline_forecast:
    MOVE.L  _P_TYPE_WeatherForecastMsgPtr,-54(A5)
    MOVEQ   #20,D0
    SUB.L   D0,-4(A5)
    CLR.L   -68(A5)
    MOVE.L  #$8c,-64(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.dayentry_multiline_loop:
    TST.L   -54(A5)
    BEQ.W   .dayentry_restore_panel_width

    CMPI.L  #$4,-68(A5)
    BGE.W   .dayentry_restore_panel_width

.dayentry_skip_class3_chars_loop:
    MOVEA.L -54(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .dayentry_draw_wrapped_line

    ADDQ.L  #1,-54(A5)
    BRA.S   .dayentry_skip_class3_chars_loop

.dayentry_draw_wrapped_line:
    CLR.L   -(A7)
    MOVE.L  -54(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-58(A5)
    TST.L   D0
    BEQ.W   .dayentry_draw_plain_line

    MOVEA.L D0,A0
    MOVE.B  (A0),-59(A5)
    CLR.B   (A0)
    MOVEA.L -54(A5),A0

.dayentry_find_wrapped_line_end_loop:
    TST.B   (A0)+
    BNE.S   .dayentry_find_wrapped_line_end_loop

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L D0,A1
    MOVE.B  -59(A5),(A1)
    MOVE.L  A0,-72(A5)
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .dayentry_center_wrapped_line_x

    ADDQ.L  #1,D2

.dayentry_center_wrapped_line_x:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     _WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D1
    ADDQ.L  #4,D1
    ADD.L   D1,-64(A5)
    ADDQ.L  #1,-68(A5)
    MOVE.L  D0,-54(A5)
    BRA.W   .dayentry_multiline_loop

.dayentry_draw_plain_line:
    MOVEA.L -54(A5),A0

.dayentry_find_plain_line_end_loop:
    TST.B   (A0)+
    BNE.S   .dayentry_find_plain_line_end_loop

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .dayentry_center_plain_line_x

    ADDQ.L  #1,D2

.dayentry_center_plain_line_x:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     _WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-54(A5)
    BRA.W   .dayentry_multiline_loop

.dayentry_restore_panel_width:
    MOVEQ   #20,D0
    ADD.L   D0,-4(A5)

.dayentry_draw_weekday_label:
    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ADD.L   D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #7,D1
    JSR     _MATH_DivS32(PC)

    ASL.L   #2,D1
    LEA     _Global_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    LEA     -46(A5),A2

.dayentry_copy_weekday_text_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .dayentry_copy_weekday_text_loop

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.dayentry_scan_weekday_len_loop:
    TST.B   (A1)+
    BNE.S   .dayentry_scan_weekday_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .dayentry_center_weekday_x

    ADDQ.L  #1,D1

.dayentry_center_weekday_x:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVEQ   #0,D2
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  -92(A5),D0
    MOVE.L  -96(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======