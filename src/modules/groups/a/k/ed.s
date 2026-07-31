    XDEF    ED_DispatchEscMenuState



;------------------------------------------------------------------------------
; FUNC: ED_DispatchEscMenuState   (Dispatch ESC menu stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/D0/D1
; CALLS:
;   _ED2_HandleMenuActions, ED1_HandleEscMenuInput, _ED1_UpdateEscMenuSelection,
;   _ED2_HandleScrollSpeedSelection, _ED2_HandleDiagnosticsMenuActions,
;   _ED_EnterTextEditMode, _ED_CaptureKeySequence, _ED_HandleDiagnosticNibbleEdit,
;   _ED_HandleSpecialFunctionsMenu, _ED_SaveEverythingToDisk, _ED_SavePrevueDataToDisk,
;   _ED_LoadTextAdsFromDh2, _ED_RebootComputer, _ED_HandleEditAttributesMenu,
;   _ED_HandleEditAttributesInput, _ED_HandleEditorInput,
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
    JSR     _ED2_HandleMenuActions(PC)

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
    BSR.W   _ED_HandleEditAttributesInput

    BRA.S   .advance_index

.case_handle_editor_input:
    BSR.W   _ED_HandleEditorInput

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