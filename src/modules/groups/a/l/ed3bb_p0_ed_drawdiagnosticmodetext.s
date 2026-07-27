    XDEF    _ED_DrawDiagnosticModeText


;------------------------------------------------------------------------------
; FUNC: _ED_DrawDiagnosticModeText
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D1/A0-A1/A6 uncertain
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, _DISPLIB_DisplayTextAtPosition
; READS:
;   _Global_REF_RASTPORT_1, _ED_DiagTextModeChar, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _ED_DiagScrollSpeedChar,
;   _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic mode labels and data fields.
; NOTES:
;   Uses multiple short text fields for runtime values.
;------------------------------------------------------------------------------
_ED_DrawDiagnosticModeText:
    MOVEA.L _Global_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     _Global_STR_VIN_BCK_FWD_SSPD_AD_LINE
    PEA     300.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_TZ_DST_CONT_TXT_GRPH
    PEA     330.W
    PEA     90.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #100,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ED_DiagVinModeChar,A0
    MOVEQ   #(ED_DiagVinModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #95,D0
    ADD.L   D0,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_STR_B,A0
    MOVEQ   #(ESQ_STR_B_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #280,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_STR_E,A0
    MOVEQ   #(ESQ_STR_E_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #385,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,A0
    MOVEQ   #(ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #475,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_TAG_36,A0
    MOVEQ   #(ESQ_TAG_36_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #595,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ED_DiagScrollSpeedChar,A0
    MOVEQ   #(ED_DiagScrollSpeedChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #75,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_STR_6,A0
    MOVEQ   #(ESQ_STR_6_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #120,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_SecondarySlotModeFlagChar,A0
    MOVEQ   #(ESQ_SecondarySlotModeFlagChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #345,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ESQ_STR_Y,A0
    MOVEQ   #(ESQ_STR_Y_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #450,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ED_DiagTextModeChar,A0
    MOVEQ   #(ED_DiagTextModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #555,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _ED_DiagGraphModeChar,A0
    MOVEQ   #(ED_DiagGraphModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    RTS

;!======