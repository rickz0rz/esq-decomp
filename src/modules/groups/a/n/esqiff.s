    XDEF    ESQIFF_DrawWeatherStatusOverlayIntoBrush
    XDEF    ESQIFF_QueueIffBrushLoad
    XDEF    ESQIFF_QueueNextExternalAssetIffJob
    XDEF    ESQIFF_ReadNextExternalAssetPathEntry
    XDEF    ESQIFF_ReloadExternalAssetCatalogBuffers
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
;   ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_MATH_Mulu32, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQFUNC_TrimTextToPixelWidthWordBoundary, ESQPARS_ReplaceOwnedString, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, Global_STR_ESQIFF_C_1, WDISP_WeatherStatusOverlayTextPtr, ESQFUNC_PwBrushListHead, ESQFUNC_STR_I5, WDISP_WeatherStatusBrushIndex
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
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor: this string label sits immediately before
    ; an indexed pointer table used by weather-status brush lookup.
    LEA     ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  -4(A5),(A7)
    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,-(A7)
    MOVE.L  D0,-52(A5)
    JSR     ESQPARS_ReplaceOwnedString(PC)

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
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_BRUSH_CloneBrushRecord, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQIFF_JMPTBL_STRING_CompareNoCase, ESQIFF_DrawWeatherStatusOverlayIntoBrush
; READS:
;   Global_STR_ESQIFF_C_2, PARSEINI_BannerBrushResourceHead, CTASKS_PendingIffBrushDescriptor, ESQIFF_BannerBrushResourceCursor, ESQIFF_STR_WEATHER, WDISP_WeatherStatusCountdown, WDISP_WeatherStatusDigitChar
; WRITES:
;   CTASKS_PendingIffBrushDescriptor, WDISP_WeatherStatusBrushListHead, CTASKS_IffTaskState, ESQIFF_BannerBrushResourceCursor
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
    MOVE.L  PARSEINI_BannerBrushResourceHead,ESQIFF_BannerBrushResourceCursor

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
    MOVE.B  WDISP_WeatherStatusCountdown,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .finalize_and_advance_resource_cursor

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #11,190(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #$280,128(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #160,130(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.B  #3,136(A0)
    MOVE.L  CTASKS_PendingIffBrushDescriptor,(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(PC)

    MOVE.L  D0,WDISP_WeatherStatusBrushListHead
    MOVE.L  D0,(A7)
    BSR.W   ESQIFF_DrawWeatherStatusOverlayIntoBrush

    PEA     238.W
    MOVE.L  CTASKS_PendingIffBrushDescriptor,-(A7)
    PEA     724.W
    PEA     Global_STR_ESQIFF_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    BRA.S   .finalize_and_advance_resource_cursor

.queue_standard_iff_task:
    TST.L   ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    TST.L   ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #$6,190(A0)
    MOVE.W  #6,CTASKS_IffTaskState
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
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
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
    JSR     ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

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

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ReloadExternalAssetCatalogBuffers   (Reload external asset catalog blobs and reset brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle, ESQIFF_JMPTBL_MEMORY_AllocateMemory, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQIFF_JMPTBL_DOS_OpenFileWithMode, _LVOClose, _LVOForbid, _LVOPermit, _LVORead
; READS:
;   AbsExecBase, Global_PTR_STR_DF0_LOGO_LST, Global_PTR_STR_GFX_G_ADS, Global_REF_DOS_LIBRARY_2, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_3, Global_STR_ESQIFF_C_4, Global_STR_ESQIFF_C_5, Global_STR_ESQIFF_C_6, CTASKS_IffTaskDoneFlag, ED_DiagGraphModeChar, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, SCRIPT_CtrlInterfaceEnabledFlag, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DISKIO_DriveWriteProtectStatusCodeDrive1, MEMF_PUBLIC, MODE_OLDFILE
; WRITES:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_ExternalAssetFlags, ESQIFF_LogoListLineIndex, ESQIFF_GAdsListLineIndex
; DESC:
;   Frees current external brush lists/catalog buffers, reloads `gfx/g_ads.data`
;   and optionally `df0:logo.lst`, and sets availability bits on successful reads.
; NOTES:
;   Logo-list reload is skipped when the caller mode is non-zero or drive is write-protected.
;------------------------------------------------------------------------------
ESQIFF_ReloadExternalAssetCatalogBuffers:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack   4
    ; UseStackLong    MOVE.L,1,D7
    EmitStackAddress    1
    MOVE.L  .stackLong1(A7),D7

    TST.W   CTASKS_IffTaskDoneFlag
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .maybe_reload_logo_catalog

    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.W   .maybe_reload_logo_catalog

    TST.L   DISKIO_DriveWriteProtectStatusCodeDrive1
    BNE.W   .maybe_reload_logo_catalog

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)

    PEA     ESQIFF_GAdsBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7

    MOVEQ   #0,D0
    MOVE.L  D0,ESQIFF_GAdsBrushListCount
    CLR.W   ESQIFF_GAdsListLineIndex
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .loadGfxGAdsFile

    TST.L   Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .loadGfxGAdsFile

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     882.W
    PEA     Global_STR_ESQIFF_C_3
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadGfxGAdsFile:
    CLR.L   Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   Global_REF_LONG_GFX_G_ADS_FILESIZE

    PEA     MODE_OLDFILE
    MOVE.L  Global_PTR_STR_GFX_G_ADS,-(A7)
    JSR     ESQIFF_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .update_gads_line_cursor_shadow

    MOVE.L  D6,-(A7)
    JSR     ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_LONG_GFX_G_ADS_FILESIZE
    TST.L   D0
    BLE.S   .gfxGAdsFileWithoutData

    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     898.W
    PEA     Global_STR_ESQIFF_C_4
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_LONG_GFX_G_ADS_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    BNE.S   .gfxGAdsFileWithoutData

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ORI.W   #1,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags

.gfxGAdsFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.update_gads_line_cursor_shadow:
    TST.W   SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .clear_gads_line_cursor_shadow

    MOVE.W  #1,ESQIFF_GAdsListLineIndex
    BRA.S   .maybe_reload_logo_catalog

.clear_gads_line_cursor_shadow:
    CLR.W   ESQIFF_GAdsListLineIndex

.maybe_reload_logo_catalog:
    TST.L   D7
    BNE.W   .return

    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.W   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)
    PEA     ESQIFF_LogoBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,ESQIFF_LogoBrushListCount
    CLR.W   ESQIFF_LogoListLineIndex
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .loadDf0LogoLstFile

    TST.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .loadDf0LogoLstFile

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     963.W
    PEA     Global_STR_ESQIFF_C_5
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadDf0LogoLstFile:
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    PEA     MODE_OLDFILE
    MOVE.L  Global_PTR_STR_DF0_LOGO_LST,-(A7)
    JSR     ESQIFF_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .return

    MOVE.L  D6,-(A7)
    JSR     ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    TST.L   D0
    BLE.S   .df0LogoLstFileWithoutData

    ADDQ.L  #1,D0

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     979.W
    PEA     Global_STR_ESQIFF_C_6
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,Global_REF_LONG_DF0_LOGO_LST_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    BNE.S   .df0LogoLstFileWithoutData

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ORI.W   #2,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags

.df0LogoLstFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_QueueNextExternalAssetIffJob   (Queue next external-asset IFF decode job)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +76: arg_3 (via 80(A5))
;   stack +116: arg_4 (via 120(A5))
;   stack +124: arg_5 (via 128(A5))
;   stack +126: arg_6 (via 130(A5))
;   stack +130: arg_7 (via 134(A5))
;   stack +134: arg_8 (via 138(A5))
;   stack +138: arg_9 (via 142(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, ESQIFF_JMPTBL_STRING_CompareNoCaseN, ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard, GCOMMAND_FindPathSeparator, ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReadNextExternalAssetPathEntry, _LVOForbid, _LVOPermit
; READS:
;   AbsExecBase, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_GFX_G_ADS_DATA, CTASKS_IffTaskDoneFlag, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, ESQIFF_PATH_DF0_COLON, ESQIFF_PATH_RAM_COLON_LOGOS_SLASH, ESQIFF_LogoListLineIndex, ESQIFF_AssetSourceSelect, ESQIFF_ExternalAssetPathCommaFlag, _TEXTDISP_CurrentMatchIndex, fa00
; WRITES:
;   CTASKS_PendingLogoBrushDescriptor, CTASKS_PendingGAdsBrushDescriptor, ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_PendingExternalBrushNode, ESQIFF_ExternalAssetStateTable, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses the next external asset path from active catalog data, filters/skips
;   disallowed entries, allocates a descriptor, and starts IFF decode task when needed.
; NOTES:
;   Uses `_TEXTDISP_CurrentMatchIndex` snapshot/restore while probing wildcard matches.
;------------------------------------------------------------------------------
ESQIFF_QueueNextExternalAssetIffJob:
    LINK.W  A5,#-144
    MOVEM.L D2/D5-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-138(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   CTASKS_IffTaskDoneFlag
    BNE.S   .permit_and_return_no_job

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.permit_and_return_no_job:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .check_gads_quota

    CMPI.L  #$1,ESQIFF_LogoBrushListCount
    BLT.S   .check_gads_quota

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.check_gads_quota:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BNE.S   .begin_path_selection

    CMPI.L  #$2,ESQIFF_GAdsBrushListCount
    BLT.S   .begin_path_selection

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.begin_path_selection:
    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    MOVE.B  D0,-40(A5)
    MOVE.W  ESQIFF_LogoListLineIndex,D6
    MOVEQ   #0,D1
    MOVE.W  D1,-128(A5)
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .check_gads_blob_for_source0

    MOVE.W  ESQIFF_AssetSourceSelect,D2
    BNE.S   .scan_candidate_paths

.check_gads_blob_for_source0:
    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.W   .finalize_no_candidate

    MOVE.W  ESQIFF_AssetSourceSelect,D2
    BNE.W   .finalize_no_candidate

.scan_candidate_paths:
    MOVE.B  D0,-41(A5)
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D5

.loop_read_candidate_path:
    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7
    LEA     -40(A5),A0
    MOVEA.L A0,A1

.loop_measure_candidate_len:
    TST.B   (A1)+
    BNE.S   .loop_measure_candidate_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BEQ.W   .check_scan_progress_or_retry

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .validate_source0_path_prefixes

    TST.W   ESQIFF_ExternalAssetPathCommaFlag
    BEQ.S   .build_wildcard_probe_path

    MOVE.W  #1,-128(A5)
    BRA.W   .finalize_candidate_filter

.build_wildcard_probe_path:
    MOVEQ   #0,D7

.loop_rewrite_bang_to_wildcard:
    MOVEQ   #40,D0
    CMP.W   D0,D7
    BGE.S   .probe_match_index_by_wildcard

    MOVE.B  -40(A5,D7.W),-80(A5,D7.W)
    TST.B   -80(A5,D7.W)
    BEQ.S   .probe_match_index_by_wildcard

    MOVEQ   #33,D0
    CMP.B   -80(A5,D7.W),D0
    BNE.S   .advance_probe_char

    MOVE.B  #$2a,-80(A5,D7.W)
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.B   -79(A5,D0.L)
    BRA.S   .probe_match_index_by_wildcard

.advance_probe_char:
    ADDQ.W  #1,D7
    BRA.S   .loop_rewrite_bang_to_wildcard

.probe_match_index_by_wildcard:
    PEA     -80(A5)
    JSR     GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D0,(A7)
    JSR     ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .yield_grid_while_scanning

    MOVE.W  #1,-128(A5)
    MOVE.W  _TEXTDISP_CurrentMatchIndex,ESQIFF_ExternalAssetStateTable
    BRA.S   .finalize_candidate_filter

.validate_source0_path_prefixes:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     ESQIFF_PATH_DF0_COLON
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .finalize_candidate_filter

    MOVEQ   #11,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     ESQIFF_PATH_RAM_COLON_LOGOS_SLASH
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .finalize_candidate_filter

    MOVE.W  #1,-128(A5)
    BRA.S   .finalize_candidate_filter

.yield_grid_while_scanning:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

.check_scan_progress_or_retry:
    MOVE.W  ESQIFF_LogoListLineIndex,D0
    CMP.W   D0,D6
    BNE.W   .loop_read_candidate_path

.finalize_candidate_filter:
    MOVE.W  D5,_TEXTDISP_CurrentMatchIndex
    TST.W   -128(A5)
    BEQ.W   .finalize_no_candidate

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .set_logo_poll_limit

    MOVE.L  #$fa00,-134(A5)
    BRA.S   .snapshot_candidate_path

.set_logo_poll_limit:
    MOVE.L  #$13880,-134(A5)

.snapshot_candidate_path:
    LEA     -40(A5),A0
    LEA     -120(A5),A1

.loop_copy_candidate_snapshot:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loop_copy_candidate_snapshot

.loop_queue_until_path_changes:
    MOVE.W  #1,-130(A5)
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .select_gads_list_head

    MOVEA.L ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-142(A5)
    BRA.S   .test_duplicate_head_path

.select_gads_list_head:
    MOVEA.L ESQIFF_GAdsBrushListHead,A0
    MOVE.L  A0,-142(A5)

.test_duplicate_head_path:
    MOVE.L  A0,D0
    BEQ.S   .allocate_descriptor_if_needed

    CMPA.L  ESQIFF_LogoBrushListHead,A0
    BNE.S   .allocate_descriptor_if_needed

    LEA     -40(A5),A0
    MOVEA.L -142(A5),A1

.loop_compare_candidate_with_head:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .allocate_descriptor_if_needed

    TST.B   D0
    BNE.S   .loop_compare_candidate_with_head

    BNE.S   .allocate_descriptor_if_needed

    MOVEQ   #1,D0
    MOVE.L  D0,-138(A5)

.allocate_descriptor_if_needed:
    TST.L   -138(A5)
    BNE.S   .poll_until_path_change_or_timeout

    CLR.L   -(A7)
    PEA     -40(A5)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.W  ESQIFF_AssetSourceSelect,D1
    MOVE.L  D0,ESQIFF_PendingExternalBrushNode
    TST.W   D1
    BEQ.S   .init_gads_pending_descriptor

    MOVEA.L D0,A0
    MOVE.B  #$4,190(A0)
    MOVE.L  D0,CTASKS_PendingLogoBrushDescriptor
    BRA.S   .start_iff_task_for_pending_descriptor

.init_gads_pending_descriptor:
    MOVEA.L D0,A0
    MOVE.B  #$5,190(A0)
    MOVE.L  D0,CTASKS_PendingGAdsBrushDescriptor

.start_iff_task_for_pending_descriptor:
    JSR     ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

.poll_until_path_change_or_timeout:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BNE.S   .compare_snapshot_with_current_path

    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7

.compare_snapshot_with_current_path:
    LEA     -120(A5),A0
    LEA     -40(A5),A1

.loop_compare_paths:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .retry_queue_loop_if_timeout

    TST.B   D0
    BNE.S   .loop_compare_paths

    BEQ.S   .finalize_no_candidate

.retry_queue_loop_if_timeout:
    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BEQ.W   .loop_queue_until_path_changes

.finalize_no_candidate:
    TST.W   -128(A5)
    BNE.S   .return_current_timeout_state

    MOVEQ   #-1,D0
    MOVE.W  D0,-130(A5)

.return_current_timeout_state:
    MOVE.W  -130(A5),D0

.return:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ReadNextExternalAssetPathEntry   (Read next newline-delimited external asset path entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   ESQDISP_ProcessGridMessagesIfIdle
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, ESQIFF_LogoListLineIndex, ESQIFF_GAdsListLineIndex, ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled
; WRITES:
;   ESQIFF_LogoListLineIndex, ESQIFF_GAdsListLineIndex, ESQIFF_ExternalAssetPathCommaFlag
; DESC:
;   Selects active catalog stream, advances to current line index, then copies one
;   path entry into output buffer stopping on CR/LF/space or comma delimiters.
; NOTES:
;   Comma delimiter sets ESQIFF_ExternalAssetPathCommaFlag and returns empty string.
;------------------------------------------------------------------------------
ESQIFF_ReadNextExternalAssetPathEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .select_gads_catalog

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    MOVE.W  ESQIFF_LogoListLineIndex,D6
    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .begin_line_seek

.select_gads_catalog:
    MOVE.W  ESQIFF_GAdsSourceEnabled,D0
    BEQ.S   .return_no_catalog_enabled

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)
    MOVE.W  ESQIFF_GAdsListLineIndex,D6
    BRA.S   .begin_line_seek

.return_no_catalog_enabled:
    MOVEQ   #0,D0
    BRA.W   .return

.begin_line_seek:
    MOVEQ   #0,D7

.loop_seek_to_target_line:
    CMP.W   D6,D7
    BGE.S   .begin_entry_copy

    TST.L   D4
    BLE.S   .begin_entry_copy

    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BNE.S   .consume_seek_char

    ADDQ.W  #1,D7

.consume_seek_char:
    SUBQ.L  #1,D4
    BRA.S   .loop_seek_to_target_line

.begin_entry_copy:
    TST.L   D4
    BNE.S   .advance_line_index_counter

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .reload_gads_catalog_start

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    BRA.S   .reset_line_index_to_one

.reload_gads_catalog_start:
    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)

.reset_line_index_to_one:
    MOVEQ   #1,D6
    BRA.S   .store_updated_line_index

.advance_line_index_counter:
    ADDQ.W  #1,D6

.store_updated_line_index:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .store_gads_line_index

    MOVE.W  D6,ESQIFF_LogoListLineIndex
    BRA.S   .loop_copy_entry_chars

.store_gads_line_index:
    MOVE.W  D6,ESQIFF_GAdsListLineIndex

.loop_copy_entry_chars:
    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #13,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #32,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVE.L  D4,D0
    SUBQ.L  #1,D4
    TST.L   D0
    BLE.S   .terminate_and_return_entry

    MOVEQ   #44,D0
    CMP.B   D0,D5
    BNE.S   .append_entry_char

    CLR.B   (A3)
    MOVE.W  #1,ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .terminate_and_return_entry

.append_entry_char:
    MOVE.B  D5,(A3)+
    BRA.S   .loop_copy_entry_chars

.terminate_and_return_entry:
    CLR.B   (A3)
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
