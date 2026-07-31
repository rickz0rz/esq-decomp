    XDEF    _ESQIFF_RenderWeatherStatusBrushSlice
    XDEF    ESQIFF_RenderWeatherStatusBrushSlice_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_RenderWeatherStatusBrushSlice   (Render one weather-status brush slice and update counters)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
; READS:
;   ESQIFF_RenderWeatherStatusBrushSlice_Return, _CONFIG_NewgridSelectionCode16EnabledFlag, _ESQFUNC_WeatherSliceWidthInitGate, _ESQIFF_WeatherSliceRemainingWidth, _ESQIFF_WeatherSliceSourceOffset, _ESQIFF_WeatherSliceValidateGateFlag
; WRITES:
;   _ESQFUNC_WeatherSliceWidthInitGate, _ESQIFF_WeatherSliceRemainingWidth, _ESQIFF_WeatherSliceSourceOffset, _ESQIFF_WeatherSliceValidateGateFlag
; DESC:
;   Initializes/continues weather-slice progress state, blits one or two brush
;   slices depending on mode byte, and updates remaining/consumed pixel counters.
; NOTES:
;   Triggers NEWGRID selection validation once when mode=11 and one-shot flag is set.
;------------------------------------------------------------------------------
_ESQIFF_RenderWeatherStatusBrushSlice:
    MOVEM.L D2/D6-D7/A2-A3,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVEA.L,2,A2

    MOVE.L  A2,D0
    BNE.S   .ensure_slice_state_initialized

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQIFF_WeatherSliceRemainingWidth
    BRA.W   ESQIFF_RenderWeatherStatusBrushSlice_Return

.ensure_slice_state_initialized:
    MOVE.W  _ESQIFF_WeatherSliceRemainingWidth,D0
    TST.W   D0
    BLE.S   .reset_slice_state

    TST.W   _ESQFUNC_WeatherSliceWidthInitGate
    BEQ.S   .clamp_slice_width

.reset_slice_state:
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQFUNC_WeatherSliceWidthInitGate
    MOVE.W  178(A2),D1
    MOVE.B  #$1,_ESQIFF_WeatherSliceValidateGateFlag
    MOVE.W  D0,_ESQIFF_WeatherSliceSourceOffset
    MOVE.W  D1,_ESQIFF_WeatherSliceRemainingWidth

.clamp_slice_width:
    MOVE.W  _ESQIFF_WeatherSliceRemainingWidth,D0
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
    MOVE.W  _ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

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
    MOVE.W  _ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

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
    MOVE.W  _ESQIFF_WeatherSliceSourceOffset,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEQ   #11,D0
    CMP.B   32(A2),D0
    BNE.S   .update_slice_progress_and_return

    MOVEQ   #1,D0
    CMP.B   _ESQIFF_WeatherSliceValidateGateFlag,D0
    BNE.S   .update_slice_progress_and_return

    MOVE.B  _CONFIG_NewgridSelectionCode16EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .update_slice_progress_and_return

    PEA     16.W
    MOVE.L  A3,-(A7)
    JSR     _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    ADDQ.W  #8,A7
    CLR.B   _ESQIFF_WeatherSliceValidateGateFlag

.update_slice_progress_and_return:
    SUB.W   D7,_ESQIFF_WeatherSliceRemainingWidth
    ADD.W   D7,_ESQIFF_WeatherSliceSourceOffset
    MOVE.L  D7,D0
    TST.W   D0
    BPL.S   .store_half_slice_width

    ADDQ.W  #1,D0

.store_half_slice_width:
    ASR.W   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.W  _ESQIFF_WeatherSliceRemainingWidth,D0

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