    XDEF    ESQIFF_DrawWeatherStatusOverlayIntoBrush
    XDEF    ESQIFF_QueueIffBrushLoad
    XDEF    ESQIFF_RenderWeatherStatusBrushSlice
    XDEF    ESQIFF_RenderWeatherStatusBrushSlice_Return



;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_DrawWeatherStatusOverlayIntoBrush   (Draw split weather-status text into selected brush)
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
;   _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_MATH_Mulu32, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQFUNC_TrimTextToPixelWidthWordBoundary, _ESQPARS_ReplaceOwnedString, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, Global_STR_ESQIFF_C_1, _WDISP_WeatherStatusOverlayTextPtr, _ESQFUNC_PwBrushListHead, _ESQFUNC_STR_I5, _WDISP_WeatherStatusBrushIndex
; WRITES:
;   weather-overlay working copy buffer, selected brush flags (+356/+360) ??
; DESC:
;   Duplicates current weather overlay text, splits delimiter byte `$18` into NUL
;   separators, and draws up to 10 segments into brush raster text columns.
; NOTES:
;   Uses caller brush/rastport at A3 and restores original APen/DrMd on exit.
;   Segment width is trimmed via ESQFUNC_TrimTextToPixelWidthWordBoundary.
;------------------------------------------------------------------------------
ESQIFF_DrawWeatherStatusOverlayIntoBrush:
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
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #80,D1
    ADD.L   D1,D1
    SUB.L   D0,D1
    MOVE.L  -32(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-36(A5)
    MOVE.L  D1,D0
    MOVE.L  D1,-40(A5)
    MOVE.L  -36(A5),D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    BSR.W   ESQFUNC_TrimTextToPixelWidthWordBoundary

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
    BSR.W   ESQFUNC_TrimTextToPixelWidthWordBoundary

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
    PEA     Global_STR_ESQIFF_C_1
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

;------------------------------------------------------------------------------
; FUNC: ESQIFF_QueueIffBrushLoad   (Queue weather-status brush load or render path)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_BRUSH_CloneBrushRecord, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQIFF_JMPTBL_STRING_CompareNoCase, ESQIFF_DrawWeatherStatusOverlayIntoBrush
; READS:
;   Global_STR_ESQIFF_C_2, _PARSEINI_BannerBrushResourceHead, _CTASKS_PendingIffBrushDescriptor, ESQIFF_BannerBrushResourceCursor, ESQIFF_STR_WEATHER, _WDISP_WeatherStatusCountdown, _WDISP_WeatherStatusDigitChar
; WRITES:
;   _CTASKS_PendingIffBrushDescriptor, _WDISP_WeatherStatusBrushListHead, _CTASKS_IffTaskState, ESQIFF_BannerBrushResourceCursor
; DESC:
;   Resolves next banner brush resource and either queues an async IFF brush load,
;   or allocates/clones a brush and renders weather-status overlay text immediately.
; NOTES:
;   Mode arg `2` keeps current resource cursor; other modes advance linked cursor.
;------------------------------------------------------------------------------
ESQIFF_QueueIffBrushLoad:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   ESQIFF_BannerBrushResourceCursor
    BEQ.S   .seed_resource_cursor

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .skip_resource_seed

.seed_resource_cursor:
    MOVE.L  _PARSEINI_BannerBrushResourceHead,ESQIFF_BannerBrushResourceCursor

.skip_resource_seed:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.W   .queue_standard_iff_task

    PEA     ESQIFF_STR_WEATHER
    MOVE.L  ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .render_weather_overlay_now

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.W   .queue_standard_iff_task

.render_weather_overlay_now:
    MOVE.B  _WDISP_WeatherStatusCountdown,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .finalize_and_advance_resource_cursor

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,_CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #11,190(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #$280,128(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #160,130(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.B  #3,136(A0)
    MOVE.L  _CTASKS_PendingIffBrushDescriptor,(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(PC)

    MOVE.L  D0,_WDISP_WeatherStatusBrushListHead
    MOVE.L  D0,(A7)
    BSR.W   ESQIFF_DrawWeatherStatusOverlayIntoBrush

    PEA     238.W
    MOVE.L  _CTASKS_PendingIffBrushDescriptor,-(A7)
    PEA     724.W
    PEA     Global_STR_ESQIFF_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    BRA.S   .finalize_and_advance_resource_cursor

.queue_standard_iff_task:
    TST.L   ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    TST.L   ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,_CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #$6,190(A0)
    MOVE.W  #6,_CTASKS_IffTaskState
    JSR     ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

    ADDQ.W  #8,A7

.finalize_and_advance_resource_cursor:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BEQ.S   .return

    MOVEA.L ESQIFF_BannerBrushResourceCursor,A0
    MOVE.L  234(A0),ESQIFF_BannerBrushResourceCursor

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    LINK.W  A5,#0
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RenderWeatherStatusBrushSlice   (Render one weather-status brush slice and update counters)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
; READS:
;   ESQIFF_RenderWeatherStatusBrushSlice_Return, CONFIG_NewgridSelectionCode16EnabledFlag, ESQFUNC_WeatherSliceWidthInitGate, ESQIFF_WeatherSliceRemainingWidth, ESQIFF_WeatherSliceSourceOffset, ESQIFF_WeatherSliceValidateGateFlag
; WRITES:
;   ESQFUNC_WeatherSliceWidthInitGate, ESQIFF_WeatherSliceRemainingWidth, ESQIFF_WeatherSliceSourceOffset, ESQIFF_WeatherSliceValidateGateFlag
; DESC:
;   Initializes/continues weather-slice progress state, blits one or two brush
;   slices depending on mode byte, and updates remaining/consumed pixel counters.
; NOTES:
;   Triggers NEWGRID selection validation once when mode=11 and one-shot flag is set.
;------------------------------------------------------------------------------
ESQIFF_RenderWeatherStatusBrushSlice:
    MOVEM.L D2/D6-D7/A2-A3,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVEA.L,2,A2

    MOVE.L  A2,D0
    BNE.S   .ensure_slice_state_initialized

    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_WeatherSliceRemainingWidth
    BRA.W   ESQIFF_RenderWeatherStatusBrushSlice_Return

.ensure_slice_state_initialized:
    MOVE.W  ESQIFF_WeatherSliceRemainingWidth,D0
    TST.W   D0
    BLE.S   .reset_slice_state

    TST.W   ESQFUNC_WeatherSliceWidthInitGate
    BEQ.S   .clamp_slice_width

.reset_slice_state:
    MOVEQ   #0,D0
    MOVE.W  D0,ESQFUNC_WeatherSliceWidthInitGate
    MOVE.W  178(A2),D1
    MOVE.B  #$1,ESQIFF_WeatherSliceValidateGateFlag
    MOVE.W  D0,ESQIFF_WeatherSliceSourceOffset
    MOVE.W  D1,ESQIFF_WeatherSliceRemainingWidth

.clamp_slice_width:
    MOVE.W  ESQIFF_WeatherSliceRemainingWidth,D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   .use_max_slice_width

    MOVE.L  D0,D7
    BRA.S   .dispatch_slice_blit_by_mode

.use_max_slice_width:
    MOVE.L  D1,D7

.dispatch_slice_blit_by_mode:
    MOVEQ   #9,D0
    CMP.B   32(A2),D0
    BNE.S   .blit_centered_slice

    MOVEQ   #42,D6
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    ADD.L   D6,D0
    MOVE.L  D7,D1
    EXT.L   D1
    LEA     60(A3),A0
    MOVE.W  ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    MOVE.L  #$28e,D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    SUBQ.L  #1,D6
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D6,D1
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     60(A3),A0
    MOVE.W  ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     52(A7),A7
    BRA.S   .update_slice_progress_and_return

.blit_centered_slice:
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    MOVE.L  #696,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .half_centered_offset_ready

    ADDQ.L  #1,D1

.half_centered_offset_ready:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    SUBQ.L  #1,D6
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D6,D1
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     60(A3),A0
    MOVE.W  ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEQ   #11,D0
    CMP.B   32(A2),D0
    BNE.S   .update_slice_progress_and_return

    MOVEQ   #1,D0
    CMP.B   ESQIFF_WeatherSliceValidateGateFlag,D0
    BNE.S   .update_slice_progress_and_return

    MOVE.B  CONFIG_NewgridSelectionCode16EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_slice_progress_and_return

    PEA     16.W
    MOVE.L  A3,-(A7)
    JSR     _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    ADDQ.W  #8,A7
    CLR.B   ESQIFF_WeatherSliceValidateGateFlag

.update_slice_progress_and_return:
    SUB.W   D7,ESQIFF_WeatherSliceRemainingWidth
    ADD.W   D7,ESQIFF_WeatherSliceSourceOffset
    MOVE.L  D7,D0
    TST.W   D0
    BPL.S   .store_half_slice_width

    ADDQ.W  #1,D0

.store_half_slice_width:
    ASR.W   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.W  ESQIFF_WeatherSliceRemainingWidth,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RenderWeatherStatusBrushSlice_Return   (Return tail for weather-slice renderer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns residual slice width in D0.
; NOTES:
;   Shared return for null-brush and normal slice-render paths.
;------------------------------------------------------------------------------
ESQIFF_RenderWeatherStatusBrushSlice_Return:
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    RTS

;!======