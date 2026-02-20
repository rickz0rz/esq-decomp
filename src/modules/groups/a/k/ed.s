    XDEF    ED_CaptureKeySequence
    XDEF    ED_DispatchEscMenuState
    XDEF    ED_EnterTextEditMode
    XDEF    ED_FindNextCharInTable
    XDEF    ED_HandleDiagnosticNibbleEdit
    XDEF    ED_HandleEditAttributesInput
    XDEF    ED_HandleEditAttributesMenu
    XDEF    ED_HandleEditorInput
    XDEF    ED_HandleSpecialFunctionsMenu
    XDEF    ED_LoadTextAdsFromDh2
    XDEF    ED_RebootComputer
    XDEF    ED_SaveEverythingToDisk
    XDEF    ED_SavePrevueDataToDisk

;------------------------------------------------------------------------------
; FUNC: ED_DispatchEscMenuState   (Dispatch ESC menu stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/D0/D1
; CALLS:
;   ED2_HandleMenuActions, ED1_HandleEscMenuInput, ED1_UpdateEscMenuSelection,
;   ED2_HandleScrollSpeedSelection, ED2_HandleDiagnosticsMenuActions,
;   ED_EnterTextEditMode, ED_CaptureKeySequence, ED_HandleDiagnosticNibbleEdit,
;   ED_HandleSpecialFunctionsMenu, ED_SaveEverythingToDisk, ED_SavePrevueDataToDisk,
;   ED_LoadTextAdsFromDh2, ED_RebootComputer, ED_HandleEditAttributesMenu,
;   ED_HandleEditAttributesInput, ED_HandleEditorInput,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   ED_StateRingIndex, ED_StateRingWriteIndex, DATA_DST_CONST_LONG_1D14, ED_MenuStateId, Global_UIBusyFlag
; WRITES:
;   DATA_DST_CONST_LONG_1D14, ED_LastKeyCode, ED_StateRingIndex
; DESC:
;   Dispatches ESC-menu state handlers based on ED_MenuStateId using a jumptable.
; NOTES:
;   Increments ED_StateRingIndex modulo $14 after each dispatch.
;------------------------------------------------------------------------------
ED_DispatchEscMenuState:
    MOVE.L  ED_StateRingIndex,D0
    MOVE.L  ED_StateRingWriteIndex,D1
    CMP.L   D0,D1
    BEQ.W   .lab_0677

    TST.L   DATA_DST_CONST_LONG_1D14
    BEQ.W   .lab_0677

    CLR.L   DATA_DST_CONST_LONG_1D14
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),ED_LastKeyCode
    TST.W   Global_UIBusyFlag
    BEQ.S   .after_pen_setup

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

.after_pen_setup:
    MOVE.B  ED_MenuStateId,D0
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
    ADDQ.L  #1,ED_StateRingIndex
    CMPI.L  #$14,ED_StateRingIndex
    BLT.S   .after_wrap_index

    CLR.L   ED_StateRingIndex

.after_wrap_index:
    MOVEQ   #1,D0
    MOVE.L  D0,DATA_DST_CONST_LONG_1D14

.lab_0677:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditorInput   (Handle editor inputuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D7
; CALLS:
;   ED_DrawCursorChar, ED_ApplyActiveFlagToAdData, ED_RedrawAllRows, ED_RedrawRow, ED_TransformLineSpacing_Mode1, ED_TransformLineSpacing_Mode2, ED_TransformLineSpacing_Mode3,
;   ED_CommitCurrentAdEdits, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble,
;   ED1_JMPTBL_LADFUNC_MergeHighLowNibbles, ED1_JMPTBL_LADFUNC_PackNibblesToByte, ED1_JMPTBL_MEM_Move,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_MATH_DivS32,
;   ED_DrawESCMenuBottomHelp
; READS:
;   ED_LastKeyCode, ED_LastMenuInputChar, ED_CurrentChar, ED_EditCursorOffset, ED_ViewportOffset, ED_BlockOffset, ED_TextLimit,
;   DATA_DST_CONST_LONG_1D15, Global_REF_BOOL_IS_TEXT_OR_CURSOR, Global_REF_BOOL_IS_LINE_OR_PAGE
; WRITES:
;   DATA_DST_CONST_LONG_1D15, ED_CurrentChar, ED_EditCursorOffset, ED_ViewportOffset, ED_AdActiveFlag, ED_TempCopyOffset,
;   Global_REF_BOOL_IS_TEXT_OR_CURSOR, Global_REF_BOOL_IS_LINE_OR_PAGE
; DESC:
;   Handles editor input commands: character changes, cursor movement, and
;   line/page operations.
; NOTES:
;   Switch-like chain on ED_LastKeyCode and a secondary branch on ED_LastMenuInputChar.
;------------------------------------------------------------------------------
ED_HandleEditorInput:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A2,-(A7)
    TST.L   DATA_DST_CONST_LONG_1D15
    BEQ.S   .after_pending_init

    MOVEQ   #1,D0
    MOVE.L  D0,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),ED_CurrentChar
    CLR.L   DATA_DST_CONST_LONG_1D15

.after_pending_init:
    JSR     ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
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
    MOVE.L  D0,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,DATA_DST_CONST_LONG_1D15
    JSR     ED_CommitCurrentAdEdits(PC)

    JSR     ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_page_down:
    MOVE.L  ED_TextLimit,D0
    MOVE.L  D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .page_down_clamp

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_EditCursorOffset
    BRA.W   .finalize_update

.page_down_clamp:
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_EditCursorOffset
    BRA.W   .finalize_update

.case_enable_insert_mode:
    MOVEQ   #1,D0
    MOVE.L  D0,ED_AdActiveFlag
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_disable_insert_mode:
    CLR.L   ED_AdActiveFlag
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_adjust_char_prev:
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,16(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

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
    JSR     ED1_JMPTBL_LADFUNC_MergeHighLowNibbles(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,ED_CurrentChar
    MOVEQ   #1,D0
    CMP.L   Global_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   .finalize_update

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    BRA.W   .finalize_update

.case_adjust_char_next:
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    MOVE.B  ED_CurrentChar,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     ED1_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,ED_CurrentChar
    MOVEQ   #1,D0
    CMP.L   Global_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   .finalize_update

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    BRA.W   .finalize_update

.case_toggle_text_cursor:
    MOVEQ   #1,D0
    CMP.L   Global_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.S   .toggle_text_cursor_set0

    MOVEQ   #0,D1
    BRA.S   .toggle_text_cursor_apply

.toggle_text_cursor_set0:
    MOVE.L  D0,D1

.toggle_text_cursor_apply:
    MOVE.L  D1,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D1,-(A7)
    JSR     SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.case_backspace:
    TST.L   ED_EditCursorOffset
    BEQ.W   .finalize_update

    SUBQ.L  #1,ED_EditCursorOffset

.case_delete_at_cursor:
    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .delete_eol_refresh

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .delete_page_mode_update

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,ED_TempCopyOffset
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .delete_line_mode_update

    LEA     ED_EditBufferScratchShiftBase,A0
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratch,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLiveShiftBase,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLive,A1
    ADDA.L  D0,A1
    MOVE.L  ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.delete_line_mode_update:
    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_TempCopyOffset,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     ED_EditBufferLive,A0
    MOVE.L  ED_TempCopyOffset,D0
    ADDA.L  D0,A0
    LEA     DATA_WDISP_BSS_BYTE_21F6,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.delete_page_mode_update:
    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,ED_TempCopyOffset
    LEA     ED_EditBufferScratchShiftBase,A0
    MOVE.L  ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratch,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLiveShiftBase,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLive,A1
    ADDA.L  D0,A1
    MOVE.L  ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_TempCopyOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     ED_EditBufferLive,A1
    MOVE.L  ED_TempCopyOffset,D0
    ADDA.L  D0,A1
    LEA     DATA_WDISP_BSS_BYTE_21F6,A2
    ADDA.L  D0,A2
    MOVE.B  (A2),(A1)
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.W   .finalize_update

.delete_eol_refresh:
    LEA     DATA_WDISP_BSS_BYTE_21EF,A0
    ADDA.L  ED_BlockOffset,A0
    MOVE.B  #$20,(A0)
    JSR     ED_DrawCursorChar(PC)

    BRA.W   .finalize_update

.case_nav_key:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,ED_LastMenuInputChar
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
    MOVE.L  ED_EditCursorOffset,D0
    MOVEQ   #39,D1
    CMP.L   D1,D0
    BLE.W   .finalize_update

    MOVEQ   #40,D1
    SUB.L   D1,ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_down_row:
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    ADD.L   D0,ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_right:
    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    ADDQ.L  #1,ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_left:
    MOVE.L  ED_EditCursorOffset,D0
    TST.L   D0
    BLE.W   .finalize_update

    SUBQ.L  #1,ED_EditCursorOffset
    BRA.W   .finalize_update

.case_handle_alt_code:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  2(A0),D0
    MOVE.B  D0,ED_LastKeyCode
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .after_alt_code

    JSR     ED_NextAdNumber(PC)

.after_alt_code:
    MOVE.B  ED_LastKeyCode,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .finalize_update

    JSR     ED_PrevAdNumber(PC)

    BRA.W   .finalize_update

.case_enter_mode_9:
    MOVE.B  #$9,ED_MenuStateId
    JSR     ED_DrawEditHelpText(PC)

    BRA.W   .finalize_update

.case_sync_cursor_line_page:
    MOVEQ   #1,D0
    CMP.L   Global_REF_BOOL_IS_LINE_OR_PAGE,D0
    BNE.S   .cursor_from_line_index

    CLR.L   ED_EditCursorOffset
    BRA.W   .finalize_update

.cursor_from_line_index:
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_EditCursorOffset
    BRA.W   .finalize_update

.case_toggle_line_page_mode:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  Global_REF_BOOL_IS_LINE_OR_PAGE,D0
    ADDQ.L  #1,D0
    MOVEQ   #2,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,Global_REF_BOOL_IS_LINE_OR_PAGE
    BEQ.S   .select_line_page_label

    LEA     DATA_ED2_STR_PAGE_1D16,A0
    BRA.S   .draw_line_page_label

.select_line_page_label:
    LEA     DATA_ED2_STR_LINE_1D17,A0

.draw_line_page_label:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    BRA.W   .finalize_update

.case_action_0831:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0831_reset

    JSR     ED_TransformLineSpacing_Mode3(PC)

    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0831_reset:
    CLR.L   ED_ViewportOffset

.action_0831_loop:
    MOVE.L  ED_ViewportOffset,D0
    CMP.L   ED_TextLimit,D0
    BGE.S   .action_0831_done

    JSR     ED_TransformLineSpacing_Mode3(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0831_loop

.action_0831_done:
    CLR.L   ED_EditCursorOffset
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_action_0813:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0813_reset

    JSR     ED_TransformLineSpacing_Mode1(PC)

    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0813_reset:
    CLR.L   ED_ViewportOffset

.action_0813_loop:
    MOVE.L  ED_ViewportOffset,D0
    CMP.L   ED_TextLimit,D0
    BGE.S   .action_0813_done

    JSR     ED_TransformLineSpacing_Mode1(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0813_loop

.action_0813_done:
    CLR.L   ED_EditCursorOffset
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_action_0822:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .action_0822_reset

    JSR     ED_TransformLineSpacing_Mode2(PC)

    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.action_0822_reset:
    CLR.L   ED_ViewportOffset

.action_0822_loop:
    MOVE.L  ED_ViewportOffset,D0
    CMP.L   ED_TextLimit,D0
    BGE.S   .action_0822_done

    JSR     ED_TransformLineSpacing_Mode2(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0822_loop

.action_0822_done:
    CLR.L   ED_EditCursorOffset
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_clear_line_or_page:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .clear_page_setup

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.clear_line_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_line_space_loop
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.clear_line_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.clear_line_char_loop
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.clear_page_setup:
    MOVE.L  ED_BlockOffset,D0
    MOVEQ   #32,D1
    LEA     ED_EditBufferScratch,A0
    BRA.S   .clear_page_space_check

.clear_page_space_loop:
    MOVE.B  D1,(A0)+

.clear_page_space_check:
    SUBQ.L  #1,D0
    BCC.S   .clear_page_space_loop

    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  ED_BlockOffset,D1
    LEA     ED_EditBufferLive,A0
    BRA.S   .clear_page_char_check

.clear_page_char_loop:
    MOVE.B  D0,(A0)+

.clear_page_char_check:
    SUBQ.L  #1,D1
    BCC.S   .clear_page_char_loop

    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_row_shift:
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_ViewportOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.insert_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.insert_row_space_loop
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.insert_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.insert_row_char_loop
    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    MOVE.L  ED_ViewportOffset,D7

.insert_row_refresh_loop:
    CMP.L   ED_TextLimit,D7
    BGE.W   .finalize_update

    MOVE.L  D7,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .insert_row_refresh_loop

.case_delete_row_shift:
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_ViewportOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVE.L  D1,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,12(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  12(A7),D0
    MOVE.L  ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  ED_ViewportOffset,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    MOVE.L  ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.delete_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.delete_row_space_loop
    MOVE.L  ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.delete_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.delete_row_char_loop
    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    MOVE.L  ED_ViewportOffset,D7

.delete_row_refresh_loop:
    CMP.L   ED_TextLimit,D7
    BGE.W   .finalize_update

    MOVE.L  D7,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .delete_row_refresh_loop

.case_fill_row_chars:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .fill_page_chars

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.fill_row_chars_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.fill_row_chars_loop
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.fill_page_chars:
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  ED_BlockOffset,D1
    LEA     ED_EditBufferLive,A0
    BRA.S   .fill_page_chars_check

.fill_page_chars_loop:
    MOVE.B  D0,(A0)+

.fill_page_chars_check:
    SUBQ.L  #1,D1
    BCC.S   .fill_page_chars_loop

    JSR     ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_char:
    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .insert_char_eol

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .insert_char_page_update

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,ED_TempCopyOffset
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .insert_char_line_update

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratchShiftBase,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLive,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLiveShiftBase,A1
    ADDA.L  D0,A1
    MOVE.L  ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.insert_char_line_update:
    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.insert_char_page_update:
    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,ED_TempCopyOffset
    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratchShiftBase,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLive,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLiveShiftBase,A1
    ADDA.L  D0,A1
    MOVE.L  ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_EditCursorOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     ED_EditBufferLive,A1
    ADDA.L  ED_EditCursorOffset,A1
    MOVE.B  ED_CurrentChar,(A1)
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.S   .finalize_update

.insert_char_eol:
    LEA     DATA_WDISP_BSS_BYTE_21EF,A0
    ADDA.L  ED_BlockOffset,A0
    MOVE.B  #$20,(A0)
    JSR     ED_DrawCursorChar(PC)

    BRA.S   .finalize_update

.case_insert_ascii_char:
    MOVE.B  ED_LastKeyCode,D0
    MOVEQ   #25,D1
    CMP.B   D1,D0
    BLS.S   .finalize_update

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #64,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BGE.S   .finalize_update

    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    MOVE.B  D0,(A0)
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    JSR     ED_DrawCursorChar(PC)

    MOVE.L  ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .finalize_update

    ADDQ.L  #1,ED_EditCursorOffset

.finalize_update:
    TST.L   Global_REF_BOOL_IS_TEXT_OR_CURSOR
    BNE.S   .sync_current_char_from_buffer

    LEA     ED_EditBufferLive,A0
    MOVE.L  ED_EditCursorOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  ED_CurrentChar,(A1)
    BRA.S   .after_sync_current_char

.sync_current_char_from_buffer:
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),ED_CurrentChar

.after_sync_current_char:
    MOVE.B  ED_MenuStateId,D0
    SUBQ.B  #4,D0
    BNE.S   .return

    JSR     ED_RedrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  D0,-(A7)
    JSR     ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2/D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_EnterTextEditMode   (Enter text edit modeuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   ED_DrawAdEditingScreen, ED_RedrawAllRows, ED_RedrawCursorChar, ED_DrawCurrentColorIndicator
; READS:
;   ED_EditCursorOffset, ED_EditBufferLive
; WRITES:
;   ED_MenuStateId
; DESC:
;   Switches to mode 4 and refreshes the edit display for the current entry.
; NOTES:
;   Uses ED_EditBufferLive + ED_EditCursorOffset to fetch the current byte for display.
;------------------------------------------------------------------------------
ED_EnterTextEditMode:
    MOVE.B  #$4,ED_MenuStateId
    JSR     ED_DrawAdEditingScreen(PC)

    JSR     ED_RedrawAllRows(PC)

    JSR     ED_RedrawCursorChar(PC)

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_CaptureKeySequence   (Capture key sequenceuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit, GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   ED_StateRingIndex, ED_StateRingTable, WDISP_CharClassTable, DATA_ED2_BSS_LONG_1D18, DATA_ED2_BSS_LONG_1D19
; WRITES:
;   DATA_ED2_BSS_LONG_1D18, DATA_ED2_BSS_LONG_1D19, DATA_KYBD_BSS_BYTE_1FB7, DATA_KYBD_BSS_BYTE_1FB8, ED_MenuStateId
; DESC:
;   Captures an input sequence and writes it into the DATA_KYBD_BSS_BYTE_1FB7/DATA_KYBD_BSS_BYTE_1FB8 buffers.
; NOTES:
;   Copies a 24-byte template from DATA_ED2_CONST_LONG_1D1A into the output buffer on completion.
;------------------------------------------------------------------------------
ED_CaptureKeySequence:
    LINK.W  A5,#-28
    MOVE.L  D7,-(A7)
    LEA     DATA_ED2_CONST_LONG_1D1A,A0
    LEA     -25(A5),A1
    MOVEQ   #23,D0

.copy_template_to_stack:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_template_to_stack
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.S   .no_capture_flag

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    TST.L   DATA_ED2_BSS_LONG_1D18
    BNE.S   .have_pending_capture

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,DATA_ED2_BSS_LONG_1D19
    BRA.S   .advance_capture_slot

.have_pending_capture:
    MOVE.L  DATA_ED2_BSS_LONG_1D19,D0
    TST.L   D0
    BMI.S   .invalidate_capture

    MOVEQ   #8,D1
    CMP.L   D1,D0
    BGE.S   .invalidate_capture

    MOVEQ   #13,D1
    CMP.B   D1,D7
    BCC.S   .invalidate_capture

    LSL.L   #2,D0
    SUB.L   DATA_ED2_BSS_LONG_1D19,D0
    MOVE.L  DATA_ED2_BSS_LONG_1D18,D1
    ADD.L   D1,D0
    LEA     DATA_KYBD_BSS_BYTE_1FB7,A0
    ADDA.L  D0,A0
    MOVE.B  D7,(A0)
    BRA.S   .advance_capture_slot

.invalidate_capture:
    MOVEQ   #-1,D0
    MOVE.L  D0,DATA_ED2_BSS_LONG_1D19
    BRA.S   .advance_capture_slot

.no_capture_flag:
    MOVEQ   #-1,D0
    MOVE.L  D0,DATA_ED2_BSS_LONG_1D19

.advance_capture_slot:
    MOVE.L  DATA_ED2_BSS_LONG_1D18,D0
    ADDQ.L  #1,D0
    MOVEQ   #4,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,DATA_ED2_BSS_LONG_1D18
    BNE.S   .return

    MOVE.L  DATA_ED2_BSS_LONG_1D19,D0
    TST.L   D0
    BPL.S   .finish_capture

    CLR.L   DATA_ED2_BSS_LONG_1D19

.copy_buffer_loop:
    MOVE.L  DATA_ED2_BSS_LONG_1D19,D0
    MOVEQ   #24,D1
    CMP.L   D1,D0
    BGE.S   .finish_capture

    LEA     DATA_KYBD_BSS_BYTE_1FB8,A0
    ADDA.L  D0,A0
    MOVE.B  -25(A5,D0.L),(A0)
    ADDQ.L  #1,DATA_ED2_BSS_LONG_1D19
    BRA.S   .copy_buffer_loop

.finish_capture:
    CLR.B   ED_MenuStateId

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_FindNextCharInTable   (Find next char in tableuncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   GROUP_AI_JMPTBL_STR_FindCharPtr
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
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

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
; FUNC: ED_HandleDiagnosticNibbleEdit   (Handle diagnostic nibble editsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2
; CALLS:
;   ED_DrawESCMenuBottomHelp, ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp, ED_DrawDiagnosticRegisterValues
; READS:
;   ED_LastKeyCode, ED_TempCopyOffset, ED_StateRingIndex, ED_StateRingTable
; WRITES:
;   ED_TempCopyOffset, ED_LastMenuInputChar, DATA_ESQ_BSS_BYTE_1DE0, DATA_ESQ_BSS_BYTE_1DE1, DATA_ESQ_CONST_BYTE_1DE2
; DESC:
;   Adjusts per-entry nibble values and selection index, then refreshes display.
; NOTES:
;   Wraps nibble values in the 0..15 range.
;------------------------------------------------------------------------------
ED_HandleDiagnosticNibbleEdit:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
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
    JSR     ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_inc_table0:
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_BSS_BYTE_1DE0,A0
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
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_BSS_BYTE_1DE0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table1:
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_BSS_BYTE_1DE1,A0
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
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_BSS_BYTE_1DE1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table2:
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_CONST_BYTE_1DE2,A0
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
    MOVE.L  ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   ED_TempCopyOffset,D0
    LEA     DATA_ESQ_CONST_BYTE_1DE2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.S   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.S   .after_index_update

.case_adjust_index:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,ED_LastMenuInputChar
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_index

    SUBQ.L  #1,ED_TempCopyOffset
    BGE.S   .after_index_update

    MOVEQ   #39,D0
    MOVE.L  D0,ED_TempCopyOffset
    BRA.S   .after_index_update

.case_increment_index:
    ADDQ.L  #1,ED_TempCopyOffset
    MOVEQ   #40,D0
    CMP.L   ED_TempCopyOffset,D0
    BNE.S   .after_index_update

    CLR.L   ED_TempCopyOffset

.after_index_update:
    MOVE.L  ED_TempCopyOffset,D0
    TST.L   D0
    BMI.S   .skip_refresh

    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .skip_refresh

    JSR     ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(PC)

.skip_refresh:
    JSR     ED_DrawDiagnosticRegisterValues(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleSpecialFunctionsMenu   (Handle ESC special functions menuuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ED_GetEscMenuActionCode, ED_DrawAreYouSurePrompt, ED_DrawMenuSelectionHighlight, ED_DrawDiagnosticRegisterValues,
;   ED_DrawESCMenuBottomHelp, ED_DrawSpecialFunctionsMenu,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVORectFill
; READS:
;   ED_EditCursorOffset, ED_MenuStateId
; WRITES:
;   ED_MenuStateId, ED_EditCursorOffset, ED_TempCopyOffset
; DESC:
;   Dispatches ESC special-functions menu selection and updates display state.
; NOTES:
;   Uses a switch/jumptable on the key code returned by ED_GetEscMenuActionCode.
;------------------------------------------------------------------------------
ED_HandleSpecialFunctionsMenu:
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
    JSR     ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_show_label_1d1b:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     DATA_ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT_1D1B
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$b,ED_MenuStateId

    BRA.W   .return

.case_show_label_1d1c:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     DATA_ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT_1D1C
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$c,ED_MenuStateId
    BRA.W   .return

.case_show_label_1d1d:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     DATA_ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL_1D1D
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$d,ED_MenuStateId
    BRA.W   .return

.case_show_reboot_warning:
    JSR     ED_DrawAreYouSurePrompt(PC)

    PEA     Global_STR_COMPUTER_WILL_RESET
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_GO_OFF_AIR_FOR_1_2_MINS
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.B  #$e,ED_MenuStateId
    BRA.W   .return

.case_prev_special_selection:
    SUBQ.L  #1,ED_EditCursorOffset
    BGE.S   .redraw_special_menu

    MOVEQ   #3,D0
    MOVE.L  D0,ED_EditCursorOffset

.redraw_special_menu:
    PEA     4.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_draw_color_bars:
    MOVEQ   #2,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.W   .case_next_special_selection

    MOVE.B  #$f,ED_MenuStateId

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVEQ   #115,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVEQ   #95,D2
    ADD.L   D2,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #265,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #340,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #415,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$1ea,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$235,D2
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$280,D2
    JSR     _LVORectFill(A6)

    CLR.L   ED_TempCopyOffset
    JSR     ED_DrawDiagnosticRegisterValues(PC)

    BRA.S   .return

.case_next_special_selection:
    ADDQ.L  #1,ED_EditCursorOffset
    MOVEQ   #4,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.S   .after_selection_wrap

    CLR.L   ED_EditCursorOffset

.after_selection_wrap:
    MOVE.L  D0,-(A7)
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_SaveEverythingToDisk   (Save everything to diskuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, DISKIO2_RunDiskSyncWorkflow,
;   ED_DrawESCMenuBottomHelp
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving EVERYTHING to disk" and triggers a save operation.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_SaveEverythingToDisk:
; Print 'Saving "EVERYTHING" to disk'
    MOVE.L  D7,-(A7)
    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_everything_message

    PEA     Global_STR_SAVING_EVERYTHING_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     DISKIO2_RunDiskSyncWorkflow(PC)

    LEA     20(A7),A7

.after_save_everything_message:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_SavePrevueDataToDisk   (Save Prevue data to diskuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, DISKIO2_WriteCurDayDataFile,
;   ED_DrawESCMenuBottomHelp
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving Prevue data to disk" and triggers the save routine.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_SavePrevueDataToDisk:
    MOVE.L  D7,-(A7)
    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_prevue_message

    PEA     Global_STR_SAVING_PREVUE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     DISKIO2_WriteCurDayDataFile(PC)

    LEA     16(A7),A7

.after_save_prevue_message:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_LoadTextAdsFromDh2   (Load text ads from DH2uncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile,
;   ED_DrawESCMenuBottomHelp
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a loading message and invokes the text-ads load routine.
; NOTES:
;   Skips display/trigger if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_LoadTextAdsFromDh2:
    MOVE.L  D7,-(A7)

    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_load_text_ads

    PEA     Global_STR_LOADING_TEXT_ADS_FROM_DH2
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(PC)

    LEA     16(A7),A7

.after_load_text_ads:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RebootComputer   (Reboot computeruncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D6/D7
; CALLS:
;   ED_IsConfirmKey, DISPLIB_DisplayTextAtPosition, ED1_JMPTBL_ESQ_ColdReboot,
;   ED_DrawESCMenuBottomHelp
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a reboot message, delays briefly, and triggers a cold reboot.
; NOTES:
;   Skips display/reboot if ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
ED_RebootComputer:
; display 'rebooting computer' while requesting a reboot through supervisor?
    MOVEM.L D6-D7,-(A7)

    JSR     ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_reboot

    PEA     Global_STR_REBOOTING_COMPUTER     ; string
    PEA     120.W                           ; y
    PEA     40.W                            ; x
    MOVE.L  Global_REF_RASTPORT_1,-(A7)                  ; rastport
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
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditAttributesMenu   (Handle edit attributes menuuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D4
; CALLS:
;   ED_DrawCursorChar, ED_RedrawCursorChar, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, ED_DrawAdEditingScreen, ED_LoadCurrentAdIntoBuffers,
;   ED_DrawHelpPanels, ED_UpdateAdNumberDisplay, DISPLIB_DisplayTextAtPosition,
;   GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_MATH_DivS32,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   ED_LastKeyCode, ED_EditCursorOffset, ED_AdNumberInputDigitTens, ED_AdNumberInputDigitOnes, ED_MaxAdNumber, ED_MenuStateId
; WRITES:
;   ED_EditCursorOffset, ED_EditBufferScratch, ED_MenuStateId, ED_SaveTextAdsOnExitFlag, Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Handles edit-attributes input, updating the buffer and selected ad number.
; NOTES:
;   Accepts numeric keys and special menu codes (e.g., $8E).
;------------------------------------------------------------------------------
ED_HandleEditAttributesMenu:
; Draw 'Edit Attributes' menu
    MOVEM.L D2-D4,-(A7)
    JSR     ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
    SUBQ.W  #8,D0
    BEQ.S   .case_backspace

    SUBQ.W  #5,D0
    BEQ.S   .case_commit_ad_number

    SUBI.W  #$8e,D0
    BEQ.S   .case_nav_key

    BRA.W   .case_digit_input

.case_backspace:
    MOVE.L  ED_EditCursorOffset,D0
    MOVEQ   #12,D1
    CMP.L   D1,D0
    BLE.S   .after_backspace

    SUBQ.L  #1,ED_EditCursorOffset
    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  #$20,(A0)

.after_backspace:
    JSR     ED_DrawCursorChar(PC)

    BRA.W   .refresh_attribute_display

.case_nav_key:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,ED_LastMenuInputChar
    MOVEQ   #67,D1
    CMP.B   D1,D0
    BNE.S   .after_nav_key

    MOVEQ   #13,D1
    MOVE.L  D1,ED_EditCursorOffset
    BRA.W   .refresh_attribute_display

.after_nav_key:
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.W   .refresh_attribute_display

    MOVEQ   #12,D0
    MOVE.L  D0,ED_EditCursorOffset
    BRA.W   .refresh_attribute_display

.case_commit_ad_number:
    MOVE.B  ED_AdNumberInputDigitTens,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .ad_second_blank

    MOVE.B  ED_AdNumberInputDigitOnes,D2
    CMP.B   D1,D2
    BEQ.S   .ad_both_blank

    MOVEQ   #0,D3
    MOVE.B  D2,D3
    MOVEQ   #48,D4
    SUB.L   D4,D3
    MOVE.L  D3,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_both_blank:
    MOVEQ   #1,D3
    MOVE.L  D3,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_second_blank:
    MOVE.B  ED_AdNumberInputDigitOnes,D2
    CMP.B   D1,D2
    BNE.S   .ad_two_digits

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D3
    SUB.L   D3,D1
    MOVE.L  D1,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
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
    MOVE.L  D0,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER

.ad_number_ready:
    MOVE.L  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   ED_MaxAdNumber,D0
    BLE.S   .ad_number_in_range

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     DATA_ED2_STR_NUMBER_TOO_BIG_1D24
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_in_range:
    TST.L   D0
    BNE.S   .ad_number_mode2

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     DATA_ED2_STR_NUMBER_TOO_SMALL_1D25
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_mode2:
    MOVE.B  ED_MenuStateId,D0
    SUBQ.B  #2,D0
    BNE.S   .ad_number_other_mode

    MOVE.B  #$4,ED_MenuStateId
    JSR     ED_DrawAdEditingScreen(PC)

    JSR     ED_LoadCurrentAdIntoBuffers(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,ED_SaveTextAdsOnExitFlag
    BRA.W   .return

.ad_number_other_mode:
    MOVE.B  #$5,ED_MenuStateId
    PEA     6.W
    JSR     ED_DrawHelpPanels(PC)

    JSR     ED_UpdateAdNumberDisplay(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     DATA_ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT_1D26
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     DATA_ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION_1D27
    PEA     360.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     DATA_ED2_STR_PUSH_ANY_KEY_TO_SELECT_1D28
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     52(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .return

.case_digit_input:
    MOVE.B  ED_LastKeyCode,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BCS.S   .refresh_attribute_display

    MOVEQ   #57,D1
    CMP.B   D1,D0
    BHI.S   .refresh_attribute_display

    JSR     ED_DrawCursorChar(PC)

    LEA     ED_EditBufferScratch,A0
    MOVE.L  ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    MOVE.B  ED_LastKeyCode,(A0)
    CMPI.L  #$d,ED_EditCursorOffset
    BGE.S   .refresh_attribute_display

    JSR     ED_DrawCursorChar(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_EditCursorOffset,A0
    ADDQ.L  #1,ED_EditCursorOffset
    MOVE.B  ED_LastKeyCode,(A0)

.refresh_attribute_display:
    JSR     ED_RedrawCursorChar(PC)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_HandleEditAttributesInput   (Handle edit attributes inputuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   ED_DrawESCMenuBottomHelp, ED_IncrementAdNumber, ED_DecrementAdNumber, ESQDISP_TestWordIsZeroBooleanize, ED_ApplyActiveFlagToAdData,
;   ED_UpdateActiveInactiveIndicator
; READS:
;   ED_LastKeyCode, ED_AdActiveFlag, ED_StateRingIndex, ED_StateRingTable
; WRITES:
;   ED_AdActiveFlag, ED_SaveTextAdsOnExitFlag, DATA_WDISP_BSS_LONG_21FE
; DESC:
;   Processes edit-attribute key codes and commits changes to state variables.
; NOTES:
;   Recognizes key code $80 with modifier bytes to trigger ED_IncrementAdNumber/ED_DecrementAdNumber.
;------------------------------------------------------------------------------
ED_HandleEditAttributesInput:
    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
    SUBI.W  #13,D0
    BEQ.S   .case_show_help

    SUBI.W  #14,D0
    BEQ.S   .case_show_help

    SUBI.W  #$80,D0
    BNE.S   .case_adjust_21ea

    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
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
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVEQ   #65,D0
    CMP.B   2(A0),D0
    BNE.S   .return

    JSR     ED_DecrementAdNumber(PC)

    BRA.S   .return

.case_show_help:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,ED_SaveTextAdsOnExitFlag
    JSR     ED_ApplyActiveFlagToAdData(PC)

    BRA.S   .return

.case_adjust_21ea:
    MOVE.L  ED_AdActiveFlag,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     ESQDISP_TestWordIsZeroBooleanize(PC)

    ADDQ.W  #4,A7
    EXT.L   D0
    MOVE.L  D0,ED_AdActiveFlag
    MOVEQ   #1,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21FE

.return:
    JSR     ED_UpdateActiveInactiveIndicator(PC)

    RTS
