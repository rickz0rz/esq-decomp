    XDEF    _ED_HandleSpecialFunctionsMenu


;------------------------------------------------------------------------------
; FUNC: _ED_HandleSpecialFunctionsMenu   (Handle ESC special functions menuuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ED_GetEscMenuActionCode, _ED_DrawAreYouSurePrompt, _ED_DrawMenuSelectionHighlight, _ED_DrawDiagnosticRegisterValues,
;   _ED_DrawESCMenuBottomHelp, _ED_DrawSpecialFunctionsMenu,
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVORectFill
; READS:
;   _ED_EditCursorOffset, _ED_MenuStateId
; WRITES:
;   _ED_MenuStateId, _ED_EditCursorOffset, _ED_TempCopyOffset
; DESC:
;   Dispatches ESC special-functions menu selection and updates display state.
; NOTES:
;   Uses a switch/jumptable on the key code returned by _ED_GetEscMenuActionCode.
;------------------------------------------------------------------------------
_ED_HandleSpecialFunctionsMenu:
    MOVEM.L D2-D3/D7,-(A7)
    JSR     _ED_GetEscMenuActionCode(PC)

    MOVE.L  D0,D7
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #8,D0
    BCC.W   .case_next_special_selection

    ADD.W   D0,D0

    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; switch/jumptable
.dispatch_table:
    DC.W    .case_show_help-.dispatch_table-2
	DC.W    .case_show_label_1d1b-.dispatch_table-2
    DC.W    .case_show_label_1d1c-.dispatch_table-2
	DC.W    .case_show_label_1d1d-.dispatch_table-2
    DC.W    .case_show_reboot_warning-.dispatch_table-2
    DC.W    .case_next_special_selection-.dispatch_table-2
	DC.W    .case_draw_color_bars-.dispatch_table-2
    DC.W    .case_prev_special_selection-.dispatch_table-2

.case_show_help:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_show_label_1d1b:
    JSR     _ED_DrawAreYouSurePrompt(PC)

    PEA     _ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$b,_ED_MenuStateId

    BRA.W   .return

.case_show_label_1d1c:
    JSR     _ED_DrawAreYouSurePrompt(PC)

    PEA     _ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$c,_ED_MenuStateId
    BRA.W   .return

.case_show_label_1d1d:
    JSR     _ED_DrawAreYouSurePrompt(PC)

    PEA     _ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$d,_ED_MenuStateId
    BRA.W   .return

.case_show_reboot_warning:
    JSR     _ED_DrawAreYouSurePrompt(PC)

    PEA     _Global_STR_COMPUTER_WILL_RESET
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_GO_OFF_AIR_FOR_1_2_MINS
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.B  #$e,_ED_MenuStateId
    BRA.W   .return

.case_prev_special_selection:
    SUBQ.L  #1,_ED_EditCursorOffset
    BGE.S   .redraw_special_menu

    MOVEQ   #3,D0
    MOVE.L  D0,_ED_EditCursorOffset

.redraw_special_menu:
    PEA     4.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_draw_color_bars:
    MOVEQ   #2,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.W   .case_next_special_selection

    MOVE.B  #$f,_ED_MenuStateId

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVEQ   #115,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVEQ   #95,D2
    ADD.L   D2,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #265,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #340,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #415,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$1ea,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$235,D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$280,D2
    JSR     _LVORectFill(A6)

    CLR.L   _ED_TempCopyOffset
    JSR     _ED_DrawDiagnosticRegisterValues(PC)

    BRA.S   .return

.case_next_special_selection:
    ADDQ.L  #1,_ED_EditCursorOffset
    MOVEQ   #4,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.S   .after_selection_wrap

    CLR.L   _ED_EditCursorOffset

.after_selection_wrap:
    MOVE.L  D0,-(A7)
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======