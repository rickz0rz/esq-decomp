    XDEF    ED_DispatchEscMenuState
    XDEF    ED_HandleEditorInput


;------------------------------------------------------------------------------
; FUNC: ED_DispatchEscMenuState   (Dispatch ESC menu stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/D0/D1
; CALLS:
;   ED2_HandleMenuActions, ED1_HandleEscMenuInput, _ED1_UpdateEscMenuSelection,
;   _ED2_HandleScrollSpeedSelection, _ED2_HandleDiagnosticsMenuActions,
;   _ED_EnterTextEditMode, _ED_CaptureKeySequence, _ED_HandleDiagnosticNibbleEdit,
;   _ED_HandleSpecialFunctionsMenu, _ED_SaveEverythingToDisk, _ED_SavePrevueDataToDisk,
;   _ED_LoadTextAdsFromDh2, _ED_RebootComputer, _ED_HandleEditAttributesMenu,
;   ED_HandleEditAttributesInput, ED_HandleEditorInput,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_StateRingIndex, _ED_StateRingWriteIndex, ED_MenuDispatchReentryGuard, _ED_MenuStateId, _Global_UIBusyFlag
; WRITES:
;   ED_MenuDispatchReentryGuard, _ED_LastKeyCode, _ED_StateRingIndex
; DESC:
;   Dispatches ESC-menu state handlers based on _ED_MenuStateId using a jumptable.
; NOTES:
;   Increments _ED_StateRingIndex modulo $14 after each dispatch.
;------------------------------------------------------------------------------
ED_DispatchEscMenuState:
    MOVE.L  _ED_StateRingIndex,D0
    MOVE.L  _ED_StateRingWriteIndex,D1
    CMP.L   D0,D1
    BEQ.W   .lab_0677

    TST.L   ED_MenuDispatchReentryGuard
    BEQ.W   .lab_0677

    CLR.L   ED_MenuDispatchReentryGuard
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_ED_LastKeyCode
    TST.W   _Global_UIBusyFlag
    BEQ.S   .after_pen_setup

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

.after_pen_setup:
    MOVE.B  _ED_MenuStateId,D0
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
    BSR.W   _ED_CaptureKeySequence

    BRA.S   .advance_index

.case_handle_esc_menu_input:
    BSR.W   ED1_HandleEscMenuInput

    BRA.S   .advance_index

.case_edit_attributes_menu:
    BSR.W   _ED_HandleEditAttributesMenu

    BRA.S   .advance_index

.case_edit_attributes_input:
    BSR.W   ED_HandleEditAttributesInput

    BRA.S   .advance_index

.case_handle_editor_input:
    BSR.W   ED_HandleEditorInput

    BRA.S   .advance_index

.case_call_06c0:
    BSR.W   _ED_EnterTextEditMode

    BRA.S   .advance_index

.case_scroll_speed:
    JSR     _ED2_HandleScrollSpeedSelection(PC)

    BRA.S   .advance_index

.case_diagnostics_actions:
    JSR     _ED2_HandleDiagnosticsMenuActions(PC)

    BRA.S   .advance_index

.case_update_esc_menu_selection:
    BSR.W   _ED1_UpdateEscMenuSelection

    BRA.S   .advance_index

.case_call_06db:
    BSR.W   _ED_HandleSpecialFunctionsMenu

    BRA.S   .advance_index

.case_save_everything:
    BSR.W   _ED_SaveEverythingToDisk

    BRA.S   .advance_index

.case_save_prevue_data:
    BSR.W   _ED_SavePrevueDataToDisk

    BRA.S   .advance_index

.case_load_text_ads:
    BSR.W   _ED_LoadTextAdsFromDh2

    BRA.S   .advance_index

.case_reboot_computer:
    BSR.W   _ED_RebootComputer

    BRA.S   .advance_index

.case_call_06ce:
    BSR.W   _ED_HandleDiagnosticNibbleEdit

.case_noop:
.advance_index:
    ADDQ.L  #1,_ED_StateRingIndex
    CMPI.L  #$14,_ED_StateRingIndex
    BLT.S   .after_wrap_index

    CLR.L   _ED_StateRingIndex

.after_wrap_index:
    MOVEQ   #1,D0
    MOVE.L  D0,ED_MenuDispatchReentryGuard

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
;   _ED_DrawCursorChar, _ED_ApplyActiveFlagToAdData, _ED_RedrawAllRows, ED_RedrawRow, ED_TransformLineSpacing_Mode1, ED_TransformLineSpacing_Mode2, ED_TransformLineSpacing_Mode3,
;   _ED_CommitCurrentAdEdits, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble,
;   ED1_JMPTBL_LADFUNC_MergeHighLowNibbles, ED1_JMPTBL_LADFUNC_PackNibblesToByte, ED1_JMPTBL_MEM_Move,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AG_JMPTBL_MATH_DivS32,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _ED_LastKeyCode, _ED_LastMenuInputChar, ED_CurrentChar, _ED_EditCursorOffset, ED_ViewportOffset, _ED_BlockOffset, _ED_TextLimit,
;   ED_TextModeReinitPendingFlag, Global_REF_BOOL_IS_TEXT_OR_CURSOR, Global_REF_BOOL_IS_LINE_OR_PAGE
; WRITES:
;   ED_TextModeReinitPendingFlag, ED_CurrentChar, _ED_EditCursorOffset, ED_ViewportOffset, _ED_AdActiveFlag, _ED_TempCopyOffset,
;   Global_REF_BOOL_IS_TEXT_OR_CURSOR, Global_REF_BOOL_IS_LINE_OR_PAGE
; DESC:
;   Handles editor input commands: character changes, cursor movement, and
;   line/page operations.
; NOTES:
;   Switch-like chain on _ED_LastKeyCode and a secondary branch on _ED_LastMenuInputChar.
;------------------------------------------------------------------------------
ED_HandleEditorInput:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A2,-(A7)
    TST.L   ED_TextModeReinitPendingFlag
    BEQ.S   .after_pending_init

    MOVEQ   #1,D0
    MOVE.L  D0,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),ED_CurrentChar
    CLR.L   ED_TextModeReinitPendingFlag

.after_pending_init:
    JSR     _ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
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
    MOVE.L  D0,ED_TextModeReinitPendingFlag
    JSR     _ED_CommitCurrentAdEdits(PC)

    JSR     _ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_page_down:
    MOVE.L  _ED_TextLimit,D0
    MOVE.L  D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .page_down_clamp

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_EditCursorOffset
    BRA.W   .finalize_update

.page_down_clamp:
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_EditCursorOffset
    BRA.W   .finalize_update

.case_enable_insert_mode:
    MOVEQ   #1,D0
    MOVE.L  D0,_ED_AdActiveFlag
    JSR     _ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_disable_insert_mode:
    CLR.L   _ED_AdActiveFlag
    JSR     _ED_ApplyActiveFlagToAdData(PC)

    BRA.W   .finalize_update

.case_adjust_char_prev:
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,16(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

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

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    BRA.W   .finalize_update

.case_adjust_char_next:
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

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

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
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
    TST.L   _ED_EditCursorOffset
    BEQ.W   .finalize_update

    SUBQ.L  #1,_ED_EditCursorOffset

.case_delete_at_cursor:
    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .delete_eol_refresh

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .delete_page_mode_update

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,_ED_TempCopyOffset
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .delete_line_mode_update

    LEA     ED_EditBufferScratchShiftBase,A0
    ADDA.L  D1,A0
    LEA     _ED_EditBufferScratch,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLiveShiftBase,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     _ED_EditBufferLive,A1
    ADDA.L  D0,A1
    MOVE.L  _ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.delete_line_mode_update:
    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_TempCopyOffset,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     _ED_EditBufferLive,A0
    MOVE.L  _ED_TempCopyOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLiveIndexBaseMinus1,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.delete_page_mode_update:
    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,_ED_TempCopyOffset
    LEA     ED_EditBufferScratchShiftBase,A0
    MOVE.L  _ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    LEA     _ED_EditBufferScratch,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     ED_EditBufferLiveShiftBase,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     _ED_EditBufferLive,A1
    ADDA.L  D0,A1
    MOVE.L  _ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_TempCopyOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     _ED_EditBufferLive,A1
    MOVE.L  _ED_TempCopyOffset,D0
    ADDA.L  D0,A1
    LEA     ED_EditBufferLiveIndexBaseMinus1,A2
    ADDA.L  D0,A2
    MOVE.B  (A2),(A1)
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     _ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.W   .finalize_update

.delete_eol_refresh:
    LEA     ED_EditBufferScratchIndexBaseMinus1,A0
    ADDA.L  _ED_BlockOffset,A0
    MOVE.B  #$20,(A0)
    JSR     _ED_DrawCursorChar(PC)

    BRA.W   .finalize_update

.case_nav_key:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,_ED_LastMenuInputChar
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
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #39,D1
    CMP.L   D1,D0
    BLE.W   .finalize_update

    MOVEQ   #40,D1
    SUB.L   D1,_ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_down_row:
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    ADD.L   D0,_ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_right:
    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    ADDQ.L  #1,_ED_EditCursorOffset
    BRA.W   .finalize_update

.nav_left:
    MOVE.L  _ED_EditCursorOffset,D0
    TST.L   D0
    BLE.W   .finalize_update

    SUBQ.L  #1,_ED_EditCursorOffset
    BRA.W   .finalize_update

.case_handle_alt_code:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  2(A0),D0
    MOVE.B  D0,_ED_LastKeyCode
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .after_alt_code

    JSR     ED_NextAdNumber(PC)

.after_alt_code:
    MOVE.B  _ED_LastKeyCode,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .finalize_update

    JSR     ED_PrevAdNumber(PC)

    BRA.W   .finalize_update

.case_enter_mode_9:
    MOVE.B  #$9,_ED_MenuStateId
    JSR     ED_DrawEditHelpText(PC)

    BRA.W   .finalize_update

.case_sync_cursor_line_page:
    MOVEQ   #1,D0
    CMP.L   Global_REF_BOOL_IS_LINE_OR_PAGE,D0
    BNE.S   .cursor_from_line_index

    CLR.L   _ED_EditCursorOffset
    BRA.W   .finalize_update

.cursor_from_line_index:
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_EditCursorOffset
    BRA.W   .finalize_update

.case_toggle_line_page_mode:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  Global_REF_BOOL_IS_LINE_OR_PAGE,D0
    ADDQ.L  #1,D0
    MOVEQ   #2,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,Global_REF_BOOL_IS_LINE_OR_PAGE
    BEQ.S   .select_line_page_label

    LEA     ED2_STR_PAGE,A0
    BRA.S   .draw_line_page_label

.select_line_page_label:
    LEA     ED2_STR_LINE,A0

.draw_line_page_label:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
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
    CMP.L   _ED_TextLimit,D0
    BGE.S   .action_0831_done

    JSR     ED_TransformLineSpacing_Mode3(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0831_loop

.action_0831_done:
    CLR.L   _ED_EditCursorOffset
    JSR     _ED_RedrawAllRows(PC)

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
    CMP.L   _ED_TextLimit,D0
    BGE.S   .action_0813_done

    JSR     ED_TransformLineSpacing_Mode1(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0813_loop

.action_0813_done:
    CLR.L   _ED_EditCursorOffset
    JSR     _ED_RedrawAllRows(PC)

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
    CMP.L   _ED_TextLimit,D0
    BGE.S   .action_0822_done

    JSR     ED_TransformLineSpacing_Mode2(PC)

    ADDQ.L  #1,ED_ViewportOffset
    BRA.S   .action_0822_loop

.action_0822_done:
    CLR.L   _ED_EditCursorOffset
    JSR     _ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_clear_line_or_page:
    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .clear_page_setup

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.clear_line_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_line_space_loop
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
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
    MOVE.L  _ED_BlockOffset,D0
    MOVEQ   #32,D1
    LEA     _ED_EditBufferScratch,A0
    BRA.S   .clear_page_space_check

.clear_page_space_loop:
    MOVE.B  D1,(A0)+

.clear_page_space_check:
    SUBQ.L  #1,D0
    BCC.S   .clear_page_space_loop

    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  _ED_BlockOffset,D1
    LEA     _ED_EditBufferLive,A0
    BRA.S   .clear_page_char_check

.clear_page_char_loop:
    MOVE.B  D0,(A0)+

.clear_page_char_check:
    SUBQ.L  #1,D1
    BCC.S   .clear_page_char_loop

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     _ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_row_shift:
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_ViewportOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVEQ   #40,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  _ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  _ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.insert_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.insert_row_space_loop
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.insert_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.insert_row_char_loop
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    MOVE.L  ED_ViewportOffset,D7

.insert_row_refresh_loop:
    CMP.L   _ED_TextLimit,D7
    BGE.W   .finalize_update

    MOVE.L  D7,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .insert_row_refresh_loop

.case_delete_row_shift:
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVE.L  ED_ViewportOffset,D1
    CMP.L   D0,D1
    BGE.W   .finalize_update

    MOVE.L  D1,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,12(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  12(A7),D0
    MOVE.L  _ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    MOVE.L  ED_ViewportOffset,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    MOVE.L  _ED_BlockOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.delete_row_space_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.delete_row_space_loop
    MOVE.L  _ED_TextLimit,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVEQ   #39,D1

.delete_row_char_loop:
    MOVE.B  D0,(A0)+
    DBF     D1,.delete_row_char_loop
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    MOVE.L  ED_ViewportOffset,D7

.delete_row_refresh_loop:
    CMP.L   _ED_TextLimit,D7
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
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
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
    MOVE.L  _ED_BlockOffset,D1
    LEA     _ED_EditBufferLive,A0
    BRA.S   .fill_page_chars_check

.fill_page_chars_loop:
    MOVE.B  D0,(A0)+

.fill_page_chars_check:
    SUBQ.L  #1,D1
    BCC.S   .fill_page_chars_loop

    JSR     _ED_RedrawAllRows(PC)

    BRA.W   .finalize_update

.case_insert_char:
    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.W   .insert_char_eol

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .insert_char_page_update

    MOVE.L  ED_ViewportOffset,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,_ED_TempCopyOffset
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .insert_char_line_update

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratchShiftBase,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     _ED_EditBufferLive,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLiveShiftBase,A1
    ADDA.L  D0,A1
    MOVE.L  _ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.insert_char_line_update:
    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    MOVE.L  ED_ViewportOffset,-(A7)
    JSR     ED_RedrawRow(PC)

    ADDQ.W  #4,A7
    BRA.W   .finalize_update

.insert_char_page_update:
    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,_ED_TempCopyOffset
    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    LEA     ED_EditBufferScratchShiftBase,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     _ED_EditBufferLive,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    LEA     ED_EditBufferLiveShiftBase,A1
    ADDA.L  D0,A1
    MOVE.L  _ED_TempCopyOffset,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ED1_JMPTBL_MEM_Move(PC)

    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     _ED_EditBufferLive,A1
    ADDA.L  _ED_EditCursorOffset,A1
    MOVE.B  ED_CurrentChar,(A1)
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    JSR     _ED_RedrawAllRows(PC)

    LEA     20(A7),A7
    BRA.S   .finalize_update

.insert_char_eol:
    LEA     ED_EditBufferScratchIndexBaseMinus1,A0
    ADDA.L  _ED_BlockOffset,A0
    MOVE.B  #$20,(A0)
    JSR     _ED_DrawCursorChar(PC)

    BRA.S   .finalize_update

.case_insert_ascii_char:
    MOVE.B  _ED_LastKeyCode,D0
    MOVEQ   #25,D1
    CMP.B   D1,D0
    BLS.S   .finalize_update

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #64,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BGE.S   .finalize_update

    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_EditCursorOffset,D1
    ADDA.L  D1,A0
    MOVE.B  D0,(A0)
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  ED_CurrentChar,(A0)
    JSR     _ED_DrawCursorChar(PC)

    MOVE.L  _ED_BlockOffset,D0
    SUBQ.L  #1,D0
    MOVE.L  _ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .finalize_update

    ADDQ.L  #1,_ED_EditCursorOffset

.finalize_update:
    TST.L   Global_REF_BOOL_IS_TEXT_OR_CURSOR
    BNE.S   .sync_current_char_from_buffer

    LEA     _ED_EditBufferLive,A0
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  ED_CurrentChar,(A1)
    BRA.S   .after_sync_current_char

.sync_current_char_from_buffer:
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),ED_CurrentChar

.after_sync_current_char:
    MOVE.B  _ED_MenuStateId,D0
    SUBQ.B  #4,D0
    BNE.S   .return

    JSR     _ED_RedrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  ED_CurrentChar,D0
    MOVE.L  D0,-(A7)
    JSR     _ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2/D7/A2
    UNLK    A5
    RTS

;!======