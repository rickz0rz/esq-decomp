    XDEF    ESQIFF_DeallocateAdsAndLogoLstData
    XDEF    ESQIFF_DrawWeatherStatusOverlayIntoBrush
    XDEF    ESQIFF_HandleBrushIniReloadHotkey
    XDEF    ESQIFF_PlayNextExternalAssetFrame
    XDEF    ESQIFF_QueueIffBrushLoad
    XDEF    ESQIFF_QueueNextExternalAssetIffJob
    XDEF    ESQIFF_ReadNextExternalAssetPathEntry
    XDEF    ESQIFF_ReloadExternalAssetCatalogBuffers
    XDEF    ESQIFF_RenderWeatherStatusBrushSlice
    XDEF    ESQIFF_RestoreBasePaletteTriples
    XDEF    ESQIFF_RunCopperDropTransition
    XDEF    ESQIFF_RunCopperRiseTransition
    XDEF    ESQIFF_RunPendingCopperAnimations
    XDEF    ESQIFF_ServiceExternalAssetSourceState
    XDEF    ESQIFF_ServicePendingCopperPaletteMoves
    XDEF    ESQIFF_SetApenToBrightestPaletteIndex
    XDEF    ESQIFF_ShowExternalAssetWithCopperFx
    XDEF    ESQIFF_JMPTBL_BRUSH_AllocBrushNode
    XDEF    ESQIFF_JMPTBL_BRUSH_CloneBrushRecord
    XDEF    ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate
    XDEF    ESQIFF_JMPTBL_BRUSH_FindType3Brush
    XDEF    ESQIFF_JMPTBL_BRUSH_FreeBrushList
    XDEF    ESQIFF_JMPTBL_BRUSH_PopBrushHead
    XDEF    ESQIFF_JMPTBL_BRUSH_PopulateBrushList
    XDEF    ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel
    XDEF    ESQIFF_JMPTBL_BRUSH_SelectBrushSlot
    XDEF    ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess
    XDEF    ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle
    XDEF    ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle
    XDEF    ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle
    XDEF    ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary
    XDEF    ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets
    XDEF    ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd
    XDEF    ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp_006A
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp_0074
    XDEF    ESQIFF_JMPTBL_MATH_DivS32
    XDEF    ESQIFF_JMPTBL_MATH_Mulu32
    XDEF    ESQIFF_JMPTBL_MEMORY_AllocateMemory
    XDEF    ESQIFF_JMPTBL_MEMORY_DeallocateMemory
    XDEF    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
    XDEF    ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled
    XDEF    ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition
    XDEF    ESQIFF_JMPTBL_STRING_CompareN
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCase
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCaseN
    XDEF    ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner
    XDEF    ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard
    XDEF    ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode
    XDEF    ESQIFF_JMPTBL_DOS_OpenFileWithMode
    XDEF    ESQIFF_PlayNextExternalAssetFrame_Return
    XDEF    ESQIFF_RenderWeatherStatusBrushSlice_Return
    XDEF    ESQIFF_ShowExternalAssetWithCopperFx_Return

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
;   Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, Global_STR_ESQIFF_C_1, WDISP_WeatherStatusOverlayTextPtr, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_STR_I5_1EDD, WDISP_WeatherStatusBrushIndex
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
    LEA     DATA_ESQFUNC_STR_I5_1EDD,A0
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
;   Global_STR_ESQIFF_C_2, PARSEINI_BannerBrushResourceHead, CTASKS_PendingIffBrushDescriptor, DATA_ESQIFF_BSS_LONG_1EE9, DATA_ESQIFF_STR_WEATHER_1EEA, WDISP_WeatherStatusCountdown, WDISP_WeatherStatusDigitChar
; WRITES:
;   CTASKS_PendingIffBrushDescriptor, WDISP_WeatherStatusBrushListHead, CTASKS_IffTaskState, DATA_ESQIFF_BSS_LONG_1EE9
; DESC:
;   Resolves next banner brush resource and either queues an async IFF brush load,
;   or allocates/clones a brush and renders weather-status overlay text immediately.
; NOTES:
;   Mode arg `2` keeps current resource cursor; other modes advance linked cursor.
;------------------------------------------------------------------------------
ESQIFF_QueueIffBrushLoad:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .seed_resource_cursor

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .skip_resource_seed

.seed_resource_cursor:
    MOVE.L  PARSEINI_BannerBrushResourceHead,DATA_ESQIFF_BSS_LONG_1EE9

.skip_resource_seed:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.W   .queue_standard_iff_task

    PEA     DATA_ESQIFF_STR_WEATHER_1EEA
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
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
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
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
    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .finalize_and_advance_resource_cursor

    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
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

    MOVEA.L DATA_ESQIFF_BSS_LONG_1EE9,A0
    MOVE.L  234(A0),DATA_ESQIFF_BSS_LONG_1EE9

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
;   ESQIFF_RenderWeatherStatusBrushSlice_Return, DATA_CTASKS_STR_Y_1BBF, DATA_ESQFUNC_CONST_WORD_1ECD, DATA_ESQIFF_BSS_WORD_1EEC, DATA_ESQIFF_BSS_WORD_1EED, DATA_ESQIFF_CONST_WORD_1EEE
; WRITES:
;   DATA_ESQFUNC_CONST_WORD_1ECD, DATA_ESQIFF_BSS_WORD_1EEC, DATA_ESQIFF_BSS_WORD_1EED, DATA_ESQIFF_CONST_WORD_1EEE
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
    MOVE.W  D0,DATA_ESQIFF_BSS_WORD_1EEC
    BRA.W   ESQIFF_RenderWeatherStatusBrushSlice_Return

.ensure_slice_state_initialized:
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0
    TST.W   D0
    BLE.S   .reset_slice_state

    TST.W   DATA_ESQFUNC_CONST_WORD_1ECD
    BEQ.S   .clamp_slice_width

.reset_slice_state:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQFUNC_CONST_WORD_1ECD
    MOVE.W  178(A2),D1
    MOVE.B  #$1,DATA_ESQIFF_CONST_WORD_1EEE
    MOVE.W  D0,DATA_ESQIFF_BSS_WORD_1EED
    MOVE.W  D1,DATA_ESQIFF_BSS_WORD_1EEC

.clamp_slice_width:
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0
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
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
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
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
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
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
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
    CMP.B   DATA_ESQIFF_CONST_WORD_1EEE,D0
    BNE.S   .update_slice_progress_and_return

    MOVE.B  DATA_CTASKS_STR_Y_1BBF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_slice_progress_and_return

    PEA     16.W
    MOVE.L  A3,-(A7)
    JSR     ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    ADDQ.W  #8,A7
    CLR.B   DATA_ESQIFF_CONST_WORD_1EEE

.update_slice_progress_and_return:
    SUB.W   D7,DATA_ESQIFF_BSS_WORD_1EEC
    ADD.W   D7,DATA_ESQIFF_BSS_WORD_1EED
    MOVE.L  D7,D0
    TST.W   D0
    BPL.S   .store_half_slice_width

    ADDQ.W  #1,D0

.store_half_slice_width:
    ASR.W   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0

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
;   AbsExecBase, Global_PTR_STR_DF0_LOGO_LST, Global_PTR_STR_GFX_G_ADS, Global_REF_DOS_LIBRARY_2, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_3, Global_STR_ESQIFF_C_4, Global_STR_ESQIFF_C_5, Global_STR_ESQIFF_C_6, CTASKS_IffTaskDoneFlag, ED_DiagGraphModeChar, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, DATA_WDISP_BSS_WORD_2294, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_2319, MEMF_PUBLIC, MODE_OLDFILE
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

    TST.L   DATA_WDISP_BSS_LONG_2319
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
    TST.W   DATA_WDISP_BSS_WORD_2294
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
;   AbsExecBase, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_GFX_G_ADS_DATA, CTASKS_IffTaskDoneFlag, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, DATA_ESQIFF_PATH_DF0_COLON_1EF3, DATA_ESQIFF_PATH_RAM_COLON_LOGOS_SLASH_1EF4, ESQIFF_LogoListLineIndex, ESQIFF_AssetSourceSelect, ESQIFF_ExternalAssetPathCommaFlag, TEXTDISP_CurrentMatchIndex, fa00
; WRITES:
;   CTASKS_PendingLogoBrushDescriptor, CTASKS_PendingGAdsBrushDescriptor, ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, DATA_WDISP_BSS_LONG_22A8, DATA_WDISP_BSS_LONG_22C2, TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses the next external asset path from active catalog data, filters/skips
;   disallowed entries, allocates a descriptor, and starts IFF decode task when needed.
; NOTES:
;   Uses `TEXTDISP_CurrentMatchIndex` snapshot/restore while probing wildcard matches.
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
    MOVE.W  TEXTDISP_CurrentMatchIndex,D5

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
    MOVE.W  TEXTDISP_CurrentMatchIndex,DATA_WDISP_BSS_LONG_22C2
    BRA.S   .finalize_candidate_filter

.validate_source0_path_prefixes:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     DATA_ESQIFF_PATH_DF0_COLON_1EF3
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .finalize_candidate_filter

    MOVEQ   #11,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     DATA_ESQIFF_PATH_RAM_COLON_LOGOS_SLASH_1EF4
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
    MOVE.W  D5,TEXTDISP_CurrentMatchIndex
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
    MOVE.L  D0,DATA_WDISP_BSS_LONG_22A8
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

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RestoreBasePaletteTriples   (RestoreBasePaletteTriples)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   DATA_ESQFUNC_CONST_LONG_1ECC, WDISP_PaletteTriplesRBase
; WRITES:
;   (none observed)
; DESC:
;   Restores 24 palette bytes from DATA_ESQFUNC_CONST_LONG_1ECC into
;   WDISP_PaletteTriplesRBase.
; NOTES:
;   Fixed-length byte copy loop; used before startup/status render transitions.
;------------------------------------------------------------------------------
ESQIFF_RestoreBasePaletteTriples:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_0A46:
    MOVEQ   #24,D0
    CMP.W   D0,D7
    BGE.S   .return

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.W  D7,A0
    LEA     DATA_ESQFUNC_CONST_LONG_1ECC,A1
    ADDA.W  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0A46

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperRiseTransition   (RunCopperRiseTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B1C
; DESC:
;   Arms copper rise-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes DATA_COMMON_BSS_WORD_1B1C = 15 before invoking ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
ESQIFF_RunCopperRiseTransition:
    MOVE.W  #15,DATA_COMMON_BSS_WORD_1B1C
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperDropTransition   (RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B1B
; DESC:
;   Arms copper drop-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes DATA_COMMON_BSS_WORD_1B1B = 15 before invoking ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
ESQIFF_RunCopperDropTransition:
    MOVE.W  #15,DATA_COMMON_BSS_WORD_1B1B
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServicePendingCopperPaletteMoves   (Service pending copper index moves for four accumulator rows)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd, ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
; READS:
;   Global_REF_LONG_FILE_SCRATCH, DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18, WDISP_AccumulatorRow0_MoveFlags, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_MoveFlags, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_MoveFlags, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_MoveFlags, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd
; WRITES:
;   DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18
; DESC:
;   Checks per-row move countdown words and, when armed, steps the configured
;   copper index range toward start or end for rows 0..3.
; NOTES:
;   Uses move-flag bit1 as direction: set=toward end, clear=toward start.
;------------------------------------------------------------------------------
ESQIFF_ServicePendingCopperPaletteMoves:
    MOVE.L  A4,-(A7)
    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  DATA_COMMON_BSS_WORD_1B15,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row1_pending_move

    TST.W   WDISP_AccumulatorRow0_MoveFlags
    BEQ.S   .service_row1_pending_move

    CLR.W   DATA_COMMON_BSS_WORD_1B15
    MOVE.W  WDISP_AccumulatorRow0_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row0_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row1_pending_move

.move_row0_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row1_pending_move:
    MOVE.W  DATA_COMMON_BSS_WORD_1B16,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row2_pending_move

    TST.W   WDISP_AccumulatorRow1_MoveFlags
    BEQ.S   .service_row2_pending_move

    CLR.W   DATA_COMMON_BSS_WORD_1B16
    MOVE.W  WDISP_AccumulatorRow1_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row1_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row2_pending_move

.move_row1_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row2_pending_move:
    MOVE.W  DATA_COMMON_BSS_WORD_1B17,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row3_pending_move

    TST.W   WDISP_AccumulatorRow2_MoveFlags
    BEQ.S   .service_row3_pending_move

    CLR.W   DATA_COMMON_BSS_WORD_1B17
    MOVE.W  WDISP_AccumulatorRow2_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row2_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row3_pending_move

.move_row2_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row3_pending_move:
    MOVE.W  DATA_COMMON_BSS_LONG_1B18,D0
    SUBQ.W  #1,D0
    BNE.S   .return_service_pending_copper_moves

    TST.W   WDISP_AccumulatorRow3_MoveFlags
    BEQ.S   .return_service_pending_copper_moves

    CLR.W   DATA_COMMON_BSS_LONG_1B18
    MOVE.W  WDISP_AccumulatorRow3_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row3_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .return_service_pending_copper_moves

.move_row3_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.return_service_pending_copper_moves:
    MOVEA.L (A7)+,A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_SetApenToBrightestPaletteIndex   (Set APen to brightest palette triple within active depth)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, WDISP_DisplayContextBase, WDISP_PaletteTriplesRBase, WDISP_PaletteTriplesGBase, WDISP_PaletteTriplesBBase, DATA_WDISP_BSS_LONG_22AE
; WRITES:
;   (none observed)
; DESC:
;   Scans active palette entries, picks the index with highest summed RGB
;   intensity, and applies it to the display-context rastport APen.
; NOTES:
;   Palette scan upper bound is derived from active depth bit (`22AE`).
;------------------------------------------------------------------------------
ESQIFF_SetApenToBrightestPaletteIndex:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_LONG_22AE,D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVE.B  WDISP_PaletteTriplesRBase,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesGBase,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesBBase,D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    CLR.L   -14(A5)
    MOVEQ   #1,D7

.loop_palette_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    CMP.L   D4,D0
    BGE.S   .apply_best_palette_index

    MOVE.L  D7,D0
    MOVEQ   #3,D1
    MULS    D1,D0
    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    MULS    D1,D0
    LEA     WDISP_PaletteTriplesGBase,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVEQ   #0,D2
    MOVE.B  (A1),D2
    ADD.L   D2,D0
    MOVE.L  D7,D2
    MULS    D1,D2
    LEA     WDISP_PaletteTriplesBBase,A0
    ADDA.L  D2,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    CMP.W   D5,D6
    BGE.S   .next_palette_entry

    MOVE.L  D5,D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-14(A5)

.next_palette_entry:
    ADDQ.W  #1,D7
    BRA.S   .loop_palette_entries

.apply_best_palette_index:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVE.L  -14(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx   (Blit external asset with copper transition effects)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition, ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, _LVOCopyMem, _LVOSetAPen, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, SCRIPT_BannerTransitionActive, WDISP_DisplayContextBase, WDISP_PaletteTriplesRBase, WDISP_AccumulatorRowTable, WDISP_AccumulatorRow0_Value, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_Value, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_Value, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_Value, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd, e8
; WRITES:
;   DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, DATA_COMMON_BSS_WORD_1B10, DATA_COMMON_BSS_WORD_1B11, DATA_COMMON_BSS_WORD_1B12, DATA_COMMON_BSS_WORD_1B13, DATA_COMMON_BSS_WORD_1B14, DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18, DATA_ESQFUNC_BSS_WORD_1EE4, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; DESC:
;   Selects source brush list by mode, performs drop/rise copper transitions, builds
;   a display context, blits the external asset, and captures accumulator thresholds
;   used by subsequent copper palette motion.
; NOTES:
;   Missing-asset path sets DATA_ESQFUNC_BSS_WORD_1EE4 bits to request deferred retries.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx:
    LINK.W  A5,#-36
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    TST.W   D7
    BEQ.S   .select_primary_or_secondary_brush_head

    MOVE.L  ESQIFF_GAdsBrushListHead,-22(A5)

.select_primary_or_secondary_brush_head:
    TST.W   D7
    BNE.S   .ensure_brush_head_available

    MOVEA.L ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-22(A5)

.ensure_brush_head_available:
    TST.L   -22(A5)
    BEQ.W   .set_missing_asset_pending_flags

    BSR.W   ESQIFF_RunCopperDropTransition

    MOVEQ   #20,D6
    MOVEA.L -22(A5),A0
    ADD.W   178(A0),D6
    BTST    #2,199(A0)
    BEQ.S   .set_transition_divisor_two

    MOVEQ   #2,D0
    BRA.S   .compute_transition_steps

.set_transition_divisor_two:
    MOVEQ   #1,D0

.compute_transition_steps:
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,D0
    MOVE.L  20(A7),D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D6
    MOVEQ   #120,D0
    CMP.W   D0,D6
    BLE.S   .clamp_transition_steps

    MOVE.L  D0,D6

.clamp_transition_steps:
    ADDI.W  #22,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.wait_banner_transition_idle:
    TST.W   SCRIPT_BannerTransitionActive
    BNE.S   .wait_banner_transition_idle

    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
    MOVEQ   #0,D5

.loop_copy_accumulator_rows:
    MOVEQ   #4,D0
    CMP.L   D0,D5
    BGE.S   .select_display_context_mode

    MOVE.L  D5,D0
    ASL.L   #3,D0
    MOVEA.L -22(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     WDISP_AccumulatorRowTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,28(A7)
    MOVEA.L A1,A0
    MOVEA.L 28(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,D5
    BRA.S   .loop_copy_accumulator_rows

.select_display_context_mode:
    CLR.W   WDISP_AccumulatorCaptureActive
    MOVE.W  #1,WDISP_AccumulatorFlushPending
    MOVE.L  #$8004,D0
    MOVEA.L -22(A5),A0
    AND.L   196(A0),D0
    CMPI.L  #$8004,D0
    BNE.S   .select_mode_flag198_bit7

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     4.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_flag198_bit7:
    BTST    #7,198(A0)
    BEQ.S   .select_mode_flag199_bit2

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     6.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #10,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_flag199_bit2:
    BTST    #2,199(A0)
    BEQ.S   .select_mode_fallback

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     5.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_fallback:
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     7.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #10,D4

.clear_rast_and_blit_asset:
    MOVEA.L D0,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    LEA     10(A0),A1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -22(A5),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEA.L -22(A5),A0
    TST.L   328(A0)
    BEQ.S   .refresh_palette_triples_from_asset

    MOVEQ   #1,D0
    CMP.L   328(A0),D0
    BNE.S   .capture_accumulator_thresholds

.refresh_palette_triples_from_asset:
    PEA     5.W
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -22(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-14(A5)
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D5
    MOVE.L  D1,-18(A5)

.branch:
    CMP.L   -18(A5),D5
    BGE.S   .capture_accumulator_thresholds

    CMP.L   -14(A5),D5
    BGE.S   .capture_accumulator_thresholds

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D5,A0
    MOVEA.L -22(A5),A1
    MOVE.L  D5,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D5
    BRA.S   .branch

.capture_accumulator_thresholds:
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.W  WDISP_AccumulatorRow0_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_1

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D
    BRA.S   .branch_2

.branch_1:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D

.branch_2:
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.W  WDISP_AccumulatorRow1_Value,D2
    CMPI.W  #$4000,D2
    BGE.S   .branch_3

    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E
    BRA.S   .branch_4

.branch_3:
    MOVEQ   #0,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E

.branch_4:
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.W  WDISP_AccumulatorRow2_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_5

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F
    BRA.S   .branch_6

.branch_5:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F

.branch_6:
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.W  WDISP_AccumulatorRow3_Value,D1
    CMPI.W  #$4000,D1
    BGE.S   .branch_7

    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10
    BRA.S   .branch_8

.branch_7:
    MOVEQ   #0,D1
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10

.branch_8:
    TST.W   DATA_COMMON_BSS_WORD_1B0D
    BNE.S   .branch_9

    TST.W   DATA_COMMON_BSS_WORD_1B0E
    BNE.S   .branch_9

    TST.W   DATA_COMMON_BSS_WORD_1B0F
    BNE.S   .branch_9

    TST.W   D1
    BEQ.S   .branch_10

.branch_9:
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_AccumulatorCaptureActive

.branch_11:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B11
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B15
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B12
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B16
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B13
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B17
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B14
    MOVE.W  D0,DATA_COMMON_BSS_LONG_1B18
    BSR.W   ESQIFF_RunCopperRiseTransition

    BRA.S   ESQIFF_ShowExternalAssetWithCopperFx_Return

.set_missing_asset_pending_flags:
    TST.W   D7
    BEQ.S   .branch_12

    MOVEQ   #1,D0
    BRA.S   .branch_13

.branch_12:
    MOVEQ   #2,D0

.branch_13:
    OR.L    D0,DATA_ESQFUNC_BSS_WORD_1EE4

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx_Return   (Return tail for external-asset copper blit)
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
;   Restores registers/frame and returns from external-asset copper blit helper.
; NOTES:
;   Shared return for successful blit and missing-asset fallback paths.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx_Return:
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServiceExternalAssetSourceState   (Service external-asset source select and queue state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReloadExternalAssetCatalogBuffers, ESQIFF_QueueNextExternalAssetIffJob
; READS:
;   Global_WORD_SELECT_CODE_IS_RAVESC, DATA_COI_BSS_WORD_1B85, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_2319
; WRITES:
;   ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled
; DESC:
;   Sets source-selection flags by mode, conditionally reloads external catalogs,
;   then queues the next external asset IFF job.
; NOTES:
;   Skips reload/queue work during RAVESC select mode or COI busy gate.
;------------------------------------------------------------------------------
ESQIFF_ServiceExternalAssetSourceState:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .return

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   DATA_COI_BSS_WORD_1B85
    BNE.S   .return

    TST.W   D7
    BEQ.S   .configure_source_for_secondary_mode

    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_AssetSourceSelect
    MOVEQ   #-1,D1
    MOVE.W  D1,ESQIFF_GAdsSourceEnabled
    BRA.S   .reload_logo_catalog_if_needed

.configure_source_for_secondary_mode:
    CLR.W   ESQIFF_GAdsSourceEnabled
    MOVE.W  #(-1),ESQIFF_AssetSourceSelect

.reload_logo_catalog_if_needed:
    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.S   .reload_gads_catalog_if_needed

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #2,D0
    SUBQ.W  #2,D0
    BEQ.S   .reload_gads_catalog_if_needed

    CLR.L   -(A7)
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.reload_gads_catalog_if_needed:
    TST.L   DATA_WDISP_BSS_LONG_2319
    BNE.S   .queue_next_asset_after_reload_checks

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #1,D0
    SUBQ.W  #1,D0
    BEQ.S   .queue_next_asset_after_reload_checks

    PEA     1.W
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.queue_next_asset_after_reload_checks:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    BSR.W   ESQIFF_QueueNextExternalAssetIffJob

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame   (Render and retire next external asset frame)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, ESQIFF_JMPTBL_BRUSH_PopBrushHead, ESQIFF_JMPTBL_ESQ_NoOp, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled, ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner, GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_RestoreBasePaletteTriples, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, ESQIFF_SetApenToBrightestPaletteIndex, ESQIFF_ShowExternalAssetWithCopperFx, ESQIFF_ServiceExternalAssetSourceState, _LVOForbid, _LVOPermit, _LVOSetAPen, _LVOSetDrMd, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, TEXTDISP_DeferredActionCountdown, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, TEXTDISP_PrimaryGroupEntryCount, WDISP_AccumulatorCaptureActive, DATA_WDISP_BSS_LONG_22C2, ESQIFF_ExternalAssetPathCommaFlag
; WRITES:
;   ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses source brush head, renders one frame with copper/display setup, pops the
;   consumed brush node from the active list, then services source-state queueing.
; NOTES:
;   Mode 0 path may redraw channel banner using stored match index snapshot.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    BSR.W   ESQIFF_RunCopperDropTransition

    TST.W   D7
    BEQ.S   .check_logo_head_fallback

    TST.L   ESQIFF_GAdsBrushListHead
    BNE.S   .validate_asset_list_and_match_index

.check_logo_head_fallback:
    TST.W   D7
    BNE.W   .fallback_restore_base_palette

    TST.L   ESQIFF_LogoBrushListHead
    BEQ.W   .fallback_restore_base_palette

.validate_asset_list_and_match_index:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  DATA_WDISP_BSS_LONG_22C2,D1
    CMP.W   D1,D0
    BCC.S   .prepare_display_context_for_asset_blit

    TST.W   D7
    BNE.S   .prepare_display_context_for_asset_blit

    TST.W   DATA_WDISP_BSS_LONG_22C3
    BNE.S   .prepare_display_context_for_asset_blit

    BSR.W   ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.W   .run_rise_transition_and_service_source

.prepare_display_context_for_asset_blit:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEA.L D0,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    LEA     12(A7),A7
    TST.W   D7
    BEQ.S   .select_logo_head_for_blit

    MOVEA.L ESQIFF_GAdsBrushListHead,A0
    BRA.S   .run_asset_frame_side_effects

.select_logo_head_for_blit:
    MOVEA.L ESQIFF_LogoBrushListHead,A0

.run_asset_frame_side_effects:
    MOVE.L  A0,-6(A5)
    JSR     ESQIFF_JMPTBL_ESQ_NoOp(PC)

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .render_selected_asset_frame

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BEQ.S   .assert_ctrl_line_for_deferred_tick

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BNE.S   .render_selected_asset_frame

.assert_ctrl_line_for_deferred_tick:
    JSR     ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(PC)

.render_selected_asset_frame:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF_ShowExternalAssetWithCopperFx

    ADDQ.W  #4,A7
    TST.W   D7
    BNE.S   .pop_rendered_asset_head

    TST.W   DATA_WDISP_BSS_LONG_22C3
    BNE.S   .pop_rendered_asset_head

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   ESQIFF_SetApenToBrightestPaletteIndex

    MOVE.W  DATA_WDISP_BSS_LONG_22C2,TEXTDISP_CurrentMatchIndex
    PEA     2.W
    PEA     1.W
    JSR     ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(PC)

    ADDQ.W  #8,A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.pop_rendered_asset_head:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   D7
    BEQ.S   .pop_logo_brush_head

    SUBQ.L  #1,ESQIFF_GAdsBrushListCount
    MOVE.L  ESQIFF_GAdsBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_GAdsBrushListHead
    BRA.S   .permit_after_pop

.pop_logo_brush_head:
    SUBQ.L  #1,ESQIFF_LogoBrushListCount
    MOVE.L  ESQIFF_LogoBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_LogoBrushListHead

.permit_after_pop:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .run_rise_transition_and_service_source

.fallback_restore_base_palette:
    BSR.W   ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.run_rise_transition_and_service_source:
    MOVE.W  WDISP_AccumulatorCaptureActive,D6
    CLR.W   WDISP_AccumulatorCaptureActive
    BSR.W   ESQIFF_RunCopperRiseTransition

    MOVE.W  D6,WDISP_AccumulatorCaptureActive
    TST.W   D7
    BEQ.S   .service_source_mode_zero

    PEA     1.W
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7
    BRA.S   ESQIFF_PlayNextExternalAssetFrame_Return

.service_source_mode_zero:
    CLR.L   -(A7)
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame_Return   (Return tail for external asset frame player)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns from frame-player helper.
; NOTES:
;   Shared return for both render and fallback/no-asset paths.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_DeallocateAdsAndLogoLstData   (Free loaded external catalog blobs)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_7, Global_STR_ESQIFF_C_8
; WRITES:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE
; DESC:
;   Frees loaded `gfx/g_ads.data` and `df0:logo.lst` memory buffers when both
;   pointer and filesize are non-zero, then clears their globals.
; NOTES:
;   Passes `(size+1)` to deallocator, matching allocation strategy.
;------------------------------------------------------------------------------
ESQIFF_DeallocateAdsAndLogoLstData:
    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .deallocLogoLstData

    TST.L   Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .deallocLogoLstData

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     1988.W
    PEA     Global_STR_ESQIFF_C_7
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   Global_REF_LONG_GFX_G_ADS_FILESIZE

.deallocLogoLstData:
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .return

    TST.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .return

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     1994.W
    PEA     Global_STR_ESQIFF_C_8
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunPendingCopperAnimations   (Service all active copper animation countdown lanes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary, ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets, ESQIFF_JMPTBL_ESQ_NoOp_006A, ESQIFF_JMPTBL_ESQ_NoOp_0074
; READS:
;   DATA_COMMON_BSS_WORD_1B19, DATA_COMMON_BSS_WORD_1B1A, DATA_COMMON_BSS_WORD_1B1B, DATA_COMMON_BSS_WORD_1B1C
; WRITES:
;   DATA_COMMON_BSS_WORD_1B19, DATA_COMMON_BSS_WORD_1B1A, DATA_COMMON_BSS_WORD_1B1B, DATA_COMMON_BSS_WORD_1B1C
; DESC:
;   Services four countdown lanes in sequence, invoking the corresponding copper
;   helper while each lane is non-zero and decrementing per step.
; NOTES:
;   Loops until all lanes (`1B19..1B1C`) reach zero.
;------------------------------------------------------------------------------
ESQIFF_RunPendingCopperAnimations:
    MOVE.W  DATA_COMMON_BSS_WORD_1B19,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1a

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_006A(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B19,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B19
    BRA.S   ESQIFF_RunPendingCopperAnimations

.service_lane_1b1a:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1A,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1b

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_0074(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1A,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1A
    BRA.S   .service_lane_1b1a

.service_lane_1b1b:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1B,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1c

    JSR     ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1B,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1B
    BRA.S   .service_lane_1b1b

.service_lane_1b1c:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1C,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .return_run_pending_copper_animations

    JSR     ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1C,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1C
    BRA.S   .service_lane_1b1c

.return_run_pending_copper_animations:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_HandleBrushIniReloadHotkey   (Handle brush.ini reload hotkey and refresh brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_FindType3Brush, ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel, ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle, ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle, GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, GROUP_AU_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   BRUSH_SelectedNode, Global_STR_DF0_BRUSH_INI_2, PARSEINI_ParsedDescriptorListHead, ESQIFF_BrushIniListHead, DATA_ESQIFF_TAG_DT_1EF8, DATA_ESQIFF_TAG_DITHER_1EF9
; WRITES:
;   BRUSH_SelectedNode, DATA_ESQFUNC_BSS_LONG_1ED0
; DESC:
;   On hotkey `'a'`, refreshes brush.ini data, rebuilds brush lists, selects
;   preferred brush tags, and updates cached type-3 brush pointer.
; NOTES:
;   Calls disk refresh/reset helpers before and after parse/rebuild sequence.
;------------------------------------------------------------------------------
ESQIFF_HandleBrushIniReloadHotkey:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(PC)

    CLR.L   -(A7)
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     Global_STR_DF0_BRUSH_INI_2
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     ESQIFF_BrushIniListHead
    MOVE.L  PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     DATA_ESQIFF_TAG_DT_1EF8
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     24(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .ensure_type3_brush_cache

    PEA     ESQIFF_BrushIniListHead
    PEA     DATA_ESQIFF_TAG_DITHER_1EF9
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.ensure_type3_brush_cache:
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,DATA_ESQFUNC_BSS_LONG_1ED0
    JSR     ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment bytes
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCase   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCase:
    JMP     STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_GetFilesizeFromHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle:
    JMP     DISKIO_GetFilesizeFromHandle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_DivS32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_FindEntryIndexByWildcard
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard:
    JMP     TEXTDISP_FindEntryIndexByWildcard

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareN:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp:
    JMP     ESQ_NoOp

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_DrawChannelBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardStart
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart:
    JMP     ESQ_MoveCopperEntryTowardStart

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_DeallocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_DeallocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ForceUiRefreshIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle:
    JMP     DISKIO_ForceUiRefreshIfIdle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_CloneBrushRecord   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_CloneBrushRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_CloneBrushRecord:
    JMP     BRUSH_CloneBrushRecord

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardEnd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd:
    JMP     ESQ_MoveCopperEntryTowardEnd

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindBrushByPredicate
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FreeBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindType3Brush   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindType3Brush
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindType3Brush:
    JMP     BRUSH_FindType3Brush

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopBrushHead   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopBrushHead
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopBrushHead:
    JMP     BRUSH_PopBrushHead

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_AllocBrushNode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_006A   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_006A
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_006A:
    JMP     ESQ_NoOp_006A

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ValidateSelectionCode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode:
    JMP     NEWGRID_ValidateSelectionCode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopulateBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_0074   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_0074
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_0074:
    JMP     ESQ_NoOp_0074

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCaseN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCaseN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCaseN:
    JMP     STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_AssertCtrlLineIfEnabled
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled:
    JMP     SCRIPT_AssertCtrlLineIfEnabled

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_BeginBannerCharTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition:
    JMP     SCRIPT_BeginBannerCharTransition

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_AllocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_AllocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CTASKS_StartIffTaskProcess
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess:
    JMP     CTASKS_StartIffTaskProcess

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DOS_OpenFileWithMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DOS_OpenFileWithMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DOS_OpenFileWithMode:
    JMP     DOS_OpenFileWithMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_IncCopperListsTowardsTargets
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets:
    JMP     ESQ_IncCopperListsTowardsTargets

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_DecCopperListsPrimary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary:
    JMP     ESQ_DecCopperListsPrimary

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushSlot   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushSlot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushByLabel
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel:
    JMP     BRUSH_SelectBrushByLabel

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_Mulu32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ResetCtrlInputStateIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle:
    JMP     DISKIO_ResetCtrlInputStateIfIdle
