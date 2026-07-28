    XDEF    _WDISP_DrawWeatherStatusOverlay


; =============
; WDISP.S
; =============
; Subroutines for displaying weather information

; weather status rendering/control
;------------------------------------------------------------------------------
; FUNC: _WDISP_DrawWeatherStatusOverlay   (DrawWeatherStatusOverlay)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +136: arg_4 (via 140(A5))
;   stack +144: arg_5 (via 148(A5))
;   stack +148: arg_6 (via 152(A5))
;   stack +152: arg_7 (via 156(A5))
;   stack +156: arg_8 (via 160(A5))
;   stack +160: arg_9 (via 164(A5))
;   stack +164: arg_10 (via 168(A5))
;   stack +168: arg_11 (via 172(A5))
;   stack +172: arg_12 (via 176(A5))
;   stack +176: arg_13 (via 180(A5))
;   stack +180: arg_14 (via 184(A5))
;   stack +184: arg_15 (via 188(A5))
;   stack +188: arg_16 (via 192(A5))
;   stack +192: arg_17 (via 196(A5))
;   stack +196: arg_18 (via 200(A5))
;   stack +200: arg_19 (via 204(A5))
;   stack +204: arg_20 (via 208(A5))
;   stack +208: arg_21 (via 212(A5))
;   stack +212: arg_22 (via 216(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _MATH_DivS32, _MATH_Mulu32, _MEMORY_DeallocateMemory, _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString, _WDISP_JMPTBL_BRUSH_FindBrushByPredicate, _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex, _WDISP_JMPTBL_BRUSH_SelectBrushSlot, _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary, _LVOCopyMem, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   AbsExecBase, _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, _Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE, _Global_STR_WDISP_C, _WDISP_WeatherStatusTextPtr, _WDISP_WeatherStatusOverlayTextPtr, _ESQFUNC_PwBrushListHead, _ESQFUNC_STR_I5, _ESQFUNC_WeatherBrushPredicateNames, _P_TYPE_WeatherCurrentMsgPtr, _WDISP_WeatherStatusCountdown, _WDISP_PaletteTriplesRBase, _WDISP_WeatherStatusBrushIndex, _WDISP_WeatherStatusDigitChar, _WDISP_AccumulatorRowTable
; WRITES:
;   _WDISP_AccumulatorCaptureActive, _WDISP_AccumulatorFlushPending
; DESC:
;   Draws the weather-status overlay text/brush composition into the target
;   RastPort, including centered fallback text when no status brush is active.
; NOTES:
;   Uses delimiter 24 to split overlay text into up to two centered lines.
;------------------------------------------------------------------------------
_WDISP_DrawWeatherStatusOverlay:
    LINK.W  A5,#-228
    MOVEM.L D2-D3/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    CLR.L   -8(A5)
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusCountdown,D1
    MOVE.L  D0,-156(A5)
    MOVE.L  D0,-152(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BLS.W   .overlay_draw_fallback_text

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .overlay_draw_fallback_text

    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    SUBQ.B  #1,D0
    BNE.S   .overlay_lookup_brush_by_index

    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  _ESQFUNC_WeatherBrushPredicateNames,-(A7)
    JSR     _WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BRA.S   .overlay_after_brush_lookup

.overlay_lookup_brush_by_index:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor (_ESQFUNC_STR_I5 -> ptr table).
    LEA     _ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     _WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.overlay_after_brush_lookup:
    TST.L   D0
    BEQ.S   .overlay_use_default_brush_size

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,-216(A5)
    MOVE.L  D1,-212(A5)
    BRA.S   .overlay_dup_and_scan_text

.overlay_use_default_brush_size:
    MOVEQ   #90,D0
    MOVE.L  D0,-212(A5)
    MOVE.L  #$aa,-216(A5)

.overlay_dup_and_scan_text:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  _WDISP_WeatherStatusOverlayTextPtr,-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0

.overlay_scan_overlay_text_len_loop:
    TST.B   (A0)+
    BNE.S   .overlay_scan_overlay_text_len_loop

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  D1,-160(A5)

.overlay_split_on_delimiter_loop:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .overlay_after_split

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .overlay_split_next_char

    CLR.B   (A0)
    ADDQ.L  #1,-152(A5)

.overlay_split_next_char:
    ADDQ.L  #1,-12(A5)
    BRA.S   .overlay_split_on_delimiter_loop

.overlay_after_split:
    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)
    TST.B   (A0)
    BNE.S   .overlay_skip_leading_empty_line

    ADDQ.L  #1,-12(A5)
    SUBQ.L  #1,-152(A5)

.overlay_skip_leading_empty_line:
    CMPI.L  #$a,-152(A5)
    BLE.S   .overlay_clamp_line_count

    MOVEQ   #10,D0
    MOVE.L  D0,-152(A5)

.overlay_clamp_line_count:
    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    MOVE.L  D1,-196(A5)
    SUBQ.B  #1,D0
    BEQ.W   .overlay_prepare_status_text

    TST.L   -4(A5)
    BEQ.W   .overlay_prepare_status_text

    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    MOVE.L  D0,356(A0)
    MOVE.L  D0,360(A0)
    PEA     5.W
    JSR     _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-184(A5)
    JSR     _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -192(A5)
    MOVE.L  D1,-188(A5)

.overlay_copy_palette_from_brush_loop:
    MOVE.L  -192(A5),D0
    CMP.L   -188(A5),D0
    BGE.S   .overlay_after_palette_copy

    CMP.L   -184(A5),D0
    BGE.S   .overlay_after_palette_copy

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-192(A5)
    BRA.S   .overlay_copy_palette_from_brush_loop

.overlay_after_palette_copy:
    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    CLR.W   _WDISP_AccumulatorFlushPending
    CLR.L   -192(A5)

.overlay_copy_accumulator_rows_loop:
    MOVE.L  -192(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .overlay_after_accumulator_copy

    ASL.L   #3,D0
    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     _WDISP_AccumulatorRowTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,32(A7)
    MOVEA.L A1,A0
    MOVEA.L 32(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-192(A5)
    BRA.S   .overlay_copy_accumulator_rows_loop

.overlay_after_accumulator_copy:
    CLR.W   _WDISP_AccumulatorCaptureActive
    MOVE.W  #1,_WDISP_AccumulatorFlushPending
    MOVE.L  -196(A5),D0
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-148(A5)
    JSR     _WDISP_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7

.overlay_prepare_status_text:
    TST.L   _WDISP_WeatherStatusTextPtr
    BEQ.S   .overlay_clear_status_text

    MOVEA.L _WDISP_WeatherStatusTextPtr,A0
    TST.B   (A0)
    BEQ.S   .overlay_clear_status_text

    LEA     -140(A5),A1

.overlay_copy_status_text_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .overlay_copy_status_text_loop

    BRA.S   .overlay_measure_status_text

.overlay_clear_status_text:
    CLR.B   -140(A5)

.overlay_measure_status_text:
    LEA     -140(A5),A0
    MOVEA.L A0,A1

.overlay_scan_status_text_len_loop:
    TST.B   (A1)+
    BNE.S   .overlay_scan_status_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-204(A5)
    BLE.S   .overlay_prepare_multiline_metrics

    MOVEA.L A3,A1
    MOVE.L  -204(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .overlay_center_status_text_x

    ADDQ.L  #1,D1

.overlay_center_status_text_x:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.L  D1,-148(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -140(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.overlay_prepare_multiline_metrics:
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  -152(A5),D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .overlay_divide_line_count

    ADDQ.L  #1,D1

.overlay_divide_line_count:
    ASR.L   #1,D1
    MOVE.L  D1,D2
    ADDQ.L  #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    ADD.L   -212(A5),D3
    MOVE.L  D0,-180(A5)
    MOVE.L  D1,-164(A5)
    JSR     _MATH_Mulu32(PC)

    SUB.L   D0,D3
    ADDQ.L  #5,D3
    MOVE.L  D3,D0
    MOVE.L  D2,D1
    MOVE.L  D0,-172(A5)
    MOVE.L  D1,-168(A5)
    JSR     _MATH_DivS32(PC)

    MOVE.L  D7,D1
    SUB.L   -216(A5),D1
    TST.L   D1
    BPL.S   .overlay_center_line_width

    ADDQ.L  #1,D1

.overlay_center_line_width:
    ASR.L   #1,D1
    MOVE.L  D0,-176(A5)
    MOVE.L  D1,-200(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.overlay_draw_lines_loop:
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.W   .overlay_cleanup_text_copy

    TST.L   D0
    BPL.S   .overlay_half_line_index

    ADDQ.L  #1,D0

.overlay_half_line_index:
    ASR.L   #1,D0
    MOVE.L  -176(A5),D1
    MOVE.L  -180(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     _MATH_Mulu32(PC)

    MOVE.L  -196(A5),D1
    ADD.L   D0,D1
    ADD.L   -176(A5),D1
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #0,D2
    MOVE.W  20(A0),D2
    MOVE.L  D1,-148(A5)
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    SUB.L   D2,D1
    CMP.L   D6,D1
    BGE.W   .overlay_cleanup_text_copy

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .overlay_center_first_line

    ADDQ.L  #1,D1

.overlay_center_first_line:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.S   .overlay_after_optional_second_line

    MOVEA.L -12(A5),A0

.overlay_find_next_line_start_loop:
    TST.B   (A0)+
    BNE.S   .overlay_find_next_line_start_loop

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .overlay_center_next_line

    ADDQ.L  #1,D1

.overlay_center_next_line:
    ASR.L   #1,D1
    MOVE.L  D7,D2
    SUB.L   D1,D2
    MOVE.L  D2,D5
    SUBQ.L  #1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)

.overlay_after_optional_second_line:
    MOVEA.L -12(A5),A0

.overlay_skip_current_line_loop:
    TST.B   (A0)+
    BNE.S   .overlay_skip_current_line_loop

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    BRA.W   .overlay_draw_lines_loop

.overlay_cleanup_text_copy:
    MOVE.L  -160(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     301.W
    PEA     _Global_STR_WDISP_C
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .return

.overlay_draw_fallback_text:
    TST.L   _P_TYPE_WeatherCurrentMsgPtr
    BEQ.S   .overlay_use_no_data_string

    MOVE.L  _P_TYPE_WeatherCurrentMsgPtr,-12(A5)
    BRA.S   .overlay_measure_fallback_text

.overlay_use_no_data_string:
    MOVEA.L _Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,A0
    MOVE.L  A0,-12(A5)

.overlay_measure_fallback_text:
    MOVEA.L -12(A5),A0

.overlay_scan_fallback_len_loop:
    TST.B   (A0)+
    BNE.S   .overlay_scan_fallback_len_loop

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,-204(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .overlay_center_fallback_x

    ADDQ.L  #1,D1

.overlay_center_fallback_x:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .overlay_center_fallback_y

    ADDQ.L  #1,D2

.overlay_center_fallback_y:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    UNLK    A5
    RTS

;!======