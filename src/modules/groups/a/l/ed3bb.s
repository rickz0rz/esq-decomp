    XDEF    ED_DrawAdNumberPrompt
    XDEF    _ED_DrawAreYouSurePrompt
    XDEF    _ED_DrawBottomHelpBarBackground
    XDEF    _ED_DrawCurrentColorIndicator
    XDEF    _ED_DrawCursorChar
    XDEF    ED_DrawDiagnosticModeHelpText
    XDEF    _ED_DrawDiagnosticModeText
    XDEF    _ED_DrawDiagnosticRegisterValues
    XDEF    _ED_DrawESCMenuHelpText
    XDEF    ED_DrawEscMainMenuText
    XDEF    _ED_DrawHelpPanels
    XDEF    _ED_DrawMenuSelectionHighlight
    XDEF    _ED_DrawScrollSpeedMenuText
    XDEF    _ED_DrawSpecialFunctionsMenu
    XDEF    ED_InitRastport2Pens
    XDEF    _ED_RedrawCursorChar
    XDEF    ED_UpdateCursorPosFromIndex
    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE
    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR


;------------------------------------------------------------------------------
; FUNC: ED_InitRastport2Pens   (Init rastport 2 pensuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A5/A6/D0
; CALLS:
;   _LVOSetDrMd, _LVOSetAPen, _LVOSetBPen
; READS:
;   _WDISP_DisplayContextBase, _ED_Rastport2PenModeSelector, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets drawing mode and pen defaults for the secondary rastport.
; NOTES:
;   Uses _ED_Rastport2PenModeSelector to select alternate pen setup.
;------------------------------------------------------------------------------
ED_InitRastport2Pens:
    LINK.W  A5,#-4
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  A0,-4(A5)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #14,D0
    CMP.L   _ED_Rastport2PenModeSelector,D0
    BNE.S   .after_alt_pens

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

.after_alt_pens:
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawBottomHelpBarBackground   (Draw bottom help bar backgrounduncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the bottom help bar background rectangle.
; NOTES:
;   Uses APen 2 for the bar and restores APen/DrMd afterward.
;------------------------------------------------------------------------------
_ED_DrawBottomHelpBarBackground:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #680,D2
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawEscMainMenuText   (Draw ESC main menu textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ED_DrawMenuSelectionHighlight, _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the main ESC menu option list.
; NOTES:
;   Calls _ED_DrawMenuSelectionHighlight to draw the selection highlight.
;------------------------------------------------------------------------------
ED_DrawEscMainMenuText:
    PEA     6.W
    BSR.W   _ED_DrawMenuSelectionHighlight

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_EDIT_ADS
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_EDIT_ATTRIBUTES
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_CHANGE_SCROLL_SPEED
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_DIAGNOSTIC_MODE
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     68(A7),A7
    PEA     Global_STR_SPECIAL_FUNCTIONS
    PEA     210.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_VERSIONS_SCREEN
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawESCMenuHelpText
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 uncertain
; CALLS:
;   _ED_DrawHelpPanels, _DISPLIB_DisplayTextAtPosition, ED_DrawEscMainMenuText,
;   _LVOSetDrMd, _LVOSetAPen
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   _ED_EditCursorOffset
; DESC:
;   Draws the ESC menu help footer and then the main menu text.
; NOTES:
;   Resets _ED_EditCursorOffset to 0 before drawing menu text.
;------------------------------------------------------------------------------
_ED_DrawESCMenuHelpText:
    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ESC_TO_RESUME
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_ANY_KEY_TO_SELECT_1
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    CLR.L   _ED_EditCursorOffset
    BSR.W   ED_DrawEscMainMenuText

    LEA     52(A7),A7
    RTS

;!======

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

;------------------------------------------------------------------------------
; FUNC: _ED_DrawHelpPanels
; ARGS:
;   stack +4: u16 penIndex uncertain
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 uncertain
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the rectangular panels behind help/menu text.
; NOTES:
;   Uses the stack argument to select the secondary pen.
;------------------------------------------------------------------------------
_ED_DrawHelpPanels:
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  16(A7),D7

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #297,D3
    JSR     _LVORectFill(A6)

    MOVE.L  D7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #298,D1
    ; D2 is still 640
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

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

;------------------------------------------------------------------------------
; FUNC: _ED_DrawSpecialFunctionsMenu
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 uncertain
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the ESC special functions menu text.
; NOTES:
;   Restores drawing mode afterward.
;------------------------------------------------------------------------------
_ED_DrawSpecialFunctionsMenu:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     _Global_STR_SAVE_ALL_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_SAVE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_LOAD_TEXT_ADS_FROM_DISK
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_REBOOT_COMPUTER
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     64(A7),A7

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawDiagnosticRegisterValues   (Draw diagnostic register valuesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_TempCopyOffset, _GCOMMAND_PresetFallbackValue0, _GCOMMAND_PresetFallbackValue1, _GCOMMAND_PresetFallbackValue2, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic register labels and formatted values.
; NOTES:
;   Formats values into _ED_EditBufferScratch before display.
;------------------------------------------------------------------------------
_ED_DrawDiagnosticRegisterValues:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_REGISTER
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  _ED_TempCopyOffset,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     240.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_R_EQUALS
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue0,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    LEA     72(A7),A7
    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     85.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_G_EQUALS
    PEA     270.W
    PEA     135.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue1,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     180.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_B_EQUALS
    PEA     270.W
    PEA     230.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue2,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     275.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawAreYouSurePrompt   (Draw "Are you sure" promptuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   _ED_DrawHelpPanels, _DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws a confirmation prompt panel.
; NOTES:
;   Uses _ED_DrawHelpPanels to render the background.
;------------------------------------------------------------------------------
_ED_DrawAreYouSurePrompt:
    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ARE_YOU_SURE
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     20(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

; enter ad number prompt
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdNumberPrompt   (Draw ad number promptuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ED_DrawHelpPanels, _DISPLIB_DisplayTextAtPosition, _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_MaxAdNumber, _Global_REF_RASTPORT_1
; WRITES:
;   _ED_EditCursorOffset, ED_AdNumberPromptStateBlock
; DESC:
;   Draws the "enter ad number" prompt and initializes the entry buffer.
; NOTES:
;   Initializes _ED_EditBufferScratch/_ED_EditBufferLive with spaces and default chars.
;------------------------------------------------------------------------------
ED_DrawAdNumberPrompt:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D7,-(A7)

    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  _ED_MaxAdNumber,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     330.W
    PEA     340.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LEFT_PARENTHESIS_THEN
    PEA     330.W
    PEA     370.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     Global_STR_SINGLE_SPACE_4
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_AD_NUMBER_QUESTIONMARK
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #12,D0
    MOVE.L  D0,_ED_EditCursorOffset
    MOVEQ   #0,D7

.init_entry_loop:
    MOVEQ   #14,D0
    CMP.L   D0,D7
    BGE.S   .init_entry_done

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D7,A0
    MOVE.B  #$20,(A0)
    LEA     _ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .init_entry_loop

.init_entry_done:
    CLR.B   ED_AdNumberPromptStateBlock
    BSR.W   _ED_RedrawCursorChar

    MOVEM.L (A7)+,D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_RedrawCursorChar   (Redraw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/D0
; CALLS:
;   _ED_DrawCursorChar, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current cursor character using a temporary draw mode.
; NOTES:
;   Sets draw mode to 5, draws, then restores draw mode to 1.
;------------------------------------------------------------------------------
_ED_RedrawCursorChar:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   _ED_DrawCursorChar

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawCursorChar   (Draw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ED_UpdateCursorPosFromIndex, ESQIFF_JMPTBL_MATH_Mulu32,
;   _LVOSetAPen, _LVOSetBPen, _LVOMove, _LVOText
; READS:
;   _ED_EditCursorOffset, ED_ViewportOffset, ED_CursorColumnIndex, _ED_EditBufferScratch, _ED_EditBufferLive, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the character at the current cursor position.
; NOTES:
;   Updates pen colors based on character mapping tables.
;------------------------------------------------------------------------------
_ED_DrawCursorChar:
    LINK.W  A5,#-4
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  _ED_EditCursorOffset,(A7)
    BSR.W   ED_UpdateCursorPosFromIndex

    ADDQ.W  #4,A7
    MOVE.L  ED_CursorColumnIndex,D0
    LSL.L   #4,D0
    SUB.L   ED_CursorColumnIndex,D0
    MOVEQ   #40,D1
    ADD.L   D1,D0
    MOVE.L  D0,0(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #90,D1
    ADD.L   D1,D0
    MOVE.L  D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  0(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateCursorPosFromIndex   (Update cursor row/col from indexuncertain)
; ARGS:
;   stack +4: u32 index
; RET:
;   (none)
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_DivS32
; READS:
;   _ED_TextLimit
; WRITES:
;   ED_CursorColumnIndex, ED_ViewportOffset, _ED_EditCursorOffset
; DESC:
;   Computes row/column indices from a linear cursor index.
; NOTES:
;   Clamps ED_ViewportOffset and _ED_EditCursorOffset to visible ranges.
;------------------------------------------------------------------------------
ED_UpdateCursorPosFromIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,ED_CursorColumnIndex
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,ED_ViewportOffset

.clamp_cursor_loop:
    MOVE.L  ED_ViewportOffset,D0
    CMP.L   _ED_TextLimit,D0
    BLT.S   .return

    SUBQ.L  #1,ED_ViewportOffset
    MOVEQ   #40,D0
    SUB.L   D0,_ED_EditCursorOffset
    BRA.S   .clamp_cursor_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_DrawCurrentColorIndicator   (Draw current color indicatoruncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +56: arg_3 (via 60(A5))
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVORectFill
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current color swatch and formatted label.
; NOTES:
;   Local color-label buffer is 41 bytes (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_DrawCurrentColorIndicator:

.colorLabel = -41

    LINK.W  A5,#-44
    MOVEM.L D2-D3/D6-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #102,D0
    ADD.L   D0,D0
    MOVEQ   #125,D1
    ADD.L   D1,D1
    MOVE.L  #474,D2
    MOVE.L  #275,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOSetBPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    PEA     _Global_STR_CURRENT_COLOR_FORMATTED
    PEA     .colorLabel(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .colorLabel(A5)
    PEA     272.W
    PEA     205.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L -60(A5),D2-D3/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR   (Draw text/cursor label)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D7
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "TEXT" or "CURSOR" label with fixed pens.
; NOTES:
;   Uses D7 as the boolean input.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .setTextToCursor

    LEA     Global_STR_TEXT,A0
    BRA.S   .drawText

.setTextToCursor:
    LEA     Global_STR_CURSOR,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     296.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE   (Draw line/page label)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   Global_REF_BOOL_IS_LINE_OR_PAGE, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "LINE" or "PAGE" label with fixed pens.
; NOTES:
;   Uses Global_REF_BOOL_IS_LINE_OR_PAGE as the selector.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE:
    LINK.W  A5,#0

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .setTextToPage

    LEA     Global_STR_LINE,A0
    BRA.S   .drawText

.setTextToPage:
    LEA     Global_STR_PAGE,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======
