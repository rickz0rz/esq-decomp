    XDEF    _WDISP_HandleWeatherStatusCommand


;------------------------------------------------------------------------------
; FUNC: _WDISP_HandleWeatherStatusCommand   (HandleWeatherStatusCommand)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _TEXTDISP_ResetSelectionAndRefresh, _TLIBA3_ClearViewModeRastPort, _TLIBA3_BuildDisplayContextForViewMode, _WDISP_DrawWeatherStatusOverlay, _WDISP_DrawWeatherStatusSummary, _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition, _WDISP_JMPTBL_BRUSH_FindBrushByPredicate, _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice, _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples, _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont
; READS:
;   _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, _ACCUMULATOR_Row0_CaptureValue, _ACCUMULATOR_Row1_CaptureValue, _ACCUMULATOR_Row2_CaptureValue, _ESQFUNC_PwBrushListHead, _ESQFUNC_STR_I5, _WDISP_DisplayContextBase, _WDISP_WeatherStatusCountdown, _WDISP_WeatherStatusBrushIndex, _WDISP_WeatherStatusDigitChar, _WDISP_AccumulatorRow0_Value, _WDISP_AccumulatorRow0_CopperIndexStart, _WDISP_AccumulatorRow0_CopperIndexEnd, _WDISP_AccumulatorRow1_Value, _WDISP_AccumulatorRow1_CopperIndexStart, _WDISP_AccumulatorRow1_CopperIndexEnd, _WDISP_AccumulatorRow2_Value, _WDISP_AccumulatorRow2_CopperIndexStart, _WDISP_AccumulatorRow2_CopperIndexEnd, _WDISP_AccumulatorRow3_Value, _WDISP_AccumulatorRow3_CopperIndexStart, _WDISP_AccumulatorRow3_CopperIndexEnd, WDISP_WeatherCycleOffsetCount
; WRITES:
;   _ACCUMULATOR_Row0_CaptureValue, _ACCUMULATOR_Row1_CaptureValue, _ACCUMULATOR_Row2_CaptureValue, _ACCUMULATOR_Row3_CaptureValue, _ACCUMULATOR_Row0_Sum, _ACCUMULATOR_Row1_Sum, _ACCUMULATOR_Row2_Sum, _ACCUMULATOR_Row3_Sum, _ACCUMULATOR_Row0_SaturateFlag, _ACCUMULATOR_Row1_SaturateFlag, _ACCUMULATOR_Row2_SaturateFlag, _ACCUMULATOR_Row3_SaturateFlag, _WDISP_DisplayContextBase, _WDISP_AccumulatorCaptureActive, WDISP_WeatherCycleOffsetCount, localRastport
; DESC:
;   Dispatches weather-status commands (notably 48 and 51), renders status
;   content, and updates accumulator capture flags.
; NOTES:
;   Command values other than 48/51 fall back to _TEXTDISP_ResetSelectionAndRefresh.
;------------------------------------------------------------------------------
_WDISP_HandleWeatherStatusCommand:
    LINK.W  A5,#-12
    MOVEM.L D2/D5-D7,-(A7)

.localRastport = -12

    MOVE.L  8(A5),D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BEQ.S   .handle_status_cmd_render_panel

    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.W   .handle_status_cmd_fallback_refresh

.handle_status_cmd_render_panel:
    CLR.L   -(A7)
    PEA     4.W
    JSR     _TLIBA3_ClearViewModeRastPort(PC)

    MOVEQ   #4,D0
    MOVE.L  D0,(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEQ   #0,D6
    MOVEA.L _WDISP_DisplayContextBase,A1
    MOVE.W  4(A1),D6
    MOVEQ   #0,D5
    MOVE.W  2(A1),D5
    MOVE.L  A0,.localRastport(A5)
    JSR     _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    JSR     _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     24(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #48,D0
    CMP.L   D0,D7
    BNE.S   .handle_status_cmd_draw_summary

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   _WDISP_DrawWeatherStatusOverlay

    LEA     12(A7),A7
    BRA.S   .handle_status_cmd_restore_context

.handle_status_cmd_draw_summary:
    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.S   .handle_status_cmd_restore_context

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   _WDISP_DrawWeatherStatusSummary

    LEA     12(A7),A7

.handle_status_cmd_restore_context:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .handle_status_cmd_clear_slot_1b0d

    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .handle_status_cmd_clear_slot_1b0d

    MOVE.W  _WDISP_AccumulatorRow0_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .handle_status_cmd_clear_slot_1b0d

    MOVE.W  D0,_ACCUMULATOR_Row0_CaptureValue
    BRA.S   .handle_status_cmd_validate_slot_1b0e

.handle_status_cmd_clear_slot_1b0d:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row0_CaptureValue

.handle_status_cmd_validate_slot_1b0e:
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .handle_status_cmd_clear_slot_1b0e

    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .handle_status_cmd_clear_slot_1b0e

    MOVE.W  _WDISP_AccumulatorRow1_Value,D2
    CMPI.W  #$4000,D2
    BGE.S   .handle_status_cmd_clear_slot_1b0e

    MOVE.W  D2,_ACCUMULATOR_Row1_CaptureValue
    BRA.S   .handle_status_cmd_validate_slot_1b0f

.handle_status_cmd_clear_slot_1b0e:
    MOVEQ   #0,D2
    MOVE.W  D2,_ACCUMULATOR_Row1_CaptureValue

.handle_status_cmd_validate_slot_1b0f:
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexStart,D0
    CMP.B   D1,D0
    BCC.S   .handle_status_cmd_clear_slot_1b0f

    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .handle_status_cmd_clear_slot_1b0f

    MOVE.W  _WDISP_AccumulatorRow2_Value,D0
    CMPI.W  #16384,D0
    BGE.S   .handle_status_cmd_clear_slot_1b0f

    MOVE.W  D0,_ACCUMULATOR_Row2_CaptureValue
    BRA.S   .handle_status_cmd_validate_slot_1b10

.handle_status_cmd_clear_slot_1b0f:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row2_CaptureValue

.handle_status_cmd_validate_slot_1b10:
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .handle_status_cmd_clear_slot_1b10

    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .handle_status_cmd_clear_slot_1b10

    MOVE.W  _WDISP_AccumulatorRow3_Value,D1
    CMPI.W  #16384,D1
    BGE.S   .handle_status_cmd_clear_slot_1b10

    MOVE.W  D1,_ACCUMULATOR_Row3_CaptureValue
    BRA.S   .handle_status_cmd_apply_capture_flag

.handle_status_cmd_clear_slot_1b10:
    MOVEQ   #0,D1
    MOVE.W  D1,_ACCUMULATOR_Row3_CaptureValue

.handle_status_cmd_apply_capture_flag:
    TST.W   _ACCUMULATOR_Row0_CaptureValue
    BNE.S   .handle_status_cmd_enable_capture

    TST.W   _ACCUMULATOR_Row1_CaptureValue
    BNE.S   .handle_status_cmd_enable_capture

    TST.W   _ACCUMULATOR_Row2_CaptureValue
    BNE.S   .handle_status_cmd_enable_capture

    TST.W   D1
    BEQ.S   .handle_status_cmd_disable_capture

.handle_status_cmd_enable_capture:
    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    BRA.S   .handle_status_cmd_finalize_state

.handle_status_cmd_disable_capture:
    MOVEQ   #0,D0
    MOVE.W  D0,_WDISP_AccumulatorCaptureActive

.handle_status_cmd_finalize_state:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row0_Sum
    MOVE.W  D0,_ACCUMULATOR_Row0_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row1_Sum
    MOVE.W  D0,_ACCUMULATOR_Row1_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row2_Sum
    MOVE.W  D0,_ACCUMULATOR_Row2_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row3_Sum
    MOVE.W  D0,_ACCUMULATOR_Row3_SaturateFlag
    JSR     _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

    BRA.S   .handle_status_cmd_return

.handle_status_cmd_fallback_refresh:
    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

.handle_status_cmd_return:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======