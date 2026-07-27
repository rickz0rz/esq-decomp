    XDEF    _ED_DrawESCMenuHelpText
    XDEF    ED_DrawEscMainMenuText



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