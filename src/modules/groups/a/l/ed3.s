;------------------------------------------------------------------------------
; FUNC: ED_GetEscMenuActionCode   (Get ESC menu action code??)
; ARGS:
;   (none)
; RET:
;   D0: action code ??
; CLOBBERS:
;   D0-D1/A0 ??
; CALLS:
;   (none)
; READS:
;   LAB_21ED, LAB_21E8, LAB_21FA, LAB_231C, LAB_231D
; WRITES:
;   LAB_21FA
; DESC:
;   Decodes the current ESC-menu key/selection into an action code.
; NOTES:
;   Uses a small switch table when LAB_21ED matches the menu-mode case.
;------------------------------------------------------------------------------
ED_GetEscMenuActionCode:
LAB_07D4:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),LAB_21FA
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #3,D0
    BEQ.S   .case_return_8

    SUBI.W  #10,D0
    BEQ.S   .case_index_dispatch

    SUBI.W  #14,D0
    BEQ.S   .case_return_zero

    SUBI.W  #$80,D0
    BEQ.S   .case_check_alpha

    BRA.S   .case_default_10

.case_return_zero:
    MOVEQ   #0,D0
    BRA.S   .return

.case_index_dispatch:
    MOVE.L  LAB_21E8,D0
    CMPI.L  #$6,D0
    BCC.S   .case_return_8

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; Another jump table for switch
.dispatch_table:
    DC.W    .select_code1-.dispatch_table-2
    DC.W    .select_code2-.dispatch_table-2
	DC.W    .select_code3-.dispatch_table-2
    DC.W    .select_code4-.dispatch_table-2
	DC.W    .select_code5-.dispatch_table-2
    DC.W    .select_code6-.dispatch_table-2

.select_code1:
    MOVEQ   #1,D0
    BRA.S   .return

.select_code2:
    MOVEQ   #2,D0
    BRA.S   .return

.select_code3:
    MOVEQ   #3,D0
    BRA.S   .return

.select_code4:
    MOVEQ   #4,D0
    BRA.S   .return

.select_code5:
    MOVEQ   #5,D0
    BRA.S   .return

.select_code6:
    MOVEQ   #6,D0
    BRA.S   .return

.case_return_8:
    MOVEQ   #8,D0
    BRA.S   .return

.case_check_alpha:
    MOVE.B  LAB_21FA,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.S   .case_default_10

    MOVEQ   #9,D0
    BRA.S   .return

.case_default_10:
    MOVEQ   #10,D0

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_IsConfirmKey   (Check for confirm key??)
; ARGS:
;   (none)
; RET:
;   D0: 0 if confirm key, 1 otherwise ??
; CLOBBERS:
;   D0/D7 ??
; CALLS:
;   (none)
; READS:
;   LAB_21ED
; WRITES:
;   (none)
; DESC:
;   Returns a flag based on the current key code in LAB_21ED.
; NOTES:
;   Treats key codes $59 and $20 as confirm keys.
;------------------------------------------------------------------------------
ED_IsConfirmKey:
LAB_07DD:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #$59,D0
    BEQ.S   .case_confirm

    SUBI.W  #$20,D0
    BNE.S   .case_other

.case_confirm:
    MOVEQ   #0,D7
    BRA.S   .return

.case_other:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DRAW_BOTTOM_HELP_FOR_ESC_MENU   (Draw ESC menu bottom help??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 ??
; CALLS:
;   ED_DrawBottomHelpBarBackground, DRAW_BOTTOM_HELP_TEXT_FOR_ESC_MENU
; READS:
;   (none)
; WRITES:
;   LAB_1D13
; DESC:
;   Draws the bottom help panel for the ESC menu.
; NOTES:
;   Sets LAB_1D13 to 1 before drawing.
;------------------------------------------------------------------------------
DRAW_BOTTOM_HELP_FOR_ESC_MENU:
    MOVE.B  #$1,LAB_1D13
    BSR.W   ED_DrawBottomHelpBarBackground

    ; this might actually end up drawing all the text.
    BSR.W   DRAW_BOTTOM_HELP_TEXT_FOR_ESC_MENU

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_InitRastport2Pens   (Init rastport 2 pens??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A0-A1/A6 ??
; CALLS:
;   _LVOSetDrMd, _LVOSetAPen, _LVOSetBPen
; READS:
;   LAB_2216, LAB_226E, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets drawing mode and pen defaults for the secondary rastport.
; NOTES:
;   Uses LAB_226E to select alternate pen setup.
;------------------------------------------------------------------------------
ED_InitRastport2Pens:
LAB_07E2:
    LINK.W  A5,#-4
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  A0,-4(A5)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #14,D0
    CMP.L   LAB_226E,D0
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
; FUNC: ED_DrawBottomHelpBarBackground   (Draw bottom help bar background??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/A1/A6 ??
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the bottom help bar background rectangle.
; NOTES:
;   Uses APen 2 for the bar and restores APen/DrMd afterward.
;------------------------------------------------------------------------------
ED_DrawBottomHelpBarBackground:
LAB_07E4:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #680,D2
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawEscMainMenuText   (Draw ESC main menu text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D7/A1/A6 ??
; CALLS:
;   ED_DrawMenuSelectionHighlight, DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the main ESC menu option list.
; NOTES:
;   Calls ED_DrawMenuSelectionHighlight to draw the selection highlight.
;------------------------------------------------------------------------------
ED_DrawEscMainMenuText:
LAB_07E5:
    PEA     6.W
    BSR.W   ED_DrawMenuSelectionHighlight

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_EDIT_ADS
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_EDIT_ATTRIBUTES
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_CHANGE_SCROLL_SPEED
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_DIAGNOSTIC_MODE
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     68(A7),A7
    PEA     GLOB_STR_SPECIAL_FUNCTIONS
    PEA     210.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_VERSIONS_SCREEN
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DRAW_BOTTOM_HELP_TEXT_FOR_ESC_MENU   (Draw ESC menu help text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 ??
; CALLS:
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition, ED_DrawEscMainMenuText,
;   _LVOSetDrMd, _LVOSetAPen
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_21E8
; DESC:
;   Draws the ESC menu help footer and then the main menu text.
; NOTES:
;   Resets LAB_21E8 to 0 before drawing menu text.
;------------------------------------------------------------------------------
DRAW_BOTTOM_HELP_TEXT_FOR_ESC_MENU:
    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_ESC_TO_RESUME
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_1
    PEA     360.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PUSH_ANY_KEY_TO_SELECT_1
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    CLR.L   LAB_21E8
    BSR.W   ED_DrawEscMainMenuText

    LEA     52(A7),A7
    RTS

;!======

; Draw the debug strings used in diagnostic mode
;------------------------------------------------------------------------------
; FUNC: DRAW_DIAGNOSTIC_MODE_TEXT   (Draw diagnostic mode text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D1/A0-A1/A6 ??
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, DISPLIB_DisplayTextAtPosition
; READS:
;   GLOB_REF_RASTPORT_1, LAB_1BC4, LAB_1DD6, LAB_1DD7, LAB_1DCD,
;   GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic mode labels and data fields.
; NOTES:
;   Uses multiple short text fields for runtime values.
;------------------------------------------------------------------------------
DRAW_DIAGNOSTIC_MODE_TEXT:
    MOVEA.L GLOB_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_VIN_BCK_FWD_SSPD_AD_LINE
    PEA     300.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_TZ_DST_CONT_TXT_GRPH
    PEA     330.W
    PEA     90.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #100,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DD7,A0
    MOVEQ   #(LAB_1DC7_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #95,D0
    ADD.L   D0,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DC8,A0
    MOVEQ   #(LAB_1DC8_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #280,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DC9,A0
    MOVEQ   #(LAB_1DC9_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #385,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,A0
    MOVEQ   #(GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #475,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DCB,A0
    MOVEQ   #(LAB_1DCB_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #595,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DCD,A0
    MOVEQ   #(LAB_1DCD_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #75,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DD1,A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #120,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DD2,A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #345,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DD3,A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #450,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1BC4,A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #555,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1DD6,A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    RTS

;!======

; Rename this when i know what it actually is drawing
;------------------------------------------------------------------------------
; FUNC: ED_DrawHelpPanels   (Draw help panel rectangles??)
; ARGS:
;   stack +4: u16 penIndex ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 ??
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the rectangular panels behind help/menu text.
; NOTES:
;   Uses the stack argument to select the secondary pen.
;------------------------------------------------------------------------------
ED_DrawHelpPanels:
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  16(A7),D7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #297,D3
    JSR     _LVORectFill(A6)

    MOVE.L  D7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #298,D1
    ; D2 is still 640
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawMenuSelectionHighlight   (Draw ESC menu selection highlight??)
; ARGS:
;   stack +4: u16 selectionIndex ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 ??
; CALLS:
;   GROUPB_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   LAB_21E8, GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the selection highlight bar for the ESC menu.
; NOTES:
;   Uses LAB_21E8 to optionally draw the current selection marker.
;------------------------------------------------------------------------------
ED_DrawMenuSelectionHighlight:
LAB_07E9:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  16(A7),D7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #67,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CMPI.L  #$ffffffff,LAB_21E8
    BLE.S   .after_optional_marker

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  LAB_21E8,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,D1
    MOVEQ   #68,D2
    ADD.L   D2,D1
    MOVEQ   #97,D2
    ADD.L   D2,D0
    MOVE.L  D0,D3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

.after_optional_marker:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

; Draw the ESC -> Diagnostic Mode text
;------------------------------------------------------------------------------
; FUNC: ED_DrawDiagnosticModeHelpText   (Draw diagnostic mode help text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/A1/A6 ??
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill, DISPLIB_DisplayTextAtPosition
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the diagnostic mode help footer.
; NOTES:
;   Writes the return/any-key prompts.
;------------------------------------------------------------------------------
ED_DrawDiagnosticModeHelpText:
; Draw the ESC -> Diagnostic Mode text
LAB_07EB:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #327,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_3
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PUSH_ANY_KEY_TO_SELECT_2
    PEA     420.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; draw esc - change scroll speed menu text
;------------------------------------------------------------------------------
; FUNC: ED_DrawScrollSpeedMenuText   (Draw scroll speed menu text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A1/A6 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws the change-scroll-speed menu text and current speed.
; NOTES:
;   Uses a stack buffer for formatted output.
;------------------------------------------------------------------------------
ED_DrawScrollSpeedMenuText:
; draw esc - change scroll speed menu text
LAB_07EC:
    LINK.W  A5,#-80

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.B  GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0         ; '3'
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C
    PEA     -80(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -80(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SPEED_ZERO_NOT_AVAILABLE
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SPEED_ONE_NOT_AVAILABLE
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SCROLL_SPEED_2
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7

    PEA     GLOB_STR_SCROLL_SPEED_3
    PEA     210.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SCROLL_SPEED_4
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SCROLL_SPEED_5
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SCROLL_SPEED_6
    PEA     300.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SCROLL_SPEED_7
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT   (Draw special functions menu??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the ESC special functions menu text.
; NOTES:
;   Restores drawing mode afterward.
;------------------------------------------------------------------------------
DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_SAVE_ALL_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SAVE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_LOAD_TEXT_ADS_FROM_DISK
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_REBOOT_COMPUTER
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     64(A7),A7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawDiagnosticRegisterValues   (Draw diagnostic register values??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A6 ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition, GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   LAB_21EE, LAB_1DE0, LAB_1DE1, LAB_1DE2, GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic register labels and formatted values.
; NOTES:
;   Formats values into LAB_21F0 before display.
;------------------------------------------------------------------------------
ED_DrawDiagnosticRegisterValues:
LAB_07EE:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_REGISTER
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  LAB_21EE,-(A7)
    PEA     LAB_21F0
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     LAB_21F0
    PEA     240.W
    PEA     190.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_R_EQUALS
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE0,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     LAB_21F0
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    LEA     72(A7),A7
    PEA     LAB_21F0
    PEA     270.W
    PEA     85.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_G_EQUALS
    PEA     270.W
    PEA     135.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE1,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     LAB_21F0
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     LAB_21F0
    PEA     270.W
    PEA     180.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_B_EQUALS
    PEA     270.W
    PEA     230.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE2,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     LAB_21F0
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     LAB_21F0
    PEA     270.W
    PEA     275.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawAreYouSurePrompt   (Draw "Are you sure" prompt??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 ??
; CALLS:
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws a confirmation prompt panel.
; NOTES:
;   Uses ED_DrawHelpPanels to render the background.
;------------------------------------------------------------------------------
ED_DrawAreYouSurePrompt:
LAB_07EF:
    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_ARE_YOU_SURE
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     20(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

; enter ad number prompt
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdNumberPrompt   (Draw ad number prompt??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A0-A1/A6 ??
; CALLS:
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition, GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   LAB_21FD, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_21E8, LAB_21F4
; DESC:
;   Draws the "enter ad number" prompt and initializes the entry buffer.
; NOTES:
;   Initializes LAB_21F0/LAB_21F7 with spaces and default chars.
;------------------------------------------------------------------------------
ED_DrawAdNumberPrompt:
; enter ad number prompt
LAB_07F0:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D7,-(A7)

    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_ENTER_AD_NUMBER_ONE_HYPHEN
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  LAB_21FD,-(A7)
    PEA     LAB_21F0
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     LAB_21F0
    PEA     330.W
    PEA     340.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_LEFT_PARENTHESIS_THEN
    PEA     330.W
    PEA     370.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_2
    PEA     360.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     GLOB_STR_SINGLE_SPACE_4
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_AD_NUMBER_QUESTIONMARK
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #12,D0
    MOVE.L  D0,LAB_21E8
    MOVEQ   #0,D7

.init_entry_loop:
    MOVEQ   #14,D0
    CMP.L   D0,D7
    BGE.S   .init_entry_done

    LEA     LAB_21F0,A0
    ADDA.L  D7,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
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
    CLR.B   LAB_21F4
    BSR.W   ED_RedrawCursorChar

    MOVEM.L (A7)+,D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawCursorChar   (Redraw cursor character??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 ??
; CALLS:
;   ED_DrawCursorChar, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current cursor character using a temporary draw mode.
; NOTES:
;   Sets draw mode to 5, draws, then restores draw mode to 1.
;------------------------------------------------------------------------------
ED_RedrawCursorChar:
LAB_07F3:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   ED_DrawCursorChar

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawCursorChar   (Draw cursor character??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A6 ??
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_GetLowNibble, GROUP_AL_JMPTBL_LADFUNC_GetHighNibble, ED_UpdateCursorPosFromIndex, GROUPB_JMPTBL_MATH_Mulu32,
;   _LVOSetAPen, _LVOSetBPen, _LVOMove, _LVOText
; READS:
;   LAB_21E8, LAB_21E9, LAB_2200, LAB_21F0, LAB_21F7, GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the character at the current cursor position.
; NOTES:
;   Updates pen colors based on character mapping tables.
;------------------------------------------------------------------------------
ED_DrawCursorChar:
LAB_07F4:
    LINK.W  A5,#-4
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  LAB_21E8,(A7)
    BSR.W   ED_UpdateCursorPosFromIndex

    ADDQ.W  #4,A7
    MOVE.L  LAB_2200,D0
    LSL.L   #4,D0
    SUB.L   LAB_2200,D0
    MOVEQ   #40,D1
    ADD.L   D1,D0
    MOVE.L  D0,0(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #90,D1
    ADD.L   D1,D0
    MOVE.L  D0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  0(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateCursorPosFromIndex   (Update cursor row/col from index??)
; ARGS:
;   stack +4: u32 index
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/D7 ??
; CALLS:
;   GROUPB_JMPTBL_MATH_DivS32
; READS:
;   LAB_21FB
; WRITES:
;   LAB_2200, LAB_21E9, LAB_21E8
; DESC:
;   Computes row/column indices from a linear cursor index.
; NOTES:
;   Clamps LAB_21E9 and LAB_21E8 to visible ranges.
;------------------------------------------------------------------------------
ED_UpdateCursorPosFromIndex:
LAB_07F5:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,LAB_2200
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,LAB_21E9

.clamp_cursor_loop:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BLT.S   .return

    SUBQ.L  #1,LAB_21E9
    MOVEQ   #40,D0
    SUB.L   D0,LAB_21E8
    BRA.S   .clamp_cursor_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawCurrentColorIndicator   (Draw current color indicator??)
; ARGS:
;   stack +4: u8 colorCode ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D6-D7/A1/A6 ??
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_GetHighNibble, GROUP_AL_JMPTBL_LADFUNC_GetLowNibble, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVORectFill
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current color swatch and formatted label.
; NOTES:
;   Uses a stack buffer for formatted output.
;------------------------------------------------------------------------------
ED_DrawCurrentColorIndicator:
LAB_07F8:
    LINK.W  A5,#-44
    MOVEM.L D2-D3/D6-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetHighNibble(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
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
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOSetBPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    PEA     GLOB_STR_CURRENT_COLOR_FORMATTED
    PEA     -41(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -41(A5)
    PEA     272.W
    PEA     205.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L -60(A5),D2-D3/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR   (Draw text/cursor label)
; ARGS:
;   stack +4: u32 isTextFlag ??
; RET:
;   (none)
; CLOBBERS:
;   D0/D7/A0-A1/A6 ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   GLOB_REF_RASTPORT_1
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
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .setTextToCursor

    LEA     GLOB_STR_TEXT,A0
    BRA.S   .drawText

.setTextToCursor:
    LEA     GLOB_STR_CURSOR,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     296.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
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
;   D0/A0-A1/A6 ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   GLOB_REF_BOOL_IS_LINE_OR_PAGE, GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "LINE" or "PAGE" label with fixed pens.
; NOTES:
;   Uses GLOB_REF_BOOL_IS_LINE_OR_PAGE as the selector.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE:
    LINK.W  A5,#0

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0

    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .setTextToPage

    LEA     GLOB_STR_LINE,A0
    BRA.S   .drawText

.setTextToPage:
    LEA     GLOB_STR_PAGE,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_IncrementAdNumber   (Increment current ad number??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 ??
; CALLS:
;   ED_ApplyActiveFlagToAdData, ED_UpdateAdNumberDisplay
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_21FD
; WRITES:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Increments the current ad number if within bounds and refreshes display.
; NOTES:
;   Calls ED_ApplyActiveFlagToAdData before increment to commit current state.
;------------------------------------------------------------------------------
ED_IncrementAdNumber:
LAB_07FF:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   LAB_21FD,D0
    BGE.S   .return

    BSR.W   ED_ApplyActiveFlagToAdData

    ADDQ.L  #1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_UpdateAdNumberDisplay

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DecrementAdNumber   (Decrement current ad number??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 ??
; CALLS:
;   ED_ApplyActiveFlagToAdData, ED_UpdateAdNumberDisplay
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Decrements the current ad number if above 1 and refreshes display.
; NOTES:
;   Calls ED_ApplyActiveFlagToAdData before decrement to commit current state.
;------------------------------------------------------------------------------
ED_DecrementAdNumber:
LAB_0801:
    CMPI.L  #1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.W   ED_ApplyActiveFlagToAdData

    SUBQ.L  #1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_UpdateAdNumberDisplay

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateAdNumberDisplay   (Update ad number display??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A6 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ED_UpdateActiveInactiveIndicator
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_2250
; WRITES:
;   LAB_21EA, LAB_21E9, LAB_21FE, LAB_2202, LAB_2201, LAB_21FF
; DESC:
;   Displays the current ad number and resets editing state for the ad.
; NOTES:
;   Initializes LAB_21EA based on the ad's active flag.
;------------------------------------------------------------------------------
ED_UpdateAdNumberDisplay:
LAB_0803:
    LINK.W  A5,#-40

    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,-(A7)
    PEA     GLOB_STR_AD_NUMBER_FORMATTED
    PEA     -40(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -40(A5)
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21EA
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D1
    ASL.L   #2,D1
    LEA     LAB_2250,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.W  (A1),D1
    TST.W   D1
    BLE.S   .after_active_check

    MOVEQ   #1,D1
    MOVE.L  D1,LAB_21EA

.after_active_check:
    MOVEQ   #1,D1
    MOVE.L  D1,LAB_21FE
    MOVE.L  D0,LAB_21E9
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_2202
    MOVE.L  D0,LAB_2201
    MOVE.L  D0,LAB_21FF
    BSR.W   ED_UpdateActiveInactiveIndicator

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_ApplyActiveFlagToAdData   (Apply active flag to ad data??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2/A0-A2 ??
; CALLS:
;   (none)
; READS:
;   LAB_21EA, GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_2250
; WRITES:
;   Ad data (first word / word+2) via LAB_2250
; DESC:
;   Writes the active/inactive flag for the current ad into its data record.
; NOTES:
;   Clears both words when inactive; sets word0=1 and word2=$30 when active.
;------------------------------------------------------------------------------
ED_ApplyActiveFlagToAdData:
LAB_0805:
    MOVEM.L D2/A2,-(A7)

    TST.L   LAB_21EA
    BNE.S   .set_active

    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    MOVE.L  D0,D1
    ASL.L   #2,D1
    LEA     LAB_2250,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVEQ   #0,D2
    MOVE.W  D2,(A2)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVE.W  D2,2(A2)
    BRA.S   .return

.set_active:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    ASL.L   #2,D0
    LEA     LAB_2250,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.W  #1,(A2)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.W  #$30,2(A1)

.return:
    MOVEM.L (A7)+,D2/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawAllRows   (Redraw all rows??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 ??
; CALLS:
;   ED_DrawCursorChar, GROUP_AL_JMPTBL_LADFUNC_GetHighNibble, GROUPB_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   LAB_21E8, LAB_21EB, LAB_21FB, LAB_21F7
; WRITES:
;   LAB_21E8
; DESC:
;   Redraws all rows using the current buffer contents.
; NOTES:
;   Restores LAB_21E8 to its original value after redraw.
;------------------------------------------------------------------------------
ED_RedrawAllRows:
LAB_0808:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  LAB_21E8,D7
    MOVEQ   #0,D0
    MOVE.B  LAB_21F7,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetHighNibble(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  LAB_21FB,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #68,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CLR.L   LAB_21E8

.redraw_loop:
    MOVE.L  LAB_21E8,D0
    CMP.L   LAB_21EB,D0
    BGE.S   .return

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,LAB_21E8
    BRA.S   .redraw_loop

.return:
    MOVE.L  D7,LAB_21E8
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawRow   (Redraw a row??)
; ARGS:
;   stack +4: u32 rowIndex
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/D6-D7/A1/A6 ??
; CALLS:
;   ED_DrawCursorChar, GROUPB_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen
; READS:
;   LAB_21E8, LAB_21EB, LAB_21FB
; WRITES:
;   LAB_21E8
; DESC:
;   Redraws a single row of text based on the given row index.
; NOTES:
;   Temporarily updates LAB_21E8 to walk the row range.
;------------------------------------------------------------------------------
ED_RedrawRow:
LAB_080B:
    MOVEM.L D6-D7,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  LAB_21E8,D6
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8

.row_loop:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .row_done

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,LAB_21E8
    BRA.S   .row_loop

.row_done:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D6,LAB_21E8
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateActiveInactiveIndicator   (Update active/inactive indicator??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A1/A6 ??
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd, DISPLIB_DisplayTextAtPosition
; READS:
;   LAB_21EA, LAB_2201, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_2201
; DESC:
;   Updates the active/inactive indicator when the flag changes.
; NOTES:
;   Draws two rectangles and the ACTIVE/INACTIVE label.
;------------------------------------------------------------------------------
ED_UpdateActiveInactiveIndicator:
LAB_080E:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  LAB_21EA,D0
    MOVE.L  LAB_2201,D1
    CMP.L   D0,D1
    BEQ.W   .after_indicator_update

    SUBQ.L  #1,D0
    BNE.S   .select_inactive

    MOVEQ   #110,D7
    NOT.B   D7
    MOVE.L  #265,D6
    MOVEQ   #40,D5
    MOVEQ   #65,D4
    ADD.L   D4,D4
    BRA.S   .draw_indicator

.select_inactive:
    MOVEQ   #40,D7
    MOVEQ   #65,D6
    ADD.L   D6,D6
    MOVEQ   #110,D5
    NOT.B   D5
    MOVE.L  #265,D4

.draw_indicator:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D2
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D5,D0
    MOVE.L  D4,D2
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_ACTIVE_INACTIVE
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.L  LAB_21EA,LAB_2201

.after_indicator_update:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D7
    RTS

;!======

; draw ad editing screen (editing ad)
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdEditingScreen   (Draw ad editing screen??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/A0-A1/A6 ??
; CALLS:
;   ED_DrawHelpPanels, SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   GROUPB_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   LAB_21FB, GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,
;   GLOB_REF_BOOL_IS_LINE_OR_PAGE, GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
; WRITES:
;   (none)
; DESC:
;   Draws the ad editing screen header and status indicators.
; NOTES:
;   Uses a stack buffer for formatted output.
;------------------------------------------------------------------------------
ED_DrawAdEditingScreen:
; draw ad editing screen (editing ad)
LAB_0812:
    LINK.W  A5,#-44
    MOVEM.L D2-D3,-(A7)

.printfResult   = -41

    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS
    PEA     360.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_LINE_MODE_ON_TEXT_COLOR_MODE
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  GLOB_REF_BOOL_IS_LINE_OR_PAGE,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVE.L  GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   LAB_21FB,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     GLOB_STR_EDITING_AD_NUMBER_FORMATTED_1
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_TransformLineSpacing_Mode1   (Transform line spacing mode 1??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2/D6-D7/A0-A1 ??
; CALLS:
;   GROUPB_JMPTBL_MATH_Mulu32, LAB_09C1
; READS:
;   LAB_21E8, LAB_21E9
; WRITES:
;   LAB_21F0, LAB_21F7, LAB_21F5, LAB_21F9 ??
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 1).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode1:
LAB_0813:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     LAB_09C1(PC)

    LEA     12(A7),A7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    LEA     -90(A5),A1

.copy_line_chars:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_line_chars

    MOVEQ   #0,D7

.scan_leading_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.S   .after_leading_spaces

    MOVEQ   #32,D0
    CMP.B   -49(A5,D7.L),D0
    BNE.S   .after_leading_spaces

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_leading_spaces

.after_leading_spaces:
    MOVEQ   #0,D6

.scan_trailing_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D6
    BGE.S   .after_space_scan

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_space_scan

    SUB.L   D6,D0
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_space_scan:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  LAB_21E9,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    LEA     -49(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_prefix_check

.copy_prefix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    LEA     -90(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_attrs_check

.copy_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     LAB_21F5,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix_check

.copy_suffix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     LAB_21F9,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_tail_check

.copy_tail_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_TransformLineSpacing_Mode2   (Transform line spacing mode 2??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2/D6-D7/A0-A1 ??
; CALLS:
;   GROUPB_JMPTBL_MATH_Mulu32, LAB_09C1
; READS:
;   LAB_21E8, LAB_21E9
; WRITES:
;   LAB_21F0, LAB_21F7 ??
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 2).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode2:
LAB_0822:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     LAB_09C1(PC)

    LEA     12(A7),A7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    LEA     -90(A5),A1

.copy_line_chars:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_line_chars
    MOVEQ   #0,D7

.scan_right_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.S   .after_right_spaces

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D7,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_right_spaces

    SUB.L   D7,D0
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_right_spaces

.after_right_spaces:
    MOVEQ   #0,D6

.scan_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D6
    BGE.S   .after_left_spaces

    MOVEQ   #32,D0
    CMP.B   -49(A5,D6.L),D0
    BNE.S   .after_left_spaces

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_left_spaces

.after_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  LAB_21E9,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_line_check

.copy_line_loop:
    MOVE.B  (A1)+,(A0)+

.copy_line_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_line_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_attrs_check

.copy_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_line_check

.copy_tail_line_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_line_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_line_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_attrs_check

.copy_tail_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_attrs_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_TransformLineSpacing_Mode3   (Transform line spacing mode 3??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2/D6-D7/A0-A1 ??
; CALLS:
;   GROUPB_JMPTBL_MATH_Mulu32, LAB_09C1
; READS:
;   LAB_21E8, LAB_21E9
; WRITES:
;   LAB_21F0, LAB_21F7, LAB_21F5, LAB_21F9 ??
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 3).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode3:
LAB_0831:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     LAB_09C1(PC)

    LEA     12(A7),A7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    LEA     -90(A5),A1

.copy_line_chars:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_line_chars

    MOVEQ   #0,D7

.scan_leading_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.S   .after_leading_spaces

    MOVEQ   #32,D0
    CMP.B   -49(A5,D7.L),D0
    BNE.S   .after_leading_spaces

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_leading_spaces

.after_leading_spaces:
    MOVEQ   #0,D6

.scan_trailing_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D6
    BGE.S   .after_trailing_spaces

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_trailing_spaces

    SUB.L   D6,D0
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_trailing_spaces:
    MOVE.L  D6,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D7
    BGE.W   .case_swap_spacing

    MOVE.L  D6,D0
    SUB.L   D7,D0
    TST.L   D0
    BPL.S   .compute_half_gap

    ADDQ.L  #1,D0

.compute_half_gap:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_prefix_check

.copy_prefix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_attrs_check

.copy_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_suffix_check

.copy_suffix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_check

.copy_tail_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_loop

    BRA.W   .return

.case_swap_spacing:
    CMP.L   D6,D7
    BLE.W   .return

    MOVE.L  D7,D0
    SUB.L   D6,D0
    ADDQ.L  #1,D0
    TST.L   D0
    BPL.S   .compute_half_gap_alt

    ADDQ.L  #1,D0

.compute_half_gap_alt:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    LEA     -49(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_prefix2_check

.copy_prefix2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix2_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    LEA     -90(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_attrs2_check

.copy_attrs2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs2_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     LAB_21F5,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix2_check

.copy_suffix2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix2_loop

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     LAB_21F9,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_tail2_check

.copy_tail2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail2_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_LoadCurrentAdIntoBuffers   (Load current ad into buffers??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A0-A1/A6 ??
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_LAB_0EAF, GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte, ED_RedrawAllRows, ED_DrawCurrentColorIndicator,
;   ED_RedrawCursorChar,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   GROUPB_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVORectFill
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_21EB, LAB_21FB
; WRITES:
;   LAB_21E8, LAB_21E9, LAB_21FE, GLOB_REF_BOOL_IS_LINE_OR_PAGE,
;   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
; DESC:
;   Loads the current ad into edit buffers and refreshes the screen.
; NOTES:
;   Pads buffers to LAB_21EB and redraws the header/status areas.
;------------------------------------------------------------------------------
ED_LoadCurrentAdIntoBuffers:
LAB_084B:
    LINK.W  A5,#-48
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     LAB_21F7
    PEA     LAB_21F0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_LAB_0EAF(PC)

    LEA     12(A7),A7
    LEA     LAB_21F0,A0
    MOVEA.L A0,A1

.find_string_end:
    TST.B   (A1)+
    BNE.S   .find_string_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVE.L  LAB_21EB,D0
    CMP.L   D0,D7
    BGE.S   .after_pad

    ADDA.L  D7,A0
    SUB.L   D7,D0
    MOVEQ   #32,D1
    BRA.S   .pad_spaces_check

.pad_spaces_loop:
    MOVE.B  D1,(A0)+

.pad_spaces_check:
    SUBQ.L  #1,D0
    BCC.S   .pad_spaces_loop

    LEA     LAB_21F7,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  LAB_21EB,D0
    SUB.L   D7,D0
    MOVEA.L 12(A7),A0
    BRA.S   .fill_attr_check

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_check:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

.after_pad:
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21FE
    BSR.W   ED_RedrawAllRows

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21E8
    MOVE.L  D0,LAB_21E9
    MOVE.L  D0,GLOB_REF_BOOL_IS_LINE_OR_PAGE
    MOVE.L  D0,-(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   LAB_21FB,D0
    MOVEQ   #30,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  LAB_21F7,D0
    MOVE.L  D0,(A7)
    BSR.W   ED_DrawCurrentColorIndicator

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     GLOB_STR_EDITING_AD_NUMBER_FORMATTED_2
    PEA     -44(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -44(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    ; Set drawing mode to 1
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    ; Set B pen to 2
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    BSR.W   ED_RedrawCursorChar

    MOVEM.L -60(A5),D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_CommitCurrentAdEdits   (Commit current ad edits??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 ??
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_LAB_0EDB
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   (none)
; DESC:
;   Commits the current ad buffers to storage.
; NOTES:
;   Calls GROUP_AL_JMPTBL_LADFUNC_LAB_0EDB with (adNumber-1).
;------------------------------------------------------------------------------
ED_CommitCurrentAdEdits:
LAB_0852:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     LAB_21F7
    PEA     LAB_21F0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_LAB_0EDB(PC)

    LEA     12(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_NextAdNumber   (Advance to next ad number??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 ??
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_21FD
; WRITES:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then advances to the next ad.
; NOTES:
;   No-op if already at LAB_21FD.
;------------------------------------------------------------------------------
ED_NextAdNumber:
LAB_0853:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   LAB_21FD,D0
    BGE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    ADDQ.L  #1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

; Decrement the current ad number being edited
;------------------------------------------------------------------------------
; FUNC: ED_PrevAdNumber   (Go to previous ad number??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then moves to the previous ad.
; NOTES:
;   No-op when current ad number is 1.
;------------------------------------------------------------------------------
ED_PrevAdNumber:
; Decrement the current ad number being edited
LAB_0855:
    CMPI.L  #$1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    SUBQ.L  #1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawEditHelpText   (Draw edit help text??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/A1/A6 ??
; CALLS:
;   ED_DrawBottomHelpBarBackground, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the help text for editing operations.
; NOTES:
;   Uses a fixed list of help strings.
;------------------------------------------------------------------------------
ED_DrawEditHelpText:
LAB_0857:
    MOVEM.L D2-D3,-(A7)

    BSR.W   ED_DrawBottomHelpBarBackground

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #$280,D2
    MOVE.L  #$165,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #$166,D1
    MOVE.L  #$1ad,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1DAC
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1DAD
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1DAE
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1DAF
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1DB0
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     LAB_1DB1
    PEA     210.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1DB2
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE
    PEA     300.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
