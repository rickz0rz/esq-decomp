    XDEF    _WDISP_TickWeatherCycleOffset
    XDEF    _WDISP_RenderWeatherStatusBrushSliceForIndex



    ; Dead code.
_WDISP_TickWeatherCycleOffset:
    MOVEM.L D2-D3,-(A7)

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .return

    MOVE.B  _WDISP_WeatherStatusCountdown,D2
    TST.B   D2
    BEQ.S   .return

    MOVE.W  _WDISP_WeatherCycleOffsetCount,D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,_WDISP_WeatherCycleOffsetCount
    BGT.S   .return

    SUBI.W  #$30,D0
    MOVE.W  D0,_WDISP_WeatherCycleOffsetCount

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Dead code.
_WDISP_RenderWeatherStatusBrushSliceForIndex:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    SUBQ.B  #1,D0
    BEQ.S   .dead_slice_no_valid_brush

    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    MOVEQ   #6,D1
    CMP.B   D1,D0
    BLS.S   .dead_slice_lookup_and_render

.dead_slice_no_valid_brush:
    MOVEQ   #0,D0
    BRA.S   .dead_slice_return

.dead_slice_lookup_and_render:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor (_ESQFUNC_STR_I5 -> ptr table).
    LEA     _ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     _WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-6(A5)
    JSR     _WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0

.dead_slice_return:
    MOVEM.L -16(A5),D7/A3
    UNLK    A5
    RTS

;!======