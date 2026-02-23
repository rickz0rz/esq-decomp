    XDEF    ED_ApplyActiveFlagToAdData
    XDEF    ED_CommitCurrentAdEdits
    XDEF    ED_DecrementAdNumber
    XDEF    ED_DrawAdEditingScreen
    XDEF    ED_DrawAdNumberPrompt
    XDEF    ED_DrawAreYouSurePrompt
    XDEF    ED_DrawBottomHelpBarBackground
    XDEF    ED_DrawCurrentColorIndicator
    XDEF    ED_DrawCursorChar
    XDEF    ED_DrawDiagnosticModeHelpText
    XDEF    ED_DrawDiagnosticModeText
    XDEF    ED_DrawDiagnosticRegisterValues
    XDEF    ED_DrawESCMenuBottomHelp
    XDEF    ED_DrawESCMenuHelpText
    XDEF    ED_DrawEditHelpText
    XDEF    ED_DrawEscMainMenuText
    XDEF    ED_DrawHelpPanels
    XDEF    ED_DrawMenuSelectionHighlight
    XDEF    ED_DrawScrollSpeedMenuText
    XDEF    ED_DrawSpecialFunctionsMenu
    XDEF    ED_GetEscMenuActionCode
    XDEF    ED_IncrementAdNumber
    XDEF    ED_InitRastport2Pens
    XDEF    ED_IsConfirmKey
    XDEF    ED_LoadCurrentAdIntoBuffers
    XDEF    ED_NextAdNumber
    XDEF    ED_PrevAdNumber
    XDEF    ED_RedrawAllRows
    XDEF    ED_RedrawCursorChar
    XDEF    ED_RedrawRow
    XDEF    ED_TransformLineSpacing_Mode1
    XDEF    ED_TransformLineSpacing_Mode2
    XDEF    ED_TransformLineSpacing_Mode3
    XDEF    ED_UpdateActiveInactiveIndicator
    XDEF    ED_UpdateAdNumberDisplay
    XDEF    ED_UpdateCursorPosFromIndex
    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE
    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

;------------------------------------------------------------------------------
; FUNC: ED_GetEscMenuActionCode   (Get ESC menu action codeuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D1
; CALLS:
;   (none)
; READS:
;   ED_LastKeyCode, ED_EditCursorOffset, ED_LastMenuInputChar, ED_StateRingIndex, ED_StateRingTable
; WRITES:
;   ED_LastMenuInputChar
; DESC:
;   Decodes the current ESC-menu key/selection into an action code.
; NOTES:
;   Uses a small switch table when ED_LastKeyCode matches the menu-mode case.
;------------------------------------------------------------------------------
ED_GetEscMenuActionCode:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),ED_LastMenuInputChar
    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
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
    MOVE.L  ED_EditCursorOffset,D0
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
    MOVE.B  ED_LastMenuInputChar,D0
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
; FUNC: ED_IsConfirmKey   (Check for confirm keyuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   ED_LastKeyCode
; WRITES:
;   (none)
; DESC:
;   Returns a flag based on the current key code in ED_LastKeyCode.
; NOTES:
;   Treats key codes $59 and $20 as confirm keys.
;------------------------------------------------------------------------------
ED_IsConfirmKey:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
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
; FUNC: ED_DrawESCMenuBottomHelp
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 uncertain
; CALLS:
;   ED_DrawBottomHelpBarBackground, ED_DrawESCMenuHelpText
; READS:
;   (none)
; WRITES:
;   ED_MenuStateId
; DESC:
;   Draws the bottom help panel for the ESC menu.
; NOTES:
;   Sets ED_MenuStateId to 1 before drawing.
;------------------------------------------------------------------------------
ED_DrawESCMenuBottomHelp:
    MOVE.B  #$1,ED_MenuStateId
    BSR.W   ED_DrawBottomHelpBarBackground

    ; this might actually end up drawing all the text.
    BSR.W   ED_DrawESCMenuHelpText

    RTS

;!======

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
;   WDISP_DisplayContextBase, ED_Rastport2PenModeSelector, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets drawing mode and pen defaults for the secondary rastport.
; NOTES:
;   Uses ED_Rastport2PenModeSelector to select alternate pen setup.
;------------------------------------------------------------------------------
ED_InitRastport2Pens:
    LINK.W  A5,#-4
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVE.L  A0,-4(A5)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #14,D0
    CMP.L   ED_Rastport2PenModeSelector,D0
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
; FUNC: ED_DrawBottomHelpBarBackground   (Draw bottom help bar backgrounduncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the bottom help bar background rectangle.
; NOTES:
;   Uses APen 2 for the bar and restores APen/DrMd afterward.
;------------------------------------------------------------------------------
ED_DrawBottomHelpBarBackground:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #680,D2
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   ED_DrawMenuSelectionHighlight, DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the main ESC menu option list.
; NOTES:
;   Calls ED_DrawMenuSelectionHighlight to draw the selection highlight.
;------------------------------------------------------------------------------
ED_DrawEscMainMenuText:
    PEA     6.W
    BSR.W   ED_DrawMenuSelectionHighlight

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_EDIT_ADS
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_EDIT_ATTRIBUTES
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_CHANGE_SCROLL_SPEED
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_DIAGNOSTIC_MODE
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     68(A7),A7
    PEA     Global_STR_SPECIAL_FUNCTIONS
    PEA     210.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_VERSIONS_SCREEN
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawESCMenuHelpText
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 uncertain
; CALLS:
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition, ED_DrawEscMainMenuText,
;   _LVOSetDrMd, _LVOSetAPen
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   ED_EditCursorOffset
; DESC:
;   Draws the ESC menu help footer and then the main menu text.
; NOTES:
;   Resets ED_EditCursorOffset to 0 before drawing menu text.
;------------------------------------------------------------------------------
ED_DrawESCMenuHelpText:
    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ESC_TO_RESUME
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1
    PEA     360.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_ANY_KEY_TO_SELECT_1
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    CLR.L   ED_EditCursorOffset
    BSR.W   ED_DrawEscMainMenuText

    LEA     52(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawDiagnosticModeText
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D1/A0-A1/A6 uncertain
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, DISPLIB_DisplayTextAtPosition
; READS:
;   Global_REF_RASTPORT_1, ED_DiagTextModeChar, ED_DiagGraphModeChar, ED_DiagVinModeChar, ED_DiagScrollSpeedChar,
;   ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic mode labels and data fields.
; NOTES:
;   Uses multiple short text fields for runtime values.
;------------------------------------------------------------------------------
ED_DrawDiagnosticModeText:
    MOVEA.L Global_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_VIN_BCK_FWD_SSPD_AD_LINE
    PEA     300.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_TZ_DST_CONT_TXT_GRPH
    PEA     330.W
    PEA     90.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #100,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ED_DiagVinModeChar,A0
    MOVEQ   #(ED_DiagVinModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #95,D0
    ADD.L   D0,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_STR_B,A0
    MOVEQ   #(ESQ_STR_B_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #280,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_STR_E,A0
    MOVEQ   #(ESQ_STR_E_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #385,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,A0
    MOVEQ   #(ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #475,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_TAG_36,A0
    MOVEQ   #(ESQ_TAG_36_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #595,D0
    MOVE.L  #300,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ED_DiagScrollSpeedChar,A0
    MOVEQ   #(ED_DiagScrollSpeedChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #75,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_STR_6,A0
    MOVEQ   #(ESQ_STR_6_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #120,D0
    ADD.L   D0,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_SecondarySlotModeFlagChar,A0
    MOVEQ   #(ESQ_SecondarySlotModeFlagChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #345,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ESQ_STR_Y,A0
    MOVEQ   #(ESQ_STR_Y_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #450,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ED_DiagTextModeChar,A0
    MOVEQ   #(ED_DiagTextModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #555,D0
    MOVE.L  #330,D1
    JSR     _LVOMove(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    LEA     ED_DiagGraphModeChar,A0
    MOVEQ   #(ED_DiagGraphModeChar_Length),D0
    JSR     _LVOText(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawHelpPanels
; ARGS:
;   stack +4: u16 penIndex uncertain
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 uncertain
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
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

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #297,D3
    JSR     _LVORectFill(A6)

    MOVE.L  D7,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #298,D1
    ; D2 is still 640
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawMenuSelectionHighlight   (Draw ESC menu selection highlightuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   ED_EditCursorOffset, Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the selection highlight bar for the ESC menu.
; NOTES:
;   Uses ED_EditCursorOffset to optionally draw the current selection marker.
;------------------------------------------------------------------------------
ED_DrawMenuSelectionHighlight:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  16(A7),D7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #67,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CMPI.L  #$ffffffff,ED_EditCursorOffset
    BLE.S   .after_optional_marker

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  ED_EditCursorOffset,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,D1
    MOVEQ   #68,D2
    ADD.L   D2,D1
    MOVEQ   #97,D2
    ADD.L   D2,D0
    MOVE.L  D0,D3
    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill, DISPLIB_DisplayTextAtPosition
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the diagnostic mode help footer.
; NOTES:
;   Writes the return/any-key prompts.
;------------------------------------------------------------------------------
ED_DrawDiagnosticModeHelpText:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #327,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_ANY_KEY_TO_SELECT_2
    PEA     420.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; draw esc - change scroll speed menu text
;------------------------------------------------------------------------------
; FUNC: ED_DrawScrollSpeedMenuText   (Draw scroll speed menu textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED
; WRITES:
;   (none)
; DESC:
;   Draws the change-scroll-speed menu text and current speed.
; NOTES:
;   Uses an 80-byte local buffer (-80(A5)..-1(A5)); WDISP_SPrintf has no
;   explicit destination-length parameter.
;------------------------------------------------------------------------------
ED_DrawScrollSpeedMenuText:

.statusLine = -80

    LINK.W  A5,#-80

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.B  ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0         ; '3'
    MOVE.L  D0,-(A7)
    PEA     ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C
    PEA     .statusLine(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .statusLine(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SPEED_ZERO_NOT_AVAILABLE
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SPEED_ONE_NOT_AVAILABLE
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_2
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7

    PEA     Global_STR_SCROLL_SPEED_3
    PEA     210.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_4
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_5
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_6
    PEA     300.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SCROLL_SPEED_7
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawSpecialFunctionsMenu
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/A1/A6 uncertain
; CALLS:
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the ESC special functions menu text.
; NOTES:
;   Restores drawing mode afterward.
;------------------------------------------------------------------------------
ED_DrawSpecialFunctionsMenu:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_SAVE_ALL_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SAVE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LOAD_TEXT_ADS_FROM_DISK
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_REBOOT_COMPUTER
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     64(A7),A7

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawDiagnosticRegisterValues   (Draw diagnostic register valuesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   DISPLIB_DisplayTextAtPosition, GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   ED_TempCopyOffset, GCOMMAND_PresetFallbackValue0, GCOMMAND_PresetFallbackValue1, GCOMMAND_PresetFallbackValue2, Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic register labels and formatted values.
; NOTES:
;   Formats values into ED_EditBufferScratch before display.
;------------------------------------------------------------------------------
ED_DrawDiagnosticRegisterValues:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_REGISTER
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  ED_TempCopyOffset,-(A7)
    PEA     ED_EditBufferScratch
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     ED_EditBufferScratch
    PEA     240.W
    PEA     190.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_R_EQUALS
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     GCOMMAND_PresetFallbackValue0,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     ED_EditBufferScratch
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    LEA     72(A7),A7
    PEA     ED_EditBufferScratch
    PEA     270.W
    PEA     85.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_G_EQUALS
    PEA     270.W
    PEA     135.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     GCOMMAND_PresetFallbackValue1,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     ED_EditBufferScratch
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     ED_EditBufferScratch
    PEA     270.W
    PEA     180.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_B_EQUALS
    PEA     270.W
    PEA     230.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     GCOMMAND_PresetFallbackValue2,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     ED_EditBufferScratch
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     ED_EditBufferScratch
    PEA     270.W
    PEA     275.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawAreYouSurePrompt   (Draw "Are you sure" promptuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws a confirmation prompt panel.
; NOTES:
;   Uses ED_DrawHelpPanels to render the background.
;------------------------------------------------------------------------------
ED_DrawAreYouSurePrompt:
    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ARE_YOU_SURE
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     20(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   ED_DrawHelpPanels, DISPLIB_DisplayTextAtPosition, GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   ED_MaxAdNumber, Global_REF_RASTPORT_1
; WRITES:
;   ED_EditCursorOffset, ED_AdNumberPromptStateBlock
; DESC:
;   Draws the "enter ad number" prompt and initializes the entry buffer.
; NOTES:
;   Initializes ED_EditBufferScratch/ED_EditBufferLive with spaces and default chars.
;------------------------------------------------------------------------------
ED_DrawAdNumberPrompt:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D7,-(A7)

    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  ED_MaxAdNumber,-(A7)
    PEA     ED_EditBufferScratch
    JSR     GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     ED_EditBufferScratch
    PEA     330.W
    PEA     340.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LEFT_PARENTHESIS_THEN
    PEA     330.W
    PEA     370.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2
    PEA     360.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     Global_STR_SINGLE_SPACE_4
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_AD_NUMBER_QUESTIONMARK
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #12,D0
    MOVE.L  D0,ED_EditCursorOffset
    MOVEQ   #0,D7

.init_entry_loop:
    MOVEQ   #14,D0
    CMP.L   D0,D7
    BGE.S   .init_entry_done

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D7,A0
    MOVE.B  #$20,(A0)
    LEA     ED_EditBufferLive,A0
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
    BSR.W   ED_RedrawCursorChar

    MOVEM.L (A7)+,D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawCursorChar   (Redraw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/D0
; CALLS:
;   ED_DrawCursorChar, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current cursor character using a temporary draw mode.
; NOTES:
;   Sets draw mode to 5, draws, then restores draw mode to 1.
;------------------------------------------------------------------------------
ED_RedrawCursorChar:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   ED_DrawCursorChar

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawCursorChar   (Draw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ED_UpdateCursorPosFromIndex, ESQIFF_JMPTBL_MATH_Mulu32,
;   _LVOSetAPen, _LVOSetBPen, _LVOMove, _LVOText
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset, ED_CursorColumnIndex, ED_EditBufferScratch, ED_EditBufferLive, Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the character at the current cursor position.
; NOTES:
;   Updates pen colors based on character mapping tables.
;------------------------------------------------------------------------------
ED_DrawCursorChar:
    LINK.W  A5,#-4
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  ED_EditCursorOffset,(A7)
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  0(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   ED_TextLimit
; WRITES:
;   ED_CursorColumnIndex, ED_ViewportOffset, ED_EditCursorOffset
; DESC:
;   Computes row/column indices from a linear cursor index.
; NOTES:
;   Clamps ED_ViewportOffset and ED_EditCursorOffset to visible ranges.
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
    CMP.L   ED_TextLimit,D0
    BLT.S   .return

    SUBQ.L  #1,ED_ViewportOffset
    MOVEQ   #40,D0
    SUB.L   D0,ED_EditCursorOffset
    BRA.S   .clamp_cursor_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawCurrentColorIndicator   (Draw current color indicatoruncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +56: arg_3 (via 60(A5))
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVORectFill
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current color swatch and formatted label.
; NOTES:
;   Local color-label buffer is 41 bytes (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_DrawCurrentColorIndicator:

.colorLabel = -41

    LINK.W  A5,#-44
    MOVEM.L D2-D3/D6-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    JSR     _LVOSetBPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    PEA     Global_STR_CURRENT_COLOR_FORMATTED
    PEA     .colorLabel(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .colorLabel(A5)
    PEA     272.W
    PEA     205.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   Global_REF_RASTPORT_1
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   Global_REF_BOOL_IS_LINE_OR_PAGE, Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "LINE" or "PAGE" label with fixed pens.
; NOTES:
;   Uses Global_REF_BOOL_IS_LINE_OR_PAGE as the selector.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE:
    LINK.W  A5,#0

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_IncrementAdNumber   (Increment current ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   ED_ApplyActiveFlagToAdData, ED_UpdateAdNumberDisplay
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_MaxAdNumber
; WRITES:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Increments the current ad number if within bounds and refreshes display.
; NOTES:
;   Calls ED_ApplyActiveFlagToAdData before increment to commit current state.
;------------------------------------------------------------------------------
ED_IncrementAdNumber:
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   ED_MaxAdNumber,D0
    BGE.S   .return

    BSR.W   ED_ApplyActiveFlagToAdData

    ADDQ.L  #1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_UpdateAdNumberDisplay

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DecrementAdNumber   (Decrement current ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   none observed
; CALLS:
;   ED_ApplyActiveFlagToAdData, ED_UpdateAdNumberDisplay
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Decrements the current ad number if above 1 and refreshes display.
; NOTES:
;   Calls ED_ApplyActiveFlagToAdData before decrement to commit current state.
;------------------------------------------------------------------------------
ED_DecrementAdNumber:
    CMPI.L  #1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.W   ED_ApplyActiveFlagToAdData

    SUBQ.L  #1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_UpdateAdNumberDisplay

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateAdNumberDisplay   (Update ad number displayuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ED_UpdateActiveInactiveIndicator
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_AdRecordPtrTable
; WRITES:
;   ED_AdActiveFlag, ED_ViewportOffset, ED_AdDisplayResetFlag, ED_AdDisplayStateLatchBlockB, ED_ActiveIndicatorCachedState, ED_AdDisplayStateLatchA
; DESC:
;   Displays the current ad number and resets editing state for the ad.
; NOTES:
;   Initializes ED_AdActiveFlag based on the ad's active flag.
;   Local display buffer is 40 bytes (-40(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_UpdateAdNumberDisplay:

.adLabel = -40

    LINK.W  A5,#-40

    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,-(A7)
    PEA     Global_STR_AD_NUMBER_FORMATTED
    PEA     .adLabel(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .adLabel(A5)
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.L  D0,ED_AdActiveFlag
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D1
    ASL.L   #2,D1
    LEA     ED_AdRecordPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.W  (A1),D1
    TST.W   D1
    BLE.S   .after_active_check

    MOVEQ   #1,D1
    MOVE.L  D1,ED_AdActiveFlag

.after_active_check:
    MOVEQ   #1,D1
    MOVE.L  D1,ED_AdDisplayResetFlag
    MOVE.L  D0,ED_ViewportOffset
    MOVEQ   #-1,D0
    MOVE.L  D0,ED_AdDisplayStateLatchBlockB
    MOVE.L  D0,ED_ActiveIndicatorCachedState
    MOVE.L  D0,ED_AdDisplayStateLatchA
    BSR.W   ED_UpdateActiveInactiveIndicator

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_ApplyActiveFlagToAdData   (Apply active flag to ad datauncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D1/D2
; CALLS:
;   (none)
; READS:
;   ED_AdActiveFlag, Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_AdRecordPtrTable
; WRITES:
;   Ad data (first word / word+2) via ED_AdRecordPtrTable
; DESC:
;   Writes the active/inactive flag for the current ad into its data record.
; NOTES:
;   Clears both words when inactive; sets word0=1 and word2=$30 when active.
;------------------------------------------------------------------------------
ED_ApplyActiveFlagToAdData:
    MOVEM.L D2/A2,-(A7)

    TST.L   ED_AdActiveFlag
    BNE.S   .set_active

    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    MOVE.L  D0,D1
    ASL.L   #2,D1
    LEA     ED_AdRecordPtrTable,A0
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
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    ASL.L   #2,D0
    LEA     ED_AdRecordPtrTable,A0
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
; FUNC: ED_RedrawAllRows   (Redraw all rowsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ED_DrawCursorChar, GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   ED_EditCursorOffset, ED_BlockOffset, ED_TextLimit, ED_EditBufferLive
; WRITES:
;   ED_EditCursorOffset
; DESC:
;   Redraws all rows using the current buffer contents.
; NOTES:
;   Restores ED_EditCursorOffset to its original value after redraw.
;------------------------------------------------------------------------------
ED_RedrawAllRows:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  ED_EditCursorOffset,D7
    MOVEQ   #0,D0
    MOVE.B  ED_EditBufferLive,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #68,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CLR.L   ED_EditCursorOffset

.redraw_loop:
    MOVE.L  ED_EditCursorOffset,D0
    CMP.L   ED_BlockOffset,D0
    BGE.S   .return

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,ED_EditCursorOffset
    BRA.S   .redraw_loop

.return:
    MOVE.L  D7,ED_EditCursorOffset
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawRow   (Redraw a rowuncertain)
; ARGS:
;   stack +4: u32 rowIndex
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   ED_DrawCursorChar, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen
; READS:
;   ED_EditCursorOffset, ED_BlockOffset, ED_TextLimit
; WRITES:
;   ED_EditCursorOffset
; DESC:
;   Redraws a single row of text based on the given row index.
; NOTES:
;   Temporarily updates ED_EditCursorOffset to walk the row range.
;------------------------------------------------------------------------------
ED_RedrawRow:
    MOVEM.L D6-D7,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  ED_EditCursorOffset,D6
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_EditCursorOffset

.row_loop:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .row_done

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,ED_EditCursorOffset
    BRA.S   .row_loop

.row_done:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D6,ED_EditCursorOffset
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateActiveInactiveIndicator   (Update active/inactive indicatoruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd, DISPLIB_DisplayTextAtPosition
; READS:
;   ED_AdActiveFlag, ED_ActiveIndicatorCachedState, Global_REF_RASTPORT_1
; WRITES:
;   ED_ActiveIndicatorCachedState
; DESC:
;   Updates the active/inactive indicator when the flag changes.
; NOTES:
;   Draws two rectangles and the ACTIVE/INACTIVE label.
;------------------------------------------------------------------------------
ED_UpdateActiveInactiveIndicator:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  ED_AdActiveFlag,D0
    MOVE.L  ED_ActiveIndicatorCachedState,D1
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D5,D0
    MOVE.L  D4,D2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ACTIVE_INACTIVE
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.L  ED_AdActiveFlag,ED_ActiveIndicatorCachedState

.after_indicator_update:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D7
    RTS

;!======

; draw ad editing screen (editing ad)
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdEditingScreen   (Draw ad editing screenuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   ED_DrawHelpPanels, SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   ED_TextLimit, Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,
;   Global_REF_BOOL_IS_LINE_OR_PAGE, Global_REF_BOOL_IS_TEXT_OR_CURSOR
; WRITES:
;   (none)
; DESC:
;   Draws the ad editing screen header and status indicators.
; NOTES:
;   Uses a 41-byte local printf buffer (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_DrawAdEditingScreen:
    LINK.W  A5,#-44
    MOVEM.L D2-D3,-(A7)

.printfResult   = -41

    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS
    PEA     360.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  Global_REF_BOOL_IS_LINE_OR_PAGE,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVE.L  Global_REF_BOOL_IS_TEXT_OR_CURSOR,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_1
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_TransformLineSpacing_Mode1   (Transform line spacing mode 1uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 1).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode1:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_space_scan:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformSuffixScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix_check

.copy_suffix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix_loop

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformTailScratchBuffer,A0
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
; FUNC: ED_TransformLineSpacing_Mode2   (Transform line spacing mode 2uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 2).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode2:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_left_spaces

.after_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
; FUNC: ED_TransformLineSpacing_Mode3   (Transform line spacing mode 3uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 3).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode3:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformSuffixScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix2_check

.copy_suffix2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix2_loop

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformTailScratchBuffer,A0
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
; FUNC: ED_LoadCurrentAdIntoBuffers   (Load current ad into buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault, GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte, ED_RedrawAllRows, ED_DrawCurrentColorIndicator,
;   ED_RedrawCursorChar,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVORectFill
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_BlockOffset, ED_TextLimit
; WRITES:
;   ED_EditCursorOffset, ED_ViewportOffset, ED_AdDisplayResetFlag, Global_REF_BOOL_IS_LINE_OR_PAGE,
;   Global_REF_BOOL_IS_TEXT_OR_CURSOR
; DESC:
;   Loads the current ad into edit buffers and refreshes the screen.
; NOTES:
;   Pads buffers to ED_BlockOffset and redraws the header/status areas.
;   Uses a 44-byte local printf target (-44(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_LoadCurrentAdIntoBuffers:

.editingAdLabel = -44

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     ED_EditBufferLive
    PEA     ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(PC)

    LEA     12(A7),A7
    LEA     ED_EditBufferScratch,A0
    MOVEA.L A0,A1

.find_string_end:
    TST.B   (A1)+
    BNE.S   .find_string_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVE.L  ED_BlockOffset,D0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  ED_BlockOffset,D0
    SUB.L   D7,D0
    MOVEA.L 12(A7),A0
    BRA.S   .fill_attr_check

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_check:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

.after_pad:
    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,ED_AdDisplayResetFlag
    BSR.W   ED_RedrawAllRows

    MOVEQ   #0,D0
    MOVE.L  D0,ED_EditCursorOffset
    MOVE.L  D0,ED_ViewportOffset
    MOVE.L  D0,Global_REF_BOOL_IS_LINE_OR_PAGE
    MOVE.L  D0,-(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVEQ   #1,D0
    MOVE.L  D0,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  ED_EditBufferLive,D0
    MOVE.L  D0,(A7)
    BSR.W   ED_DrawCurrentColorIndicator

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_2
    PEA     .editingAdLabel(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .editingAdLabel(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    ; Set drawing mode to 1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    ; Set B pen to 2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    BSR.W   ED_RedrawCursorChar

    MOVEM.L -60(A5),D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_CommitCurrentAdEdits   (Commit current ad editsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A7/D0
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   (none)
; DESC:
;   Commits the current ad buffers to storage.
; NOTES:
;   Calls GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex with (adNumber-1).
;------------------------------------------------------------------------------
ED_CommitCurrentAdEdits:
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     ED_EditBufferLive
    PEA     ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(PC)

    LEA     12(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_NextAdNumber   (Advance to next ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_MaxAdNumber
; WRITES:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then advances to the next ad.
; NOTES:
;   No-op if already at ED_MaxAdNumber.
;------------------------------------------------------------------------------
ED_NextAdNumber:
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   ED_MaxAdNumber,D0
    BGE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    ADDQ.L  #1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

; Decrement the current ad number being edited
;------------------------------------------------------------------------------
; FUNC: ED_PrevAdNumber   (Go to previous ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then moves to the previous ad.
; NOTES:
;   No-op when current ad number is 1.
;------------------------------------------------------------------------------
ED_PrevAdNumber:
    CMPI.L  #$1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    SUBQ.L  #1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawEditHelpText   (Draw edit help textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   ED_DrawBottomHelpBarBackground, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the help text for editing operations.
; NOTES:
;   Uses a fixed list of help strings.
;------------------------------------------------------------------------------
ED_DrawEditHelpText:
    MOVEM.L D2-D3,-(A7)

    BSR.W   ED_DrawBottomHelpBarBackground

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #$280,D2
    MOVE.L  #$165,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #$166,D1
    MOVE.L  #$1ad,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY
    PEA     210.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE
    PEA     300.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
