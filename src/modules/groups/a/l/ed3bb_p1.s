    XDEF    ED_DrawDiagnosticModeHelpText
    XDEF    _ED_DrawMenuSelectionHighlight
    XDEF    _ED_DrawScrollSpeedMenuText


;------------------------------------------------------------------------------
; FUNC: _ED_DrawMenuSelectionHighlight   (Draw ESC menu selection highlightuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   _ED_EditCursorOffset, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the selection highlight bar for the ESC menu.
; NOTES:
;   Uses _ED_EditCursorOffset to optionally draw the current selection marker.
;------------------------------------------------------------------------------
_ED_DrawMenuSelectionHighlight:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  16(A7),D7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #67,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CMPI.L  #$ffffffff,_ED_EditCursorOffset
    BLE.S   .after_optional_marker

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,D1
    MOVEQ   #68,D2
    ADD.L   D2,D1
    MOVEQ   #97,D2
    ADD.L   D2,D0
    MOVE.L  D0,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

.after_optional_marker:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

; Draw the ESC -> Diagnostic Mode text
;------------------------------------------------------------------------------
; FUNC: ED_DrawDiagnosticModeHelpText   (Draw diagnostic mode help textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill, _DISPLIB_DisplayTextAtPosition
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the diagnostic mode help footer.
; NOTES:
;   Writes the return/any-key prompts.
;------------------------------------------------------------------------------
ED_DrawDiagnosticModeHelpText:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #327,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_PUSH_ANY_KEY_TO_SELECT_2
    PEA     420.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; draw esc - change scroll speed menu text
;------------------------------------------------------------------------------
; FUNC: _ED_DrawScrollSpeedMenuText   (Draw scroll speed menu textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws the change-scroll-speed menu text and current speed.
; NOTES:
;   Uses an 80-byte local buffer (-80(A5)..-1(A5)); _WDISP_SPrintf has no
;   explicit destination-length parameter.
;------------------------------------------------------------------------------
_ED_DrawScrollSpeedMenuText:

.statusLine = -80

    LINK.W  A5,#-80

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0         ; '3'
    MOVE.L  D0,-(A7)
    PEA     ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .statusLine(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SPEED_ZERO_NOT_AVAILABLE
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SPEED_ONE_NOT_AVAILABLE
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_2
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7

    PEA     Global_STR_SCROLL_SPEED_3
    PEA     210.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_4
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_5
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_6
    PEA     300.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_7
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======