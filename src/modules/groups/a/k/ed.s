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
;   LAB_06DB,
;   LAB_06E2, LAB_06E4, LAB_06E6,
;   LAB_06E8, LAB_06EC, LAB_06FC, LAB_0678, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
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
    DC.W    .case_call_06ec-.dispatch_table-2
    DC.W    .case_call_06ec-.dispatch_table-2
    DC.W    .case_handle_editor_input-.dispatch_table-2
    DC.W    .case_call_06fc-.dispatch_table-2
    DC.W    .case_scroll_speed-.dispatch_table-2
    DC.W    .case_diagnostics_actions-.dispatch_table-2
    DC.W    .case_update_esc_menu_selection-.dispatch_table-2
    DC.W    .case_call_06c0-.dispatch_table-2
    DC.W    .case_call_06db-.dispatch_table-2
    DC.W    .case_call_06e2-.dispatch_table-2
    DC.W    .case_call_06e4-.dispatch_table-2
    DC.W    .case_call_06e6-.dispatch_table-2
    DC.W    .case_call_06e8-.dispatch_table-2
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

.case_call_06ec:
    BSR.W   LAB_06EC

    BRA.S   .advance_index

.case_call_06fc:
    BSR.W   LAB_06FC

    BRA.S   .advance_index

.case_handle_editor_input:
    BSR.W   LAB_0678

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
    BSR.W   LAB_06DB

    BRA.S   .advance_index

.case_call_06e2:
    BSR.W   LAB_06E2

    BRA.S   .advance_index

.case_call_06e4:
    BSR.W   LAB_06E4

    BRA.S   .advance_index

.case_call_06e6:
    BSR.W   LAB_06E6

    BRA.S   .advance_index

.case_call_06e8:
    BSR.W   LAB_06E8

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

LAB_0678:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A2,-(A7)
    TST.L   LAB_1D15
    BEQ.S   .LAB_0679

    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1
    CLR.L   LAB_1D15

.LAB_0679:
    JSR     LAB_07F4(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #1,D0
    BEQ.W   .LAB_067D

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0680

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0681

    SUBQ.W  #3,D0
    BEQ.W   .LAB_067F

    SUBQ.W  #2,D0
    BEQ.W   .LAB_0684

    SUBQ.W  #1,D0
    BEQ.W   .LAB_06BC

    SUBQ.W  #4,D0
    BEQ.S   .LAB_067B

    SUBQ.W  #1,D0
    BEQ.W   .LAB_067E

    SUBI.W  #13,D0
    BEQ.S   .LAB_067A

    SUBI.W  #$64,D0
    BEQ.W   .LAB_0685

    SUBI.W  #$1c,D0
    BEQ.W   .LAB_0689

    BRA.W   .LAB_06BB

.LAB_067A:
    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,LAB_1D15
    JSR     LAB_0852(PC)

    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   .return

.LAB_067B:
    MOVE.L  LAB_21FB,D0
    MOVE.L  D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .LAB_067C

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_067C:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_067D:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21EA
    JSR     LAB_0805(PC)

    BRA.W   .LAB_06BC

.LAB_067E:
    CLR.L   LAB_21EA
    JSR     LAB_0805(PC)

    BRA.W   .LAB_06BC

.LAB_067F:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,16(A7)
    JSR     LAB_0859(PC)

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
    BNE.W   .LAB_06BC

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   .LAB_06BC

.LAB_0680:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_085D(PC)

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
    BNE.W   .LAB_06BC

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   .LAB_06BC

.LAB_0681:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.S   .LAB_0682

    MOVEQ   #0,D1
    BRA.S   .LAB_0683

.LAB_0682:
    MOVE.L  D0,D1

.LAB_0683:
    MOVE.L  D1,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D1,-(A7)
    JSR     SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_0684:
    TST.L   LAB_21E8
    BEQ.W   .LAB_06BC

    SUBQ.L  #1,LAB_21E8

.LAB_0685:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .LAB_0688

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .LAB_0687

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .LAB_0686

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

.LAB_0686:
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
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_0687:
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
    JSR     LAB_0808(PC)

    LEA     20(A7),A7
    BRA.W   .LAB_06BC

.LAB_0688:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     LAB_07F4(PC)

    BRA.W   .LAB_06BC

.LAB_0689:
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
    BEQ.W   .LAB_068E

    SUBI.W  #16,D1
    BEQ.W   .LAB_0691

    SUBQ.W  #1,D1
    BEQ.W   .LAB_0693

    SUBQ.W  #1,D1
    BEQ.W   .LAB_0696

    SUBQ.W  #1,D1
    BEQ.W   .LAB_069A

    SUBQ.W  #1,D1
    BEQ.W   .LAB_069E

    SUBQ.W  #1,D1
    BEQ.W   .LAB_06A2

    SUBQ.W  #1,D1
    BEQ.W   .LAB_06AA

    SUBQ.W  #1,D1
    BEQ.W   .LAB_06AE

    SUBQ.W  #1,D1
    BEQ.W   .LAB_06B2

    SUBQ.W  #1,D1
    BEQ.W   .LAB_06B7

    SUBQ.W  #6,D1
    BEQ.W   .LAB_0690

    SUBQ.W  #2,D1
    BEQ.S   .LAB_068A

    SUBQ.W  #1,D1
    BEQ.S   .LAB_068B

    SUBQ.W  #1,D1
    BEQ.S   .LAB_068C

    SUBQ.W  #1,D1
    BEQ.S   .LAB_068D

    BRA.W   .LAB_06BC

.LAB_068A:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #39,D1
    CMP.L   D1,D0
    BLE.W   .LAB_06BC

    MOVEQ   #40,D1
    SUB.L   D1,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_068B:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .LAB_06BC

    MOVEQ   #40,D0
    ADD.L   D0,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_068C:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .LAB_06BC

    ADDQ.L  #1,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_068D:
    MOVE.L  LAB_21E8,D0
    TST.L   D0
    BLE.W   .LAB_06BC

    SUBQ.L  #1,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_068E:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  2(A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .LAB_068F

    JSR     LAB_0853(PC)

.LAB_068F:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .LAB_06BC

    JSR     LAB_0855(PC)

    BRA.W   .LAB_06BC

.LAB_0690:
    MOVE.B  #$9,LAB_1D13
    JSR     LAB_0857(PC)

    BRA.W   .LAB_06BC

.LAB_0691:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE,D0
    BNE.S   .LAB_0692

    CLR.L   LAB_21E8
    BRA.W   .LAB_06BC

.LAB_0692:
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   .LAB_06BC

.LAB_0693:
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
    BEQ.S   .LAB_0694

    LEA     LAB_1D16,A0
    BRA.S   .LAB_0695

.LAB_0694:
    LEA     LAB_1D17,A0

.LAB_0695:
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

    BRA.W   .LAB_06BC

.LAB_0696:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .LAB_0697

    JSR     LAB_0831(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_0697:
    CLR.L   LAB_21E9

.LAB_0698:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .LAB_0699

    JSR     LAB_0831(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .LAB_0698

.LAB_0699:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   .LAB_06BC

.LAB_069A:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .LAB_069B

    JSR     LAB_0813(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_069B:
    CLR.L   LAB_21E9

.LAB_069C:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .LAB_069D

    JSR     LAB_0813(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .LAB_069C

.LAB_069D:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   .LAB_06BC

.LAB_069E:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .LAB_069F

    JSR     LAB_0822(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_069F:
    CLR.L   LAB_21E9

.LAB_06A0:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   .LAB_06A1

    JSR     LAB_0822(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   .LAB_06A0

.LAB_06A1:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   .LAB_06BC

.LAB_06A2:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .LAB_06A5

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

.LAB_06A3:
    MOVE.B  D1,(A0)+
    DBF     D0,.LAB_06A3
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.LAB_06A4:
    MOVE.B  D0,(A0)+
    DBF     D1,.LAB_06A4
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_06A5:
    MOVE.L  LAB_21EB,D0
    MOVEQ   #32,D1
    LEA     LAB_21F0,A0
    BRA.S   .LAB_06A7

.LAB_06A6:
    MOVE.B  D1,(A0)+

.LAB_06A7:
    SUBQ.L  #1,D0
    BCC.S   .LAB_06A6

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   .LAB_06A9

.LAB_06A8:
    MOVE.B  D0,(A0)+

.LAB_06A9:
    SUBQ.L  #1,D1
    BCC.S   .LAB_06A8

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     LAB_0808(PC)

    BRA.W   .LAB_06BC

.LAB_06AA:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   .LAB_06BC

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

.LAB_06AB:
    MOVE.B  D1,(A0)+
    DBF     D0,.LAB_06AB
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.LAB_06AC:
    MOVE.B  D0,(A0)+
    DBF     D1,.LAB_06AC
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

.LAB_06AD:
    CMP.L   LAB_21FB,D7
    BGE.W   .LAB_06BC

    MOVE.L  D7,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .LAB_06AD

.LAB_06AE:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   .LAB_06BC

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

.LAB_06AF:
    MOVE.B  D1,(A0)+
    DBF     D0,.LAB_06AF
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.LAB_06B0:
    MOVE.B  D0,(A0)+
    DBF     D1,.LAB_06B0
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

.LAB_06B1:
    CMP.L   LAB_21FB,D7
    BGE.W   .LAB_06BC

    MOVE.L  D7,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .LAB_06B1

.LAB_06B2:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .LAB_06B4

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

.LAB_06B3:
    MOVE.B  D0,(A0)+
    DBF     D1,.LAB_06B3
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_06B4:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   .LAB_06B6

.LAB_06B5:
    MOVE.B  D0,(A0)+

.LAB_06B6:
    SUBQ.L  #1,D1
    BCC.S   .LAB_06B5

    JSR     LAB_0808(PC)

    BRA.W   .LAB_06BC

.LAB_06B7:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   .LAB_06BA

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   .LAB_06B9

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .LAB_06B8

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

.LAB_06B8:
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_06BC

.LAB_06B9:
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
    JSR     LAB_0808(PC)

    LEA     20(A7),A7
    BRA.S   .LAB_06BC

.LAB_06BA:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     LAB_07F4(PC)

    BRA.S   .LAB_06BC

.LAB_06BB:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #25,D1
    CMP.B   D1,D0
    BLS.S   .LAB_06BC

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #64,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BGE.S   .LAB_06BC

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    MOVE.B  D0,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    JSR     LAB_07F4(PC)

    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   .LAB_06BC

    ADDQ.L  #1,LAB_21E8

.LAB_06BC:
    TST.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    BNE.S   .LAB_06BD

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  LAB_21E1,(A1)
    BRA.S   .LAB_06BE

.LAB_06BD:
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1

.LAB_06BE:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #4,D0
    BNE.S   .return

    JSR     LAB_07F3(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_07F8(PC)

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
;   LAB_0812, LAB_0808, LAB_07F3, LAB_07F8
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
    JSR     LAB_0812(PC)

    JSR     LAB_0808(PC)

    JSR     LAB_07F3(PC)

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     LAB_07F8(PC)

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
;   DRAW_BOTTOM_HELP_FOR_ESC_MENU, ED1_JMPTBL_LAB_0CA7, LAB_07EE
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
    JSR     LAB_07EE(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_06DB:
    MOVEM.L D2-D3/D7,-(A7)
    JSR     LAB_07D4(PC)

    MOVE.L  D0,D7
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #8,D0
    BCC.W   LAB_06DF

    ADD.W   D0,D0

    MOVE.W  LAB_06DC(PC,D0.W),D0
    JMP     LAB_06DC+2(PC,D0.W)

; switch/jumptable
LAB_06DC:
    DC.W    LAB_06DC_000E-LAB_06DC-2
	DC.W    LAB_06DC_0016-LAB_06DC-2
    DC.W    LAB_06DC_0042-LAB_06DC-2
	DC.W    LAB_06DC_006E-LAB_06DC-2
    DC.W    LAB_06DC_009A-LAB_06DC-2
    DC.W    LAB_06DF-LAB_06DC-2
	DC.W    LAB_06DE_0100-LAB_06DC-2
    DC.W    LAB_06DC_00DE-LAB_06DC-2

LAB_06DC_000E:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   LAB_06E1

LAB_06DC_0016:
    JSR     LAB_07EF(PC)

    PEA     LAB_1D1B
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$b,LAB_1D13

    BRA.W   LAB_06E1

LAB_06DC_0042:
    JSR     LAB_07EF(PC)

    PEA     LAB_1D1C
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$c,LAB_1D13
    BRA.W   LAB_06E1

LAB_06DC_006E:
    JSR     LAB_07EF(PC)

    PEA     LAB_1D1D
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.B  #$d,LAB_1D13
    BRA.W   LAB_06E1

LAB_06DC_009A:
    JSR     LAB_07EF(PC)

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
    BRA.W   LAB_06E1

LAB_06DC_00DE:
    SUBQ.L  #1,LAB_21E8
    BGE.S   LAB_06DE

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_21E8

LAB_06DE:
    PEA     4.W
    JSR     LAB_07E9(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06E1

LAB_06DE_0100:
    MOVEQ   #2,D0
    CMP.L   LAB_21E8,D0
    BNE.W   LAB_06DF

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
    JSR     LAB_07EE(PC)

    BRA.S   LAB_06E1

LAB_06DF:
    ADDQ.L  #1,LAB_21E8
    MOVEQ   #4,D0
    CMP.L   LAB_21E8,D0
    BNE.S   LAB_06E0

    CLR.L   LAB_21E8

LAB_06E0:
    MOVE.L  D0,-(A7)
    JSR     LAB_07E9(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7

LAB_06E1:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

; Print 'Saving "EVERYTHING" to disk'
LAB_06E2:
    MOVE.L  D7,-(A7)
    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E3

    PEA     GLOB_STR_SAVING_EVERYTHING_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     LAB_0484(PC)

    LEA     20(A7),A7

LAB_06E3:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_06E4:
    MOVE.L  D7,-(A7)
    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E5

    PEA     GLOB_STR_SAVING_PREVUE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     LAB_0471(PC)

    LEA     16(A7),A7

LAB_06E5:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_06E6:
    MOVE.L  D7,-(A7)

    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E7

    PEA     GLOB_STR_LOADING_TEXT_ADS_FROM_DH2
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQ_JMPTBL_LAB_0E57(PC)

    LEA     16(A7),A7

LAB_06E7:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

; display 'rebooting computer' while requesting a reboot through supervisor?
LAB_06E8:
    MOVEM.L D6-D7,-(A7)

    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06EB

    PEA     GLOB_STR_REBOOTING_COMPUTER     ; string
    PEA     120.W                           ; y
    PEA     40.W                            ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

LAB_06E9:
    CMPI.L  #$aae60,D6
    BGE.S   LAB_06EA

    ADDQ.L  #1,D6
    ADDQ.L  #1,D6
    BRA.S   LAB_06E9

LAB_06EA:
    JSR     ED1_JMPTBL_ESQ_ColdReboot(PC)

LAB_06EB:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Draw 'Edit Attributes' menu
LAB_06EC:
    MOVEM.L D2-D4,-(A7)
    JSR     LAB_07F4(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #8,D0
    BEQ.S   LAB_06ED

    SUBQ.W  #5,D0
    BEQ.S   LAB_06F1

    SUBI.W  #$8e,D0
    BEQ.S   LAB_06EF

    BRA.W   LAB_06F9

LAB_06ED:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #12,D1
    CMP.L   D1,D0
    BLE.S   LAB_06EE

    SUBQ.L  #1,LAB_21E8
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  #$20,(A0)

LAB_06EE:
    JSR     LAB_07F4(PC)

    BRA.W   LAB_06FA

LAB_06EF:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #67,D1
    CMP.B   D1,D0
    BNE.S   LAB_06F0

    MOVEQ   #13,D1
    MOVE.L  D1,LAB_21E8
    BRA.W   LAB_06FA

LAB_06F0:
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.W   LAB_06FA

    MOVEQ   #12,D0
    MOVE.L  D0,LAB_21E8
    BRA.W   LAB_06FA

LAB_06F1:
    MOVE.B  LAB_21F2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_06F3

    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BEQ.S   LAB_06F2

    MOVEQ   #0,D3
    MOVE.B  D2,D3
    MOVEQ   #48,D4
    SUB.L   D4,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F2:
    MOVEQ   #1,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F3:
    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BNE.S   LAB_06F4

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D3
    SUB.L   D3,D1
    MOVE.L  D1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F4:
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

LAB_06F5:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   LAB_21FD,D0
    BLE.S   LAB_06F6

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

    BRA.W   LAB_06FB

LAB_06F6:
    TST.L   D0
    BNE.S   LAB_06F7

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

    BRA.W   LAB_06FB

LAB_06F7:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #2,D0
    BNE.S   LAB_06F8

    MOVE.B  #$4,LAB_1D13
    JSR     LAB_0812(PC)

    JSR     LAB_084B(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    BRA.W   LAB_06FB

LAB_06F8:
    MOVE.B  #$5,LAB_1D13
    PEA     6.W
    JSR     DRAW_SOME_RECTANGLES(PC)

    JSR     LAB_0803(PC)

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

    BRA.S   LAB_06FB

LAB_06F9:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BCS.S   LAB_06FA

    MOVEQ   #57,D1
    CMP.B   D1,D0
    BHI.S   LAB_06FA

    JSR     LAB_07F4(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  LAB_21ED,(A0)
    CMPI.L  #$d,LAB_21E8
    BGE.S   LAB_06FA

    JSR     LAB_07F4(PC)

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    ADDQ.L  #1,LAB_21E8
    MOVE.B  LAB_21ED,(A0)

LAB_06FA:
    JSR     LAB_07F3(PC)

LAB_06FB:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

LAB_06FC:
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   LAB_06FE

    SUBI.W  #14,D0
    BEQ.S   LAB_06FE

    SUBI.W  #$80,D0
    BNE.S   LAB_06FF

    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D1
    CMP.B   1(A1),D1
    BNE.S   LAB_0700

    ADDA.L  D0,A0
    MOVEQ   #64,D0
    CMP.B   2(A0),D0
    BNE.S   LAB_06FD

    JSR     LAB_07FF(PC)

    BRA.S   LAB_0700

LAB_06FD:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVEQ   #65,D0
    CMP.B   2(A0),D0
    BNE.S   LAB_0700

    JSR     LAB_0801(PC)

    BRA.S   LAB_0700

LAB_06FE:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    JSR     LAB_0805(PC)

    BRA.S   LAB_0700

LAB_06FF:
    MOVE.L  LAB_21EA,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_095F(PC)

    ADDQ.W  #4,A7
    EXT.L   D0
    MOVE.L  D0,LAB_21EA
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21FE

LAB_0700:
    JSR     LAB_080E(PC)

    RTS
