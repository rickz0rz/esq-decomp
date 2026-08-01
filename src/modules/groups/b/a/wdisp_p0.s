    XDEF    _WDISP_DrawWeatherStatusSummary


;------------------------------------------------------------------------------
; FUNC: _WDISP_DrawWeatherStatusSummary   (DrawWeatherStatusSummary)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _WDISP_DrawWeatherStatusDayEntry, _LVOMove, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   _Global_HANDLE_PREVUEC_FONT, _Global_REF_GRAPHICS_LIBRARY, _P_TYPE_WeatherForecastMsgPtr, _SCRIPT_PtrNoForecastWeatherData, _TLIBA1_DayEntryModeCounter, _WDISP_WeatherStatusDigitChar, return
; WRITES:
;   (none observed)
; DESC:
;   Clears the status area and draws either day-entry panels or centered
;   fallback summary text.
; NOTES:
;   Day-entry mode is enabled only when _TLIBA1_DayEntryModeCounter > 0 and the
;   weather digit char is not '0'.
;------------------------------------------------------------------------------
_WDISP_DrawWeatherStatusSummary:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  _TLIBA1_DayEntryModeCounter,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .summary_draw_fallback_text

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .summary_draw_fallback_text

    MOVEQ   #0,D4

.summary_draw_day_panels_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D4
    BGE.W   .return

    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _WDISP_DrawWeatherStatusDayEntry

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    BRA.S   .summary_draw_day_panels_loop

.summary_draw_fallback_text:
    TST.L   _P_TYPE_WeatherForecastMsgPtr
    BEQ.S   .summary_use_default_fallback_text

    MOVE.L  _P_TYPE_WeatherForecastMsgPtr,-4(A5)
    BRA.S   .summary_measure_fallback_text

.summary_use_default_fallback_text:
    MOVEA.L _SCRIPT_PtrNoForecastWeatherData,A0
    MOVE.L  A0,-4(A5)

.summary_measure_fallback_text:
    MOVEA.L -4(A5),A0

.summary_scan_fallback_len_loop:
    TST.B   (A0)+
    BNE.S   .summary_scan_fallback_len_loop

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,D5
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .summary_center_fallback_x

    ADDQ.L  #1,D1

.summary_center_fallback_x:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .summary_center_fallback_y

    ADDQ.L  #1,D2

.summary_center_fallback_y:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======