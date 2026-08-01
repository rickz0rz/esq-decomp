    XDEF    _ED_DrawAdEditingScreen



; draw ad editing screen (editing ad)
;------------------------------------------------------------------------------
; FUNC: _ED_DrawAdEditingScreen   (Draw ad editing screenuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _ED_DrawHelpPanels, _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   _ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_TextLimit, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,
;   _Global_REF_BOOL_IS_LINE_OR_PAGE, _Global_REF_BOOL_IS_TEXT_OR_CURSOR
; WRITES:
;   (none)
; DESC:
;   Draws the ad editing screen header and status indicators.
; NOTES:
;   Uses a 41-byte local printf buffer (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_DrawAdEditingScreen:
    LINK.W  A5,#-44
    MOVEM.L D2-D3,-(A7)

.printfResult   = -41

    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _Global_REF_BOOL_IS_LINE_OR_PAGE,(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVE.L  _Global_REF_BOOL_IS_TEXT_OR_CURSOR,(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   _ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     _Global_STR_EDITING_AD_NUMBER_FORMATTED_1
    PEA     .printfResult(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======