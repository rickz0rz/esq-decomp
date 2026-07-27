    XDEF    ED1_HandleEscMenuInput


;------------------------------------------------------------------------------
; FUNC: ED1_HandleEscMenuInput   (Handle ESC menu command selectionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ED_GetEscMenuActionCode, ED_DrawAdNumberPrompt, ED_DrawDiagnosticModeHelpText, _ED_DrawMenuSelectionHighlight, _ED_DrawScrollSpeedMenuText, _ED_DrawBottomHelpBarBackground, ED_DrawEscMainMenuText,
;   _ED1_DrawDiagnosticsScreen, _ED_DrawSpecialFunctionsMenu,
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   _ED_DiagTextModeChar, _ED_SavedScrollSpeedIndex, _ED_EditCursorOffset
; WRITES:
;   _ED_MenuStateId, _ED_EditCursorOffset, ESQ_ShutdownRequestedFlag
; DESC:
;   Dispatches ESC-menu commands, updates selection state, and shows errors.
; NOTES:
;   Uses a switch/jumptable; D6 nonzero triggers an error prompt.
;------------------------------------------------------------------------------
ED1_HandleEscMenuInput:
    MOVEM.L D6-D7,-(A7)
    JSR     _ED_GetEscMenuActionCode(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D6
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #9,D0
    BCC.W   .adjust_selection

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; switch/jumptable
.dispatch_table:
    DC.W    .case_show_version-.dispatch_table-2
    DC.W    .case_set_mode_2-.dispatch_table-2
    DC.W    .case_set_mode_3-.dispatch_table-2
	DC.W    .case_mode_6-.dispatch_table-2
    DC.W    .case_diagnostics-.dispatch_table-2
    DC.W    .case_special_functions-.dispatch_table-2
	DC.W    .case_mode_8-.dispatch_table-2
    DC.W    .case_adjust_selection-.dispatch_table-2
    DC.W    .case_set_flag-.dispatch_table-2

.case_show_version:
    BSR.W   *+(_ED1_EnterEscMenu_AfterVersionText-.dispatch_table+2)

    BRA.W   .done

.case_set_mode_2:
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_2_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$2,_ED_MenuStateId
    BRA.W   .done

.case_mode_2_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_set_mode_3:
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_3_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$3,_ED_MenuStateId
    BRA.W   .done

.case_mode_3_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_mode_6:
    MOVE.B  #$6,_ED_MenuStateId
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    MOVE.L  _ED_SavedScrollSpeedIndex,_ED_EditCursorOffset
    PEA     9.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_diagnostics:
    BSR.W   _ED1_DrawDiagnosticsScreen

    BRA.S   .done

.case_special_functions:
    MOVE.B  #$a,_ED_MenuStateId
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    CLR.L   _ED_EditCursorOffset
    PEA     4.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_mode_8:
    MOVE.B  #$8,_ED_MenuStateId
    JSR     _ED_DrawBottomHelpBarBackground(PC)

    BRA.S   .done

.case_set_flag:
    MOVE.W  #1,ESQ_ShutdownRequestedFlag
    BRA.S   .done

.case_adjust_selection:
.adjust_selection:
    MOVEQ   #9,D0
    CMP.B   D0,D7
    BNE.S   .adjust_step_small

    MOVEQ   #5,D0
    BRA.S   .adjust_apply

.adjust_step_small:
    MOVEQ   #1,D0

.adjust_apply:
    ADD.L   D0,_ED_EditCursorOffset
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #6,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,_ED_EditCursorOffset
    JSR     ED_DrawEscMainMenuText(PC)

.done:
    TST.B   D6
    BEQ.S   .return

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  D6,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BNE.S   .draw_error

    PEA     ED2_STR_LOCAL_EDIT_NOT_AVAILABLE
    PEA     270.W
    PEA     145.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.draw_error:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======