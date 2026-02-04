;------------------------------------------------------------------------------
; FUNC: ED_DispatchEscMenuState   (Dispatch ESC menu state??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0-A1/A6 ??
; CALLS:
;   ED2_HandleMenuActions, ED1_HandleEscMenuInput, ED1_UpdateEscMenuSelection,
;   ED2_HandleScrollSpeedSelection, ED2_HandleDiagnosticsMenuActions,
;   ED_EnterTextEditMode, ED_CaptureKeySequence, ED_HandleDiagnosticNibbleEdit,
;   ED_HandleSpecialFunctionsMenu, ED_SaveEverythingToDisk, ED_SavePrevueDataToDisk,
;   ED_LoadTextAdsFromDh2, ED_RebootComputer, ED_HandleEditAttributesMenu,
;   ED_HandleEditAttributesInput, ED_HandleEditorInput,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   LAB_231C, LAB_231B, LAB_1D14, LAB_1D13, LAB_2263
; WRITES:
;   LAB_1D14, LAB_21ED, LAB_231C
; DESC:
;   Dispatches ESC-menu state handlers based on LAB_1D13 using a jumptable.
; NOTES:
;   Increments LAB_231C modulo $14 after each dispatch.
;------------------------------------------------------------------------------
ED_DispatchEscMenuState:
LAB_0671:
    MOVE.L  LAB_231C,D0
    MOVE.L  LAB_231B,D1
    CMP.L   D0,D1
    BEQ.W   LAB_0677

    TST.L   LAB_1D14
    BEQ.W   LAB_0677

    CLR.L   LAB_1D14
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_21ED
    TST.W   LAB_2263
    BEQ.S   .after_pen_setup

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

.after_pen_setup:
    MOVE.B  LAB_1D13,D0
    EXT.W   D0
    CMPI.W  #$19,D0
    BCC.W   .advance_index

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; switch/jumptable
.dispatch_table:
    DC.W    .case_menu_actions-.dispatch_table-2
    DC.W    .case_handle_esc_menu_input-.dispatch_table-2
    DC.W    .case_edit_attributes_menu-.dispatch_table-2
    DC.W    .case_edit_attributes_menu-.dispatch_table-2
    DC.W    .case_handle_editor_input-.dispatch_table-2
    DC.W    .case_edit_attributes_input-.dispatch_table-2
    DC.W    .case_scroll_speed-.dispatch_table-2
    DC.W    .case_diagnostics_actions-.dispatch_table-2
    DC.W    .case_update_esc_menu_selection-.dispatch_table-2
    DC.W    .case_call_06c0-.dispatch_table-2
    DC.W    .case_call_06db-.dispatch_table-2
    DC.W    .case_save_everything-.dispatch_table-2
    DC.W    .case_save_prevue_data-.dispatch_table-2
    DC.W    .case_load_text_ads-.dispatch_table-2
    DC.W    .case_reboot_computer-.dispatch_table-2
    DC.W    .case_call_06ce-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_noop-.dispatch_table-2
    DC.W    .case_call_06c1-.dispatch_table-2

.case_menu_actions:
    JSR     ED2_HandleMenuActions(PC)

    BRA.S   .advance_index

.case_call_06c1:
    BSR.W   ED_CaptureKeySequence

    BRA.S   .advance_index

.case_handle_esc_menu_input:
    BSR.W   ED1_HandleEscMenuInput

    BRA.S   .advance_index

.case_edit_attributes_menu:
    BSR.W   ED_HandleEditAttributesMenu

    BRA.S   .advance_index

.case_edit_attributes_input:
    BSR.W   ED_HandleEditAttributesInput

    BRA.S   .advance_index

.case_handle_editor_input:
    BSR.W   ED_HandleEditorInput

    BRA.S   .advance_index

.case_call_06c0:
    BSR.W   ED_EnterTextEditMode

    BRA.S   .advance_index

.case_scroll_speed:
    JSR     ED2_HandleScrollSpeedSelection(PC)

    BRA.S   .advance_index

.case_diagnostics_actions:
    JSR     ED2_HandleDiagnosticsMenuActions(PC)

    BRA.S   .advance_index

.case_update_esc_menu_selection:
    BSR.W   ED1_UpdateEscMenuSelection

    BRA.S   .advance_index

.case_call_06db:
    BSR.W   ED_HandleSpecialFunctionsMenu

    BRA.S   .advance_index

.case_save_everything:
    BSR.W   ED_SaveEverythingToDisk

    BRA.S   .advance_index

.case_save_prevue_data:
    BSR.W   ED_SavePrevueDataToDisk

    BRA.S   .advance_index

.case_load_text_ads:
    BSR.W   ED_LoadTextAdsFromDh2

    BRA.S   .advance_index

.case_reboot_computer:
    BSR.W   ED_RebootComputer

    BRA.S   .advance_index

.case_call_06ce:
    BSR.W   ED_HandleDiagnosticNibbleEdit

.case_noop:
.advance_index:
    ADDQ.L  #1,LAB_231C
    CMPI.L  #$14,LAB_231C
    BLT.S   .after_wrap_index

    CLR.L   LAB_231C

.after_wrap_index:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1D14

LAB_0677:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditorInput   (Handle editor input??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/D7/A0-A2 ??
; CALLS:
;   ED_DrawCursorChar, ED_ApplyActiveFlagToAdData, ED_RedrawAllRows, ED_RedrawRow, ED_TransformLineSpacing_Mode1, ED_TransformLineSpacing_Mode2, ED_TransformLineSpacing_Mode3,
;   ED_CommitCurrentAdEdits, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, GROUP_AL_JMPTBL_LADFUNC_GetLowNibble, GROUP_AL_JMPTBL_LADFUNC_GetHighNibble,
;   ED1_JMPTBL_LAB_0EE7, ED1_JMPTBL_LAB_0EE6, ED1_JMPTBL_MEM_Move,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_MATH_DivS32,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU
; READS:
;   LAB_21ED, LAB_21FA, LAB_21E1, LAB_21E8, LAB_21E9, LAB_21EB, LAB_21FB,
;   LAB_1D15, GLOB_REF_BOOL_IS_TEXT_OR_CURSOR, GLOB_REF_BOOL_IS_LINE_OR_PAGE
; WRITES:
;   LAB_1D15, LAB_21E1, LAB_21E8, LAB_21E9, LAB_21EA, LAB_21EE,
;   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR, GLOB_REF_BOOL_IS_LINE_OR_PAGE
; DESC:
;   Handles editor input commands: character changes, cursor movement, and
;   line/page operations.
; NOTES:
;   Switch-like chain on LAB_21ED and a secondary branch on LAB_21FA.
;------------------------------------------------------------------------------
ED_HandleEditorInput:
LAB_0678:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A2,-(A7)
    TST.L   LAB_1D15
    BEQ.S   .after_pending_init

    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1
    CLR.L   LAB_1D15

.after_pending_init:
    JSR     ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #1,D0
    BEQ.W   .case_enable_insert_mode

    SUBQ.W  #1,D0
    BEQ.W   .case_adjust_char_next

    SUBQ.W  #1,D0
    BEQ.W   .case_toggle_text_cursor

    SUBQ.W  #3,D0
    BEQ.W   .case_adjust_char_prev

    SUBQ.W  #2,D0
    BEQ.W   .case_backspace

    SUBQ.W  #1,D0
    BEQ.W   .finalize_update

    SUBQ.W  #4,D0
    BEQ.S   .case_page_down

    SUBQ.W  #1,D0
    BEQ.W   .case_disable_insert_mode

    SUBI.W  #13,D0
    BEQ.S   .case_force_text_mode

    SUBI.W  #$64,D0
    BEQ.W   .case_delete_at_cursor

    SUBI.W  #$1c,D0
    BEQ.W   .case_nav_key

    BRA.W   .case_insert_ascii_char

.case_force_text_mode:
    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,LAB_1D15
    JSR     ED_CommitCurrentAdEdits(PC)

    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   .return

.case_page_down:
    MOVE.L  LAB_21FB,D0
    MOVE.L  D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .page_down_clamp

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .finalize_update

.page_down_clamp:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .finalize_update

.case_enable_insert_mode:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21EA
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_disable_insert_mode:
    CLR.L   LAB_21EA
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_adjust_char_prev:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,16(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVE.L  D0,(A7)
    MOVE.L  16(A7),-(A7)
    JSR     ED1_JMPTBL_LAB_0EE7(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,LAB_21E1
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   .finalize_update

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   .finalize_update

.case_adjust_char_next:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_GetHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21E1,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     ED1_JMPTBL_LAB_0EE6(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,LAB_21E1
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   .finalize_update

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   .finalize_update

.case_toggle_text_cursor:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.S   .toggle_text_cursor_set0

    MOVEQ   #0,D1
    BRA.S   .toggle_text_cursor_apply

.toggle_text_cursor_set0:
    MOVE.L  D0,D1

.toggle_text_cursor_apply:
    MOVE.L  D1,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D1,-(A7)
    JSR     SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.case_backspace:
    TST.L   LAB_21E8
    BEQ.W   .finalize_update

    SUBQ.L  #1,LAB_21E8

.case_delete_at_cursor:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .delete_eol_refresh

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .delete_page_mode_update

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .delete_line_mode_update

    LEA     LAB_21F1,A0
    ADDA.L  D1,A0
    LEA     LAB_21F0,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F8,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F7,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.delete_line_mode_update:
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A0
    LEA     LAB_21F6,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.delete_page_mode_update:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    LEA     LAB_21F1,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    LEA     LAB_21F0,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F8,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F7,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21EE,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     LAB_21F7,A1
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A1
    LEA     LAB_21F6,A2
    ADDA.L  D0,A2
    MOVE.B  (A2),(A1)
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.W   .finalize_update

.delete_eol_refresh:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     ED_DrawCursorChar(PC)

    BRA.W   .finalize_update

.case_nav_key:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$20,D1
    BEQ.W   .case_handle_alt_code

    SUBI.W  #16,D1
    BEQ.W   .case_sync_cursor_line_page

    SUBQ.W  #1,D1
    BEQ.W   .case_toggle_line_page_mode

    SUBQ.W  #1,D1
    BEQ.W   .case_action_0831

    SUBQ.W  #1,D1
    BEQ.W   .case_action_0813

    SUBQ.W  #1,D1
    BEQ.W   .case_action_0822

    SUBQ.W  #1,D1
    BEQ.W   .case_clear_line_or_page

    SUBQ.W  #1,D1
    BEQ.W   .case_insert_row_shift

    SUBQ.W  #1,D1
    BEQ.W   .case_delete_row_shift

    SUBQ.W  #1,D1
    BEQ.W   .case_fill_row_chars

    SUBQ.W  #1,D1
    BEQ.W   .case_insert_char

    SUBQ.W  #6,D1
    BEQ.W   .case_enter_mode_9

    SUBQ.W  #2,D1
    BEQ.S   .nav_up_row

    SUBQ.W  #1,D1
    BEQ.S   .nav_down_row

    SUBQ.W  #1,D1
    BEQ.S   .nav_right

    SUBQ.W  #1,D1
    BEQ.S   .nav_left

    BRA.W   .finalize_update

.nav_up_row:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #39,D1
    CMP.L   D1,D0
    BLE.W   .finalize_update

    MOVEQ   #40,D1
    SUB.L   D1,LAB_21E8
    BRA.W   .finalize_update

.nav_down_row:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    ADD.L   D0,LAB_21E8
    BRA.W   .finalize_update

.nav_right:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    ADDQ.L  #1,LAB_21E8
    BRA.W   .finalize_update

.nav_left:
    MOVE.L  LAB_21E8,D0
    TST.L   D0
    BLE.W   .finalize_update

    SUBQ.L  #1,LAB_21E8
    BRA.W   .finalize_update

.case_handle_alt_code:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  2(A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .after_alt_code

    JSR     ED_NextAdNumber(PC)

.after_alt_code:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .finalize_update

    JSR     ED_PrevAdNumber(PC)

    BRA.W   .finalize_update

.case_enter_mode_9:
    MOVE.B  #$9,LAB_1D13
    JSR     ED_DrawEditHelpText(PC)

    BRA.W   .finalize_update

.case_sync_cursor_line_page:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE,D0
    BNE.S   .cursor_from_line_index

    CLR.L   LAB_21E8
    BRA.W   .finalize_update

.cursor_from_line_index:
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .finalize_update

.case_toggle_line_page_mode:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  GLOB_REF_BOOL_IS_LINE_OR_PAGE,D0
    ADDQ.L  #1,D0
    MOVEQ   #2,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BEQ.S   .select_line_page_label

    LEA     LAB_1D16,A0
    BRA.S   .draw_line_page_label

.select_line_page_label:
    LEA     LAB_1D17,A0

.draw_line_page_label:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    BRA.W   .finalize_update

.case_action_0831:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0831_reset

    JSR     ED_TransformLineSpacing_Mode3(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0831_reset:
    CLR.L   LAB_21E9

.action_0831_loop:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .action_0831_done

    JSR     ED_TransformLineSpacing_Mode3(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .action_0831_loop

.action_0831_done:
    CLR.L   LAB_21E8
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_action_0813:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0813_reset

    JSR     ED_TransformLineSpacing_Mode1(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0813_reset:
    CLR.L   LAB_21E9

.action_0813_loop:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .action_0813_done

    JSR     ED_TransformLineSpacing_Mode1(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .action_0813_loop

.action_0813_done:
    CLR.L   LAB_21E8
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_action_0822:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0822_reset

    JSR     ED_TransformLineSpacing_Mode2(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0822_reset:
    CLR.L   LAB_21E9

.action_0822_loop:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .action_0822_done

    JSR     ED_TransformLineSpacing_Mode2(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .action_0822_loop

.action_0822_done:
    CLR.L   LAB_21E8
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_clear_line_or_page:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .clear_page_setup

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.clear_line_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_line_space_loop
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.clear_line_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.clear_line_char_loop
    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.clear_page_setup:
    MOVE.L  LAB_21EB,D0
    MOVEQ   #32,D1
    LEA     LAB_21F0,A0
    BRA.S   .clear_page_space_check

.clear_page_space_loop:
    MOVE.B  D1,(A0)+

.clear_page_space_check:
    SUBQ.L  #1,D0
    BCC.S   .clear_page_space_loop

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   .clear_page_char_check

.clear_page_char_loop:
    MOVE.B  D0,(A0)+

.clear_page_char_check:
    SUBQ.L  #1,D1
    BCC.S   .clear_page_char_loop

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_row_shift:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.insert_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.insert_row_space_loop
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.insert_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.insert_row_char_loop
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

.insert_row_refresh_loop:
    CMP.L   LAB_21FB,D7
    BGE.W   .finalize_update

    MOVE.L  D7,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .insert_row_refresh_loop

.case_delete_row_shift:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVE.L  D1,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,12(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  12(A7),D0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  LAB_21E9,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.delete_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.delete_row_space_loop
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.delete_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.delete_row_char_loop
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

.delete_row_refresh_loop:
    CMP.L   LAB_21FB,D7
    BGE.W   .finalize_update

    MOVE.L  D7,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .delete_row_refresh_loop

.case_fill_row_chars:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .fill_page_chars

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.fill_row_chars_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.fill_row_chars_loop
    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.fill_page_chars:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   .fill_page_chars_check

.fill_page_chars_loop:
    MOVE.B  D0,(A0)+

.fill_page_chars_check:
    SUBQ.L  #1,D1
    BCC.S   .fill_page_chars_loop

    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_char:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .insert_char_eol

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .insert_char_page_update

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .insert_char_line_update

    LEA     LAB_21F0,A0
    ADDA.L  D1,A0
    LEA     LAB_21F1,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F8,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.insert_char_line_update:
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    MOVE.L  LAB_21E9,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.insert_char_page_update:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    LEA     LAB_21F1,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F8,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     LAB_21F7,A1
    ADDA.L  LAB_21E8,A1
    MOVE.B  LAB_21E1,(A1)
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.S   .finalize_update

.insert_char_eol:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     ED_DrawCursorChar(PC)

    BRA.S   .finalize_update

.case_insert_ascii_char:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #25,D1
    CMP.B   D1,D0
    BLS.S   .finalize_update

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #64,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BGE.S   .finalize_update

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    MOVE.B  D0,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    JSR     ED_DrawCursorChar(PC)

    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .finalize_update

    ADDQ.L  #1,LAB_21E8

.finalize_update:
    TST.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    BNE.S   .sync_current_char_from_buffer

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  LAB_21E1,(A1)
    BRA.S   .after_sync_current_char

.sync_current_char_from_buffer:
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1

.after_sync_current_char:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #4,D0
    BNE.S   .return

    JSR     ED_RedrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2/D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_EnterTextEditMode   (Enter text edit mode??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   ED_DrawAdEditingScreen, ED_RedrawAllRows, ED_RedrawCursorChar, ED_DrawCurrentColorIndicator
; READS:
;   LAB_21E8, LAB_21F7
; WRITES:
;   LAB_1D13
; DESC:
;   Switches to mode 4 and refreshes the edit display for the current entry.
; NOTES:
;   Uses LAB_21F7 + LAB_21E8 to fetch the current byte for display.
;------------------------------------------------------------------------------
ED_EnterTextEditMode:
LAB_06C0:
    MOVE.B  #$4,LAB_1D13
    JSR     ED_DrawAdEditingScreen(PC)

    JSR     ED_RedrawAllRows(PC)

    JSR     ED_RedrawCursorChar(PC)

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_CaptureKeySequence   (Capture key sequence??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/D7/A0-A1 ??
; CALLS:
;   LAB_09B2, GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   LAB_231C, LAB_231D, LAB_21A8, LAB_1D18, LAB_1D19
; WRITES:
;   LAB_1D18, LAB_1D19, LAB_1FB7, LAB_1FB8, LAB_1D13
; DESC:
;   Captures an input sequence and writes it into the LAB_1FB7/LAB_1FB8 buffers.
; NOTES:
;   Copies a 24-byte template from LAB_1D1A into the output buffer on completion.
;------------------------------------------------------------------------------
ED_CaptureKeySequence:
LAB_06C1:
    LINK.W  A5,#-28
    MOVE.L  D7,-(A7)
    LEA     LAB_1D1A,A0
    LEA     -25(A5),A1
    MOVEQ   #23,D0

.copy_template_to_stack:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_template_to_stack
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    LEA     LAB_21A8,A0
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.S   .no_capture_flag

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_09B2(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    TST.L   LAB_1D18
    BNE.S   .have_pending_capture

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,LAB_1D19
    BRA.S   .advance_capture_slot

.have_pending_capture:
    MOVE.L  LAB_1D19,D0
    TST.L   D0
    BMI.S   .invalidate_capture

    MOVEQ   #8,D1
    CMP.L   D1,D0
    BGE.S   .invalidate_capture

    MOVEQ   #13,D1
    CMP.B   D1,D7
    BCC.S   .invalidate_capture

    LSL.L   #2,D0
    SUB.L   LAB_1D19,D0
    MOVE.L  LAB_1D18,D1
    ADD.L   D1,D0
    LEA     LAB_1FB7,A0
    ADDA.L  D0,A0
    MOVE.B  D7,(A0)
    BRA.S   .advance_capture_slot

.invalidate_capture:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1D19
    BRA.S   .advance_capture_slot

.no_capture_flag:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1D19

.advance_capture_slot:
    MOVE.L  LAB_1D18,D0
    ADDQ.L  #1,D0
    MOVEQ   #4,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,LAB_1D18
    BNE.S   .return

    MOVE.L  LAB_1D19,D0
    TST.L   D0
    BPL.S   .finish_capture

    CLR.L   LAB_1D19

.copy_buffer_loop:
    MOVE.L  LAB_1D19,D0
    MOVEQ   #24,D1
    CMP.L   D1,D0
    BGE.S   .finish_capture

    LEA     LAB_1FB8,A0
    ADDA.L  D0,A0
    MOVE.B  -25(A5,D0.L),(A0)
    ADDQ.L  #1,LAB_1D19
    BRA.S   .copy_buffer_loop

.finish_capture:
    CLR.B   LAB_1D13

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_FindNextCharInTable   (Find next char in table??)
; ARGS:
;   stack +4: u8 currentChar ??
;   stack +8: char* table
; RET:
;   D0: u8 nextChar ??
; CLOBBERS:
;   D0/A0/A3 ??
; CALLS:
;   LAB_05C1
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Finds the next non-null byte in a lookup table given a starting char.
; NOTES:
;   If the lookup returns null, it falls back to the table base.
;------------------------------------------------------------------------------
ED_FindNextCharInTable:
LAB_06CA:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .use_base_ptr

    ADDQ.L  #1,-4(A5)
    BRA.S   .ensure_nonzero

.use_base_ptr:
    MOVE.L  A3,-4(A5)

.ensure_nonzero:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BNE.S   .return_char

    MOVE.L  A3,-4(A5)

.return_char:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleDiagnosticNibbleEdit   (Handle diagnostic nibble edits??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A1 ??
; CALLS:
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU, ED1_JMPTBL_LAB_0CA7, ED_DrawDiagnosticRegisterValues
; READS:
;   LAB_21ED, LAB_21EE, LAB_231C, LAB_231D
; WRITES:
;   LAB_21EE, LAB_21FA, LAB_1DE0, LAB_1DE1, LAB_1DE2
; DESC:
;   Adjusts per-entry nibble values and selection index, then refreshes display.
; NOTES:
;   Wraps nibble values in the 0..15 range.
;------------------------------------------------------------------------------
ED_HandleDiagnosticNibbleEdit:
LAB_06CE:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   .case_show_help

    SUBI.W  #14,D0
    BEQ.S   .case_show_help

    SUBI.W  #$27,D0
    BEQ.W   .case_inc_table2

    SUBQ.W  #5,D0
    BEQ.W   .case_inc_table1

    SUBI.W  #11,D0
    BEQ.S   .case_inc_table0

    SUBI.W  #16,D0
    BEQ.W   .case_dec_table2

    SUBQ.W  #5,D0
    BEQ.W   .case_dec_table1

    SUBI.W  #11,D0
    BEQ.S   .case_dec_table0

    SUBI.W  #$29,D0
    BEQ.W   .case_adjust_index

    BRA.W   .case_increment_index

.case_show_help:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   .return

.case_inc_table0:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   .after_index_update

.case_dec_table0:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table1:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   .after_index_update

.case_dec_table1:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table2:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.S   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.S   .after_index_update

.case_dec_table2:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.S   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.S   .after_index_update

.case_adjust_index:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_index

    SUBQ.L  #1,LAB_21EE
    BGE.S   .after_index_update

    MOVEQ   #39,D0
    MOVE.L  D0,LAB_21EE
    BRA.S   .after_index_update

.case_increment_index:
    ADDQ.L  #1,LAB_21EE
    MOVEQ   #40,D0
    CMP.L   LAB_21EE,D0
    BNE.S   .after_index_update

    CLR.L   LAB_21EE

.after_index_update:
    MOVE.L  LAB_21EE,D0
    TST.L   D0
    BMI.S   .skip_refresh

    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .skip_refresh

    JSR     ED1_JMPTBL_LAB_0CA7(PC)

.skip_refresh:
    JSR     ED_DrawDiagnosticRegisterValues(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleSpecialFunctionsMenu   (Handle ESC special functions menu??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D3/D7/A0-A1/A6 ??
; CALLS:
;   ED_GetEscMenuActionCode, ED_DrawAreYouSurePrompt, ED_DrawMenuSelectionHighlight, ED_DrawDiagnosticRegisterValues,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU, DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVORectFill
; READS:
;   LAB_21E8, LAB_1D13
; WRITES:
;   LAB_1D13, LAB_21E8, LAB_21EE
; DESC:
;   Dispatches ESC special-functions menu selection and updates display state.
; NOTES:
;   Uses a switch/jumptable on the key code returned by ED_GetEscMenuActionCode.
;------------------------------------------------------------------------------
ED_HandleSpecialFunctionsMenu:
LAB_06DB:
    MOVEM.L D2-D3/D7,-(A7)
    JSR     ED_GetEscMenuActionCode(PC)

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
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   .return

.case_show_label_1d1b:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     LAB_1D1B
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$b,LAB_1D13

    BRA.W   .return

.case_show_label_1d1c:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     LAB_1D1C
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$c,LAB_1D13
    BRA.W   .return

.case_show_label_1d1d:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     LAB_1D1D
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$d,LAB_1D13
    BRA.W   .return

.case_show_reboot_warning:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     GLOB_STR_COMPUTER_WILL_RESET
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_GO_OFF_AIR_FOR_1_2_MINS
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.B  #$e,LAB_1D13
    BRA.W   .return

.case_prev_special_selection:
    SUBQ.L  #1,LAB_21E8
    BGE.S   .redraw_special_menu

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_21E8

.redraw_special_menu:
    PEA     4.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_draw_color_bars:
    MOVEQ   #2,D0
    CMP.L   LAB_21E8,D0
    BNE.W   .case_next_special_selection

    MOVE.B  #$f,LAB_1D13

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVEQ   #115,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVEQ   #95,D2
    ADD.L   D2,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #265,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #340,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #415,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$1ea,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$235,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$280,D2
    JSR     _LVORectFill(A6)

    CLR.L   LAB_21EE
    JSR     ED_DrawDiagnosticRegisterValues(PC)

    BRA.S   .return

.case_next_special_selection:
    ADDQ.L  #1,LAB_21E8
    MOVEQ   #4,D0
    CMP.L   LAB_21E8,D0
    BNE.S   .after_selection_wrap

    CLR.L   LAB_21E8

.after_selection_wrap:
    MOVE.L  D0,-(A7)
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_SaveEverythingToDisk   (Save everything to disk??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D7/A0-A1/A6 ??
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, LAB_0484,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving EVERYTHING to disk" and triggers a save operation.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_SaveEverythingToDisk:
; Print 'Saving "EVERYTHING" to disk'
LAB_06E2:
    MOVE.L  D7,-(A7)
    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_everything_message

    PEA     GLOB_STR_SAVING_EVERYTHING_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     LAB_0484(PC)

    LEA     20(A7),A7

.after_save_everything_message:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_SavePrevueDataToDisk   (Save Prevue data to disk??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D7/A0-A1/A6 ??
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, LAB_0471,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving Prevue data to disk" and triggers the save routine.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_SavePrevueDataToDisk:
LAB_06E4:
    MOVE.L  D7,-(A7)
    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_prevue_message

    PEA     GLOB_STR_SAVING_PREVUE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     LAB_0471(PC)

    LEA     16(A7),A7

.after_save_prevue_message:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_LoadTextAdsFromDh2   (Load text ads from DH2??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D7/A0-A1/A6 ??
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, ESQ_JMPTBL_LAB_0E57,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a loading message and invokes the text-ads load routine.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_LoadTextAdsFromDh2:
LAB_06E6:
    MOVE.L  D7,-(A7)

    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_load_text_ads

    PEA     GLOB_STR_LOADING_TEXT_ADS_FROM_DH2
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQ_JMPTBL_LAB_0E57(PC)

    LEA     16(A7),A7

.after_load_text_ads:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RebootComputer   (Reboot computer??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D6-D7/A0-A1/A6 ??
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, ED1_JMPTBL_ESQ_ColdReboot,
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a reboot message, delays briefly, and triggers a cold reboot.
; NOTES:
;   Skips display/reboot if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_RebootComputer:
; display 'rebooting computer' while requesting a reboot through supervisor?
LAB_06E8:
    MOVEM.L D6-D7,-(A7)

    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_reboot

    PEA     GLOB_STR_REBOOTING_COMPUTER     ; string
    PEA     120.W                           ; y
    PEA     40.W                            ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

.delay_loop:
    CMPI.L  #$aae60,D6
    BGE.S   .trigger_reboot

    ADDQ.L  #1,D6
    ADDQ.L  #1,D6
    BRA.S   .delay_loop

.trigger_reboot:
    JSR     ED1_JMPTBL_ESQ_ColdReboot(PC)

.after_reboot:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditAttributesMenu   (Handle edit attributes menu??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D4/A0-A1/A6 ??
; CALLS:
;   ED_DrawCursorChar, ED_RedrawCursorChar, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, ED_DrawAdEditingScreen, ED_LoadCurrentAdIntoBuffers,
;   ED_DrawHelpPanels, ED_UpdateAdNumberDisplay, DISPLIB_DisplayTextAtPosition,
;   GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_MATH_DivS32,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   LAB_21ED, LAB_21E8, LAB_21F2, LAB_21F3, LAB_21FD, LAB_1D13
; WRITES:
;   LAB_21E8, LAB_21F0, LAB_1D13, LAB_21E4, GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Handles edit-attributes input, updating the buffer and selected ad number.
; NOTES:
;   Accepts numeric keys and special menu codes (e.g., $8E).
;------------------------------------------------------------------------------
ED_HandleEditAttributesMenu:
; Draw 'Edit Attributes' menu
LAB_06EC:
    MOVEM.L D2-D4,-(A7)
    JSR     ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #8,D0
    BEQ.S   .case_backspace

    SUBQ.W  #5,D0
    BEQ.S   .case_commit_ad_number

    SUBI.W  #$8e,D0
    BEQ.S   .case_nav_key

    BRA.W   .case_digit_input

.case_backspace:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #12,D1
    CMP.L   D1,D0
    BLE.S   .after_backspace

    SUBQ.L  #1,LAB_21E8
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  #$20,(A0)

.after_backspace:
    JSR     ED_DrawCursorChar(PC)

    BRA.W   .refresh_attribute_display

.case_nav_key:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #67,D1
    CMP.B   D1,D0
    BNE.S   .after_nav_key

    MOVEQ   #13,D1
    MOVE.L  D1,LAB_21E8
    BRA.W   .refresh_attribute_display

.after_nav_key:
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.W   .refresh_attribute_display

    MOVEQ   #12,D0
    MOVE.L  D0,LAB_21E8
    BRA.W   .refresh_attribute_display

.case_commit_ad_number:
    MOVE.B  LAB_21F2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .ad_second_blank

    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BEQ.S   .ad_both_blank

    MOVEQ   #0,D3
    MOVE.B  D2,D3
    MOVEQ   #48,D4
    SUB.L   D4,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_both_blank:
    MOVEQ   #1,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_second_blank:
    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BNE.S   .ad_two_digits

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D3
    SUB.L   D3,D1
    MOVE.L  D1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_two_digits:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVEQ   #10,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  D2,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER

.ad_number_ready:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   LAB_21FD,D0
    BLE.S   .ad_number_in_range

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D24
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_in_range:
    TST.L   D0
    BNE.S   .ad_number_mode2

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D25
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_mode2:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #2,D0
    BNE.S   .ad_number_other_mode

    MOVE.B  #$4,LAB_1D13
    JSR     ED_DrawAdEditingScreen(PC)

    JSR     ED_LoadCurrentAdIntoBuffers(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    BRA.W   .return

.ad_number_other_mode:
    MOVE.B  #$5,LAB_1D13
    PEA     6.W
    JSR     ED_DrawHelpPanels(PC)

    JSR     ED_UpdateAdNumberDisplay(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D26
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1D27
    PEA     360.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1D28
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     52(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .return

.case_digit_input:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BCS.S   .refresh_attribute_display

    MOVEQ   #57,D1
    CMP.B   D1,D0
    BHI.S   .refresh_attribute_display

    JSR     ED_DrawCursorChar(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  LAB_21ED,(A0)
    CMPI.L  #$d,LAB_21E8
    BGE.S   .refresh_attribute_display

    JSR     ED_DrawCursorChar(PC)

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    ADDQ.L  #1,LAB_21E8
    MOVE.B  LAB_21ED,(A0)

.refresh_attribute_display:
    JSR     ED_RedrawCursorChar(PC)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditAttributesInput   (Handle edit attributes input??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0-A1 ??
; CALLS:
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU, ED_IncrementAdNumber, ED_DecrementAdNumber, LAB_095F, ED_ApplyActiveFlagToAdData,
;   ED_UpdateActiveInactiveIndicator
; READS:
;   LAB_21ED, LAB_21EA, LAB_231C, LAB_231D
; WRITES:
;   LAB_21EA, LAB_21E4, LAB_21FE
; DESC:
;   Processes edit-attribute key codes and commits changes to state variables.
; NOTES:
;   Recognizes key code $80 with modifier bytes to trigger ED_IncrementAdNumber/ED_DecrementAdNumber.
;------------------------------------------------------------------------------
ED_HandleEditAttributesInput:
LAB_06FC:
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   .case_show_help

    SUBI.W  #14,D0
    BEQ.S   .case_show_help

    SUBI.W  #$80,D0
    BNE.S   .case_adjust_21ea

    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D1
    CMP.B   1(A1),D1
    BNE.S   .return

    ADDA.L  D0,A0
    MOVEQ   #64,D0
    CMP.B   2(A0),D0
    BNE.S   .case_special_65

    JSR     ED_IncrementAdNumber(PC)

    BRA.S   .return

.case_special_65:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVEQ   #65,D0
    CMP.B   2(A0),D0
    BNE.S   .return

    JSR     ED_DecrementAdNumber(PC)

    BRA.S   .return

.case_show_help:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.S   .return

.case_adjust_21ea:
    MOVE.L  LAB_21EA,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_095F(PC)

    ADDQ.W  #4,A7
    EXT.L   D0
    MOVE.L  D0,LAB_21EA
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21FE

.return:
    JSR     ED_UpdateActiveInactiveIndicator(PC)

    RTS
