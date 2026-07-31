    XDEF    _ESQIFF_DrawWeatherStatusOverlayIntoBrush


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_DrawWeatherStatusOverlayIntoBrush   (Draw split weather-status text into selected brush)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +20: arg_2 (via 24(A5))
;   stack +24: arg_3 (via 28(A5))
;   stack +28: arg_4 (via 32(A5))
;   stack +32: arg_5 (via 36(A5))
;   stack +36: arg_6 (via 40(A5))
;   stack +40: arg_7 (via 44(A5))
;   stack +44: arg_8 (via 48(A5))
;   stack +48: arg_9 (via 52(A5))
;   stack +52: arg_10 (via 56(A5))
;   stack +56: arg_11 (via 60(A5))
;   stack +60: arg_12 (via 64(A5))
;   stack +61: arg_13 (via 65(A5))
;   stack +62: arg_14 (via 66(A5))
;   stack +84: arg_15 (via 88(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, _ESQIFF_JMPTBL_MATH_DivS32, _ESQIFF_JMPTBL_MATH_Mulu32, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQFUNC_TrimTextToPixelWidthWordBoundary, _ESQPARS_ReplaceOwnedString, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, _Global_STR_ESQIFF_C_1, _WDISP_WeatherStatusOverlayTextPtr, _ESQFUNC_PwBrushListHead, _ESQFUNC_STR_I5, _WDISP_WeatherStatusBrushIndex
; WRITES:
;   weather-overlay working copy buffer, selected brush flags (+356/+360) ??
; DESC:
;   Duplicates current weather overlay text, splits delimiter byte `$18` into NUL
;   separators, and draws up to 10 segments into brush raster text columns.
; NOTES:
;   Uses caller brush/rastport at A3 and restores original APen/DrMd on exit.
;   Segment width is trimmed via _ESQFUNC_TrimTextToPixelWidthWordBoundary.
;------------------------------------------------------------------------------
_ESQIFF_DrawWeatherStatusOverlayIntoBrush:
    LINK.W  A5,#-68
    MOVEM.L D2/D5-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D7
    MOVEQ   #30,D6
    MOVEQ   #0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor: this string label sits immediately before
    ; an indexed pointer table used by weather-status brush lookup.
    LEA     _ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  -4(A5),(A7)
    MOVE.L  _WDISP_WeatherStatusOverlayTextPtr,-(A7)
    MOVE.L  D0,-52(A5)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVE.L  D0,-4(A5)
    MOVE.L  D1,-28(A5)

.replace_delimiter_with_nul_loop:
    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .prepare_first_segment_ptr

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .advance_scan_ptr

    CLR.B   (A0)
    ADDQ.L  #1,D5

.advance_scan_ptr:
    ADDQ.L  #1,-8(A5)
    BRA.S   .replace_delimiter_with_nul_loop

.prepare_first_segment_ptr:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    TST.B   (A0)
    BNE.S   .clamp_segment_count

    ADDQ.L  #1,-8(A5)
    SUBQ.L  #1,D5

.clamp_segment_count:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   .setup_rastport_state

    MOVE.L  D0,D5

.setup_rastport_state:
    MOVE.B  64(A3),-65(A5)
    MOVE.B  61(A3),-66(A5)
    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetRast(A6)

    MOVEQ   #1,D0
    MOVEA.L -52(A5),A0
    MOVE.L  D0,356(A0)
    MOVE.L  D0,360(A0)
    MOVEQ   #0,D0
    MOVE.W  176(A3),D0
    MOVEQ   #0,D1
    MOVE.W  178(A3),D1
    LEA     36(A3),A1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D5,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .half_line_count_ready

    ADDQ.L  #1,D1

.half_line_count_ready:
    ASR.L   #1,D1
    MOVE.L  D0,-48(A5)
    MOVE.L  D1,-32(A5)
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #80,D1
    ADD.L   D1,D1
    SUB.L   D0,D1
    MOVE.L  -32(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-36(A5)
    MOVE.L  D1,D0
    MOVE.L  D1,-40(A5)
    MOVE.L  -36(A5),D1
    JSR     _ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #0,D1
    MOVE.W  176(A3),D1
    MOVEQ   #0,D2
    MOVEA.L -52(A5),A0
    MOVE.W  176(A0),D2
    SUB.L   D2,D1
    TST.L   D1
    BPL.S   .half_brush_width_delta_ready

    ADDQ.L  #1,D1

.half_brush_width_delta_ready:
    ASR.L   #1,D1
    MOVE.L  D0,-44(A5)
    MOVE.L  D1,-56(A5)

.render_segment_loop:
    MOVE.L  -24(A5),D0
    CMP.L   D5,D0
    BGE.W   .restore_rastport_and_free_text

    TST.L   D0
    BPL.S   .half_segment_index_ready

    ADDQ.L  #1,D0

.half_segment_index_ready:
    ASR.L   #1,D0
    MOVE.L  -44(A5),D1
    MOVE.L  -48(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   -44(A5),D0
    MOVEQ   #0,D1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    ADD.L   D0,D2
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    SUB.L   D0,D2
    MOVEQ   #80,D0
    ADD.L   D0,D0
    CMP.L   D0,D2
    BGE.W   .restore_rastport_and_free_text

    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQFUNC_TrimTextToPixelWidthWordBoundary

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .center_left_segment_x_offset_ready

    ADDQ.L  #1,D1

.center_left_segment_x_offset_ready:
    ASR.L   #1,D1
    MOVE.L  D1,D7
    LEA     36(A3),A0
    MOVE.L  D0,-64(A5)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVE.L  -60(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-24(A5)
    MOVE.L  -24(A5),D0
    CMP.L   D5,D0
    BGE.W   .advance_to_next_segment

    MOVEA.L -8(A5),A0

.scan_segment_end_left:
    TST.B   (A0)+
    BNE.S   .scan_segment_end_left

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)
    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQFUNC_TrimTextToPixelWidthWordBoundary

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .center_right_segment_x_offset_ready

    ADDQ.L  #1,D1

.center_right_segment_x_offset_ready:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  176(A3),D2
    SUB.L   D1,D2
    MOVE.L  D2,D7
    SUBQ.L  #1,D7
    LEA     36(A3),A0
    MOVE.L  D0,-64(A5)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVE.L  -60(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-24(A5)

.advance_to_next_segment:
    MOVEA.L -8(A5),A0

.scan_segment_end_generic:
    TST.B   (A0)+
    BNE.S   .scan_segment_end_generic

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)

    BRA.W   .render_segment_loop

.restore_rastport_and_free_text:
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     672.W
    PEA     _Global_STR_ESQIFF_C_1
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     36(A3),A0
    MOVE.B  -65(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    LEA     36(A3),A0
    MOVE.B  -66(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    JSR     _LVOSetAPen(A6)

    MOVEM.L -88(A5),D2/D5-D7/A3
    UNLK    A5
    RTS

;!======