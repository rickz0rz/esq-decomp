    XDEF    _ED_DrawEditHelpText


;------------------------------------------------------------------------------
; FUNC: _ED_DrawEditHelpText   (Draw edit help textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _ED_DrawBottomHelpBarBackground, _DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the help text for editing operations.
; NOTES:
;   Uses a fixed list of help strings.
;------------------------------------------------------------------------------
_ED_DrawEditHelpText:
    MOVEM.L D2-D3,-(A7)

    BSR.W   _ED_DrawBottomHelpBarBackground

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #$280,D2
    MOVE.L  #$165,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #$166,D1
    MOVE.L  #$1ad,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY
    PEA     210.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE
    PEA     300.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
